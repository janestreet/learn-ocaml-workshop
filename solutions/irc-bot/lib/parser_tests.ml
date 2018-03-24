open Core
open Message
include Parser

module Expect_test_helpers = struct
  let parse_and_print input ~parser_ ~sexp_of_t =
    (match Angstrom.parse_string parser_ input with
     | Ok result -> sexp_of_t result
     | Error s -> [%message
       "Failed to parse"
         (input : string)
         ~error:(s : string)])
    |> print_s
  ;;
end

let%expect_test "hostname" =
  let test =
    Expect_test_helpers.parse_and_print ~parser_:hostname ~sexp_of_t:String.sexp_of_t
  in
  test "foo";
  [%expect {| foo |}];
  test "foo.bar";
  [%expect {| foo.bar |}];
  test "foo.bar.baz";
  [%expect {| foo.bar.baz |}];
;;


let%expect_test "hostaddr" =
  let test =
    Expect_test_helpers.parse_and_print
      ~parser_:hostaddr
      ~sexp_of_t:(Unix.Inet_addr.Blocking_sexp.sexp_of_t)
  in
  test "1.1.1.1";
  [%expect {| 1.1.1.1 |}];
  test "212.212.212.212";
  [%expect {| 212.212.212.212 |}];
  test "a.b.c.d";
  [%expect {|
    ("Failed to parse" (input a.b.c.d)
     (error "hostaddr: IPv6 support unimplemented")) |}];
  test "1.1.1";
  [%expect {|
    ("Failed to parse" (input 1.1.1)
     (error "hostaddr: IPv6 support unimplemented")) |}];
;;

let%expect_test "prefix" =
  let test =
    Expect_test_helpers.parse_and_print
      ~parser_:prefix
      ~sexp_of_t:Prefix.sexp_of_t
  in
  test ":foo@bar.com ";
  [%expect {| (User (nickname foo) (user (((host (Hostname bar.com)) (user ()))))) |}];
  test ":foo ";
  [%expect {| (User (nickname foo) (user ())) |}];
  test ":foo.bar.com ";
  [%expect {| (Server foo.bar.com) |}];
  test ":camlbot!caml@somehost ";
  [%expect {| (User (nickname camlbot) (user (((host (Hostname somehost)) (user (caml)))))) |}];
  test ":jsowbot!~jsowbot@104.153.224.167 ";
  [%expect {|
    (User (nickname jsowbot)
     (user (((host (Hostname 104.153.224.167)) (user (~jsowbot)))))) |}];
  test ":rajaniemi.freenode.net ";
  [%expect {| (Server rajaniemi.freenode.net) |}];
;;

let%expect_test "params" =
  let test =
    Expect_test_helpers.parse_and_print
      ~parser_:params
      ~sexp_of_t:Params.sexp_of_t
  in
  test " foo";
  [%expect {| (foo) |}];
  test " foo bar baz";
  [%expect {| (foo bar baz) |}];
  test " foo bar baz :quux baz bar foo";
  [%expect {| (foo bar baz "quux baz bar foo") |}];
;;

let%expect_test "command" =
  let test =
    Expect_test_helpers.parse_and_print
      ~parser_:command
      ~sexp_of_t:Command.sexp_of_t
  in
  test "NICK";
  [%expect {| NICK |}];
  test "123INVALID";
  [%expect {| "" |}];
  test "123";
  [%expect {| 123 |}];
  test "INVALID123";
  [%expect {| "" |}];
  test "NICK foobar";
  [%expect {| NICK |}]
;;

