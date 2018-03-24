open! Core
open! Async

(** This is a simple client which takes a variety of command-line parameters for
    the purpose of connecting to a single channel on an IRC server, sending one
    message, and then disconnecting. No validation is done of the parameters.

    There are various TODO items below that are probably worth pursuing if you
    are going to reuse any of this code in your bot. *)
let command () =
  let open Command.Let_syntax in
  Command.async
    ~summary:"Simple IRC bot which just sends a single message and disconnects"
    [%map_open
      let where_to_connect =
        let%map host_and_port =
          flag "server" (required host_and_port)
            ~doc:"HOST:PORT of IRC server"
        in
        Tcp.Where_to_connect.of_host_and_port host_and_port
      and nick =
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
      and message =
        anon ("MESSAGE" %: string)
      in
      fun () ->
        Tcp.with_connection where_to_connect
          (fun _socket reader writer ->
             (* TODO: Check that the total length of the message(s) being sent
                to the server never exceed the 512 character limit. *)
             let write_line line =
               (* Convenience wrapper to ensure we don't forget to end lines
                  in \r\n. *)
               printf ">>> %s\n" line;
               Writer.write_line writer line ~line_ending:Writer.Line_ending.Dos
             in
             write_line (sprintf "NICK %s" nick);
             write_line (sprintf "USER %s * * :%s" nick full_name);
             write_line (sprintf "JOIN :%s" channel);
             write_line (sprintf "PRIVMSG %s :%s" channel message);
             write_line (sprintf "QUIT");
             Writer.flushed writer
             >>= fun () ->
             (* TODO: In practice, you'll want to check that the replies you
                receive in response to sending each of the messages below
                indicate success before continuing on to additional
                commands.*)
             Pipe.iter
               (Reader.lines reader)
               ~f:(fun reply ->
                   printf "<<< %s\n" reply;
                   Deferred.unit);
          )
    ]
;;

let () = Command.run (command ())
