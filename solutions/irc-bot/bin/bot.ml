open! Core
open! Async
open! Irc_protocol

(** This is a simple bot which connects to a single channel on an IRC server,
    sends a greeting, and then watches for other nicks to join the channel. When
    someone joins, the bot sends a simple greeting.

    Not much effort has been made to validate the success of various commands.
    Similarly, no attention has been given to the idea of connecting to multiple
    channels.

    Most of the heavy lifting is done in the parser written using the Angstrom
    library in lib/parser.ml. *)
module Config = struct
  type t =
    { nick : string
    ; full_name : string
    ; channel : string }
  ;;

  let param =
    let open Command.Let_syntax in
    [%map_open
      let nick =
        (* TODO: Check the RFC for valid characters and exit with an error if
           the NICK contains any of them. *)
        flag "nick" (required string)
          ~doc:"NICK nickname to use on the IRC server"
      and full_name =
        flag "full-name" (required string)
          ~doc:"NAME full name to register with the server"
      and channel =
        flag "channel" (required string)
          ~doc:"CHAN channel to send the message to, including the '#' if \
                relevant"
      in
      { nick; full_name; channel }
    ]
  ;;
end

let write_message writer message =
  let s = Irc_message.to_string message in
  let truncated = String.prefix s 510 in
  printf ">>> %s\n" truncated;
  Writer.write_line writer truncated ~line_ending:Writer.Line_ending.Dos
;;

let join_and_greet writer { Config. nick; full_name; channel } =
  let open Irc_message in
  let nick_   = create ~command:"NICK" ~params:[nick] () in
  let user    = create ~command:"USER" ~params:[nick; "*"; "*"; full_name ] () in
  let join    = create ~command:"JOIN" ~params:[channel] () in
  let privmsg =
    create
      ~command:"PRIVMSG"
      ~params:[channel; sprintf "Hi, I'm %s!" nick]
      ()
  in
  write_message writer nick_;
  write_message writer user;
  write_message writer join;
  write_message writer privmsg;
;;

let privmsg ~target message : Irc_message.t =
  { prefix = None; command = "PRIVMSG"; params = [ target; message ] }
;;

let maybe_extract_nick_from_prefix : Irc_message.Prefix.t option -> string option = function
  | Some (Server _) | None -> None
  | Some (User { nickname; _ }) ->
    Some nickname
;;

let handle_message writer (config : Config.t) (message : Irc_message.t) =
  printf "<<< %s\n" (Irc_message.to_string message);
  let () =
    match message.command with
    | "PING" ->
      write_message writer (Irc_message.create ~command:"PONG" ~params:[ config.nick ] ())
    | "PRIVMSG" -> (
        Option.iter
          (List.hd message.params)
          ~f:(fun nick ->
              if nick = config.nick
              then (
                write_message writer 
                  (privmsg 
                    ~target:config.channel 
                    "Sorry, I'm shy: All I like to do is say hi."))))
    | "JOIN" ->
      if message.params = [ config.channel ]
      then (
        Option.iter (maybe_extract_nick_from_prefix message.prefix)
          ~f:(fun nick ->
              if (nick = config.nick)
              then ()
              else (
                write_message writer 
                (privmsg ~target:config.channel (sprintf "Hi %s!" nick)))))
    | _ -> ()
  in
  Writer.flushed writer
;;

let command () =
  let open Command.Let_syntax in
  Command.async
    ~summary:"Simple IRC bot which connects to a channel, says hello, and then \
              greets any new joiners."
    [%map_open
      let where_to_connect =
        let%map host_and_port =
          flag "server" (required host_and_port)
            ~doc:"HOST:PORT of IRC server"
        in
        Tcp.Where_to_connect.of_host_and_port host_and_port
      and config = Config.param
      in
      fun () ->
        Tcp.with_connection where_to_connect
          (fun _socket reader writer ->
             join_and_greet writer config;
             Writer.flushed writer
             >>= fun () ->
             let rec wait_for_message_and_reply () =
               Angstrom_async.parse_many Irc_message.parser_ (handle_message writer config) reader
               >>= function
               | Error error ->
                 Log.Global.sexp ~level:`Error [%message
                   "Failed to parse message, exiting"
                     (error : string)];
                 Shutdown.exit 1
               | Ok () ->
                 wait_for_message_and_reply ()
             in
             wait_for_message_and_reply ())
    ]
;;

let () = Command.run (command ())