let%expect_test "message" =
  let test s =
    Expect_test_helpers.parse_and_print
      ~parser_:message
      ~sexp_of_t:Message.sexp_of_t
      (s ^ "\r\n")
  in
  test ":foobar NICK camlbot";
  [%expect {|
    ((prefix ((User (nickname foobar) (user ())))) (command NICK)
     (params (camlbot))) |}];
  test "NICK camlbot";
  [%expect {| ((prefix ()) (command NICK) (params (camlbot))) |}];
  test "USER camlbot * * :My Cool Bot";
  [%expect {| ((prefix ()) (command USER) (params (camlbot * * "My Cool Bot"))) |}];
  test "JOIN :##somechannel";
  [%expect {| ((prefix ()) (command JOIN) (params (##somechannel))) |}];
  test "PRIVMSG ##somechannel :Hey everybody, it's me camlbot!";
  [%expect {|
    ((prefix ()) (command PRIVMSG)
     (params (##somechannel "Hey everybody, it's me camlbot!"))) |}];
  test "QUIT";
  [%expect {|
    ((prefix ()) (command "") (params ())) |}]
;;

let%expect_test "transcript" =
  let test s =
    Expect_test_helpers.parse_and_print
      ~parser_:message
      ~sexp_of_t:Message.sexp_of_t
      (s ^ "\r\n")
  in
  let transcript =
    {|NICK jsowbot
      USER jsowbot * * :JS OCaml Workshop Bot
      JOIN :##js-ocaml-workshop
      PRIVMSG ##js-ocaml-workshop :Testing
      QUIT
      :rajaniemi.freenode.net NOTICE * :*** Looking up your hostname...
      :rajaniemi.freenode.net NOTICE * :*** Checking Ident
      :rajaniemi.freenode.net NOTICE * :*** Couldn't look up your hostname
      :rajaniemi.freenode.net NOTICE * :*** No Ident response
      :rajaniemi.freenode.net 001 jsowbot :Welcome to the freenode Internet Relay Chat Network jsowbot
      :rajaniemi.freenode.net 002 jsowbot :Your host is rajaniemi.freenode.net[1.1.1.1/6667], running version ircd-seven-1.1.5
      :rajaniemi.freenode.net 003 jsowbot :This server was created Fri Feb 23 2018 at 21:28:24 UTC
      :rajaniemi.freenode.net 004 jsowbot rajaniemi.freenode.net ircd-seven-1.1.5 DOQRSZaghilopswz CFILMPQSbcefgijklmnopqrstvz bkloveqjfI
      :rajaniemi.freenode.net 005 jsowbot CHANTYPES=# EXCEPTS INVEX CHANMODES=eIbq,k,flj,CFLMPQScgimnprstz CHANLIMIT=#:120 PREFIX=(ov)@+ MAXLIST=bqeI:100 MODES=4 NETWORK=freenode KNOCK STATUSMSG=@+ CALLERID=g :are supported by this server
      :rajaniemi.freenode.net 005 jsowbot CASEMAPPING=rfc1459 CHARSET=ascii NICKLEN=16 CHANNELLEN=50 TOPICLEN=390 ETRACE CPRIVMSG CNOTICE DEAF=D MONITOR=100 FNC TARGMAX=NAMES:1,LIST:1,KICK:1,WHOIS:1,PRIVMSG:4,NOTICE:4,ACCEPT:,MONITOR: :are supported by this server
      :rajaniemi.freenode.net 005 jsowbot EXTBAN=$,ajrxz WHOX CLIENTVER=3.0 SAFELIST ELIST=CTU :are supported by this server
      :rajaniemi.freenode.net 251 jsowbot :There are 123 users and 91497 invisible on 34 servers
      :rajaniemi.freenode.net 252 jsowbot 25 :IRC Operators online
      :rajaniemi.freenode.net 253 jsowbot 28 :unknown connection(s)
      :rajaniemi.freenode.net 254 jsowbot 50521 :channels formed
      :rajaniemi.freenode.net 255 jsowbot :I have 3776 clients and 1 servers
      :rajaniemi.freenode.net 265 jsowbot 3776 3882 :Current local users 3776, max 3882
      :rajaniemi.freenode.net 266 jsowbot 91620 92675 :Current global users 91620, max 92675
      :rajaniemi.freenode.net 250 jsowbot :Highest connection count: 3883 (3882 clients) (27573 connections received)
      :rajaniemi.freenode.net 375 jsowbot :- rajaniemi.freenode.net Message of the Day -
      :rajaniemi.freenode.net 372 jsowbot :- Welcome to rajaniemi.freenode.net in Helsinki, Finland.
      :rajaniemi.freenode.net 372 jsowbot :- Omitted the rest for brevity
      :rajaniemi.freenode.net 372 jsowbot :-
      :rajaniemi.freenode.net 372 jsowbot :-
      :rajaniemi.freenode.net 376 jsowbot :End of /MOTD command.
      :jsowbot MODE jsowbot :+i
      :jsowbot!~jsowbot@2.2.2.2 JOIN ##js-ocaml-workshop
      :rajaniemi.freenode.net 353 jsowbot = ##js-ocaml-workshop :jsowbot @jdoe
      :rajaniemi.freenode.net 366 jsowbot ##js-ocaml-workshop :End of /NAMES list.
      :jsowbot!~jsowbot@2.2.2.2 QUIT :Client Quit
      ERROR :Closing Link: 2.2.2.2 (Client Quit)|}
  in
  String.split_lines transcript
  |> List.map ~f:String.strip
  |> List.iter ~f:test;
  [%expect {|
    ((prefix ()) (command NICK) (params (jsowbot)))
    ((prefix ()) (command USER) (params (jsowbot * * "JS OCaml Workshop Bot")))
    ((prefix ()) (command JOIN) (params (##js-ocaml-workshop)))
    ((prefix ()) (command PRIVMSG) (params (##js-ocaml-workshop Testing)))
    ((prefix ()) (command "") (params ()))
    ((prefix ((Server rajaniemi.freenode.net))) (command NOTICE)
     (params (* "*** Looking up your hostname...")))
    ((prefix ((Server rajaniemi.freenode.net))) (command NOTICE)
     (params (* "*** Checking Ident")))
    ((prefix ((Server rajaniemi.freenode.net))) (command NOTICE)
     (params (* "*** Couldn't look up your hostname")))
    ((prefix ((Server rajaniemi.freenode.net))) (command NOTICE)
     (params (* "*** No Ident response")))
    ((prefix ((Server rajaniemi.freenode.net))) (command 001)
     (params
      (jsowbot "Welcome to the freenode Internet Relay Chat Network jsowbot")))
    ((prefix ((Server rajaniemi.freenode.net))) (command 002)
     (params
      (jsowbot
       "Your host is rajaniemi.freenode.net[1.1.1.1/6667], running version ircd-seven-1.1.5")))
    ((prefix ((Server rajaniemi.freenode.net))) (command 003)
     (params (jsowbot "This server was created Fri Feb 23 2018 at 21:28:24 UTC")))
    ((prefix ((Server rajaniemi.freenode.net))) (command 004)
     (params
      (jsowbot rajaniemi.freenode.net ircd-seven-1.1.5 DOQRSZaghilopswz
       CFILMPQSbcefgijklmnopqrstvz bkloveqjfI)))
    ((prefix ((Server rajaniemi.freenode.net))) (command 005)
     (params
      (jsowbot CHANTYPES=# EXCEPTS INVEX CHANMODES=eIbq,k,flj,CFLMPQScgimnprstz
       CHANLIMIT=#:120 "PREFIX=(ov)@+" MAXLIST=bqeI:100 MODES=4 NETWORK=freenode
       KNOCK STATUSMSG=@+ CALLERID=g "are supported by this server")))
    ((prefix ((Server rajaniemi.freenode.net))) (command 005)
     (params
      (jsowbot CASEMAPPING=rfc1459 CHARSET=ascii NICKLEN=16 CHANNELLEN=50
       TOPICLEN=390 ETRACE CPRIVMSG CNOTICE DEAF=D MONITOR=100 FNC
       TARGMAX=NAMES:1,LIST:1,KICK:1,WHOIS:1,PRIVMSG:4,NOTICE:4,ACCEPT:,MONITOR:
       "are supported by this server")))
    ((prefix ((Server rajaniemi.freenode.net))) (command 005)
     (params
      (jsowbot EXTBAN=$,ajrxz WHOX CLIENTVER=3.0 SAFELIST ELIST=CTU
       "are supported by this server")))
    ((prefix ((Server rajaniemi.freenode.net))) (command 251)
     (params (jsowbot "There are 123 users and 91497 invisible on 34 servers")))
    ((prefix ((Server rajaniemi.freenode.net))) (command 252)
     (params (jsowbot 25 "IRC Operators online")))
    ((prefix ((Server rajaniemi.freenode.net))) (command 253)
     (params (jsowbot 28 "unknown connection(s)")))
    ((prefix ((Server rajaniemi.freenode.net))) (command 254)
     (params (jsowbot 50521 "channels formed")))
    ((prefix ((Server rajaniemi.freenode.net))) (command 255)
     (params (jsowbot "I have 3776 clients and 1 servers")))
    ((prefix ((Server rajaniemi.freenode.net))) (command 265)
     (params (jsowbot 3776 3882 "Current local users 3776, max 3882")))
    ((prefix ((Server rajaniemi.freenode.net))) (command 266)
     (params (jsowbot 91620 92675 "Current global users 91620, max 92675")))
    ((prefix ((Server rajaniemi.freenode.net))) (command 250)
     (params
      (jsowbot
       "Highest connection count: 3883 (3882 clients) (27573 connections received)")))
    ((prefix ((Server rajaniemi.freenode.net))) (command 375)
     (params (jsowbot "- rajaniemi.freenode.net Message of the Day -")))
    ((prefix ((Server rajaniemi.freenode.net))) (command 372)
     (params
      (jsowbot "- Welcome to rajaniemi.freenode.net in Helsinki, Finland.")))
    ((prefix ((Server rajaniemi.freenode.net))) (command 372)
     (params (jsowbot "- Omitted the rest for brevity")))
    ((prefix ((Server rajaniemi.freenode.net))) (command 372)
     (params (jsowbot -)))
    ((prefix ((Server rajaniemi.freenode.net))) (command 372)
     (params (jsowbot -)))
    ((prefix ((Server rajaniemi.freenode.net))) (command 376)
     (params (jsowbot "End of /MOTD command.")))
    ((prefix ((User (nickname jsowbot) (user ())))) (command MODE)
     (params (jsowbot +i)))
    ((prefix
      ((User (nickname jsowbot)
        (user (((host (Inet_addr 2.2.2.2)) (user (~jsowbot))))))))
     (command JOIN) (params (##js-ocaml-workshop)))
    ((prefix ((Server rajaniemi.freenode.net))) (command 353)
     (params (jsowbot = ##js-ocaml-workshop "jsowbot @jdoe")))
    ((prefix ((Server rajaniemi.freenode.net))) (command 366)
     (params (jsowbot ##js-ocaml-workshop "End of /NAMES list.")))
    ((prefix
      ((User (nickname jsowbot)
        (user (((host (Inet_addr 2.2.2.2)) (user (~jsowbot))))))))
     (command QUIT) (params ("Client Quit")))
    ((prefix ()) (command ERROR)
     (params ("Closing Link: 2.2.2.2 (Client Quit)"))) |}]
;;
