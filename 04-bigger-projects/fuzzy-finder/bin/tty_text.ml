open Core
open Async

module User_input = struct
  type t =
    | Ctrl_c
    | Escape
    | Backspace
    | Return (* Enter key *)
    | Char of char
  [@@deriving sexp_of]
end

module Configure_terminal = struct

  type t = {
    attr_in : Unix.Terminal_io.t;
    attr_out: Unix.Terminal_io.t;
  }

  let setattr_out fd ~attr_out =
    Unix.Terminal_io.tcsetattr
      attr_out
      ~mode:Unix.Terminal_io.TCSAFLUSH
      fd

  let setattr_in fd ~attr_in =
    Unix.Terminal_io.tcsetattr
      attr_in
      ~mode:Unix.Terminal_io.TCSADRAIN
      fd

  let get_current_settings ~input ~output () =
    let%bind attr_in  = Unix.Terminal_io.tcgetattr input in
    let%bind attr_out = Unix.Terminal_io.tcgetattr output in
    return {
      attr_in = attr_in;
      attr_out = attr_out;
    }

  let set ~input ~output t =
    let%bind () = setattr_in  input  ~attr_in:t.attr_in   in
    let%bind () = setattr_out output ~attr_out:t.attr_out in
    return ()

  let map_termio (attrs : Core.Unix.Terminal_io.t) =
    { attrs with
      Core.Unix.Terminal_io.
      c_ignbrk = false;
      c_brkint = false;
      c_parmrk = false;
      c_istrip = false;
      c_inlcr  = false;
      c_igncr  = false;
      c_icrnl  = false;
      c_ixon   = false;
      c_opost  = false;
      c_echo   = false;
      c_echonl = false;
      c_icanon = false;
      c_isig   = false;
      c_csize  = 8;
      c_parenb = false;
      c_vmin = 1;
      c_vtime = 0;
    }
  ;;

  let to_drawing t =
    { attr_in  = map_termio t.attr_in
    ; attr_out = map_termio t.attr_out
    }
  ;;
end

let esc rest =
  "\x1b[" ^ rest
;;

module Direction = struct
  type t =
    | Up
    | Down
    | Left
    | Right
  [@@deriving enumerate]

  let escape = function
    | Up    -> esc "A"
    | Down  -> esc "B"
    | Right -> esc "C"
    | Left  -> esc "D"
end

module Action = struct
  type t =
    | Clear_screen
    | Move_cursor_to_home
    | Next_line
    | Move of Direction.t
    | Switch_to_alternate_buffer
    | Switch_from_alternate_buffer
    | Erase_to_end_of_line

  let _compilation_fix_for_unused_constructor = Move Left

  let to_string = function
    | Clear_screen -> esc "2J"
    | Erase_to_end_of_line -> esc "K"
    | Move_cursor_to_home -> esc "H"
    | Next_line -> "\r\n"
    | Move dir -> Direction.escape dir
    | Switch_to_alternate_buffer -> esc "?1049h"
    | Switch_from_alternate_buffer -> esc "?1049l"
end

let do_action writer action =
  Writer.write writer (Action.to_string action);
  Writer.flushed writer
;;

type t =
  { dimensions : Screen_dimensions.t
  ; writer     : Writer.t
  }

let screen_dimensions { dimensions; _} = dimensions

let stop_rendering t =
  do_action t Switch_from_alternate_buffer
;;

let with_rendering f =
  let%bind tty_reader = Reader.open_file ~buf_len:1 "/dev/tty" in
  let%bind tty_writer = Writer.open_file "/dev/tty" in
  let input  = Reader.fd tty_reader in
  let output = Writer.fd tty_writer in
  let%bind original = Configure_terminal.get_current_settings ~input ~output () in
  let restore () =
    Configure_terminal.set original ~input ~output
  in
  let%bind dimensions =
    let%map output =
      Process.run_exn ()
        ~prog:"stty"
        (* NOTE: for people on Mac OS X, use ~args:[ "-f"; "/dev/tty"; "size" ] *)
        ~args:[ "size"
              ; "-F"
              ; "/dev/tty"
              ]
    in
    match
      output
      |> String.strip
      |> String.split ~on:' '
    with
    | [height;width] ->
      { Screen_dimensions.
        height = Int.of_string height
      ; width = Int.of_string width
      }
    | _ -> raise_s [%message "Could not determine terminal size"]
  in
  Monitor.protect ~finally:restore (fun () ->
    let t = { dimensions; writer = tty_writer } in
    let%bind () =
      Configure_terminal.to_drawing original
      |> Configure_terminal.set ~input ~output
    in
    let%bind () = do_action tty_writer Switch_to_alternate_buffer in
    let%bind () = do_action tty_writer Clear_screen in
    let user_input =
      Pipe.create_reader ~close_on_exception:true (fun w ->
        let repeat x =
          let%bind () = Pipe.write w x in
          return (`Repeat ())
        in
        let b = Bytes.create 1 in
        Deferred.repeat_until_finished () (fun () ->
          match%bind Reader.really_read ~len:1 tty_reader b with
          | `Eof _ -> return (`Finished ())
          | `Ok ->
            match Char.to_int (Bytes.get b 0) with
            | 3 (* CTRL + C *) ->
              let%bind () = Pipe.write w User_input.Ctrl_c in
              return (`Finished ())
            | 0O177 -> repeat Backspace
            | 0O015 -> repeat Return
            | 0O33  -> repeat Escape
            | _     -> repeat (Char (Bytes.get b 0))
        )
      )
    in
    let%bind to_return = f (user_input, t) in
    let%bind () = restore () in
    let%bind () = stop_rendering t.writer in
    return to_return
  )
;;

module Widget = struct
  type t =
    | Text of string
    | Group_horizontally of t list
    | Stack_vertically of t list

  let text text = Text text
  let horizontal_group ts = Group_horizontally ts
  let vertical_group ts = Stack_vertically ts

  let render elts writer =
    let rec process = function
      | Text x -> Writer.writef writer "%s" x
      | Group_horizontally xs ->
        List.iter xs ~f:process
      | Stack_vertically xs ->
        xs
        |> List.map ~f:(fun x -> (fun () -> process x))
        |> List.intersperse ~sep:(fun () -> Writer.writef writer !"%{Action}%{Action}" Erase_to_end_of_line Next_line)
        |> List.iter ~f:(fun f -> f ())
    in
    Writer.writef writer !"%{Action}" Move_cursor_to_home;
    process elts;
    Writer.writef writer !"%{Action}" Erase_to_end_of_line;
    Writer.flushed writer
end

let render t w =
  Widget.render w t.writer
;;
