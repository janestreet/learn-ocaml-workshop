open Core
open Async

type t = {
  (* TODO: Fill me in *)
  todo : unit
}

let _compilation_fix_you_probably_want_to_use_this_module = (module Spinner : Unit)

let run user_input tty_text stdin =
  let t = { todo = () } in
  let () = t          |> (ignore : t -> unit) in
  let () = tty_text   |> (ignore : Tty_text.t -> unit) in
  let () = stdin      |> (ignore : Reader.t -> unit) in
  let () = user_input |> (ignore : Tty_text.User_input.t Pipe.Reader.t -> unit) in
  Render.every
    ~how_often_to_render:(Time.Span.of_sec 0.1)
    ~render:(fun () ->
      (* TODO: Determine when rendering actually needs to occur, and call render. *)
      Deferred.unit
    )
    (fun () ->
       (* TODO : Process events from new lines on [stdin], as well as [user_input]. *)
       return (`Finished None)
    )
;;

let () =
  Command.run @@
  let open Command.Let_syntax in
  Command.async ~summary:"Custom fzf" [%map_open
    let () = return () in
    fun () ->
      let open Deferred.Let_syntax in
      (* TODO: Determine if [stdin] is a tty (see [Unix.isatty],) and if it is,
         do not process anything from it. If this guard is not in place,
         when no stdin is provided to fzf, alternating keypresses will seem to
         disappear. *)
      let stdin = force Reader.stdin in
      match%bind
        Tty_text.with_rendering (fun (input, tty_text) ->
          run input tty_text stdin
        )
      with
      | None -> Deferred.unit
      | Some output ->
        let stdout = force Writer.stdout in
        Writer.write_line stdout output;
        Writer.flushed stdout
  ]
