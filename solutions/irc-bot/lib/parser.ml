open Core

module Angstrom = struct
  include Angstrom
  include Base.Monad.Make(struct
      type nonrec 'a t = 'a t
      let bind t ~f = t >>= f
      let map = `Define_using_bind
      let return = return
    end)
end

open Angstrom
open Angstrom.Let_syntax

module P = struct
  let is_space = function | ' ' -> true | _ -> false

  let is_letter = Char.is_alpha
  let is_digit = Char.is_digit
  let is_letter_or_digit = Char.is_alphanum

  let is_special = function
    | '[' | ']' | '\\' | '`' | '_' | '^' | '{' | '|' | '}' -> true
    | _ -> false
  ;;

  let is_nospcrlfcl = function
    | '\000' | '\r' | '\n' | ' ' | ':' -> false | _ -> true
  ;;
end

let letters  = take_while1 P.is_letter
let digits   = take_while1 P.is_digit

let (<||>) a b = take_while1 (fun char -> a char || b char)

let space = string " "
let crlf = string "\r\n"

let rec at_most m p =
  if m = 0
  then return []
  else
    (lift2 (fun x xs -> x :: xs) p (at_most (m - 1) p))
    <|> return []
;;

let between ~lower ~upper p =
  lift2 (fun xs ys -> xs @ ys)
    (count   lower p)
    (at_most upper p)
;;

let user =
  take_while1
    (function | '\000' | '\r' | '\n' | ' ' | '@' -> false | _ -> true)
  <?> "user"
;;

let hostname =
  let shortname =
    lift2 (fun hd tl -> (Char.to_string hd) ^ tl)
      (satisfy P.is_letter_or_digit)
      (peek_char
       >>= function
       | None ->
         satisfy P.is_letter_or_digit >>| Char.to_string
       | Some _ ->
         P.is_letter_or_digit <||> (fun c -> c = '-'))
    <?> "shortname"
  in
  lift2 (fun s1 s2 ->
      match s2 with
      | [] -> s1
      | s2 ->
        s1 ^ "." ^ String.concat ~sep:"." s2)
    shortname
    (many (string "." *> shortname))
  <?> "hostname"
;;

let hostaddr =
  let ip4addr =
    (sep_by
       (char '.')
       (between ~lower:1 ~upper:3 digits >>| String.concat))
    >>| List.intersperse ~sep:"."
    >>= fun l ->
    match
      Option.try_with (fun () -> Unix.Inet_addr.of_string (String.concat l))
    with
    | None -> fail (sprintf "Failed to parse inet_addr %s" (String.concat l))
    | Some inet_addr -> return inet_addr
  in
  let ip6addr = fail "IPv6 support unimplemented" in
  (ip4addr <|> ip6addr)
  <?> "hostaddr"
;;

let host =
  let open Message.Prefix in
  ((Host.hostname <$> hostname) <|> (Host.inet_addr <$> hostaddr))
  <?> "host"
;;

let servername = hostname <?> "servername"

let prefix : Message.Prefix.t t =
  let open Message.Prefix in
  let server_prefix = lift (fun s -> Server s) servername <* space in
  let user_prefix =
    let nickname =
      lift2 (^)
        (P.is_letter <||> P.is_special)
        (between ~lower:0 ~upper:8
           (satisfy (function
                | '-' -> true
                | c ->
                  P.is_letter c || P.is_digit c || P.is_special c))
         >>| String.of_char_list)
    in
    let user =
      lift2 (fun user host -> { User. user; host })
        (option None (Option.return <$> char '!' *> user))
        (char '@' *> host)
    in
    (lift2 (fun nickname user -> User { nickname ; user })
      nickname
      (option None (Option.return <$> user)))
    <* space
  in
  (string ":" *> (user_prefix <|> server_prefix))
  <?> "prefix"
;;

let params =
  let middle =
    lift2 (fun first rest ->
        Char.to_string first ^ rest)
      (satisfy (P.is_nospcrlfcl))
      (take_while (fun c -> c = ':' || P.is_nospcrlfcl c))
  in
  let trailing =
    take_while1 (fun c -> P.is_space c || c = ':' || P.is_nospcrlfcl c)
    >>| List.return
  in
  let variant1 =
    lift2 (@)
      (at_most 14 (space *> middle))
      (option [] (space *> char ':' *> trailing))
  in
  let variant2 =
    lift2 (@)
      (count 14 (space *> middle))
      (option []
         (space
          *> (at_most 1 (char ':'))
          *> trailing))
  in
  (variant1 <|> variant2)
  <?> "params"
;;

let command =
  let command =
    (lift2 (fun maybe_command peek ->
         match peek with
         | None -> maybe_command
         | Some c ->
           if c = ' '
           then maybe_command
           else [])
        (many1 letters
         <|> (count 3 (satisfy P.is_digit)
              >>| String.of_char_list
              >>| List.return))
        peek_char)
    <?> "command"
  in
  String.concat
  <$> command
  >>| Message.Command.of_string
;;

let message =
  let%bind maybe_prefix =
    option None (Option.return <$> prefix)
  in
  let%bind command = command in
  let%bind params = option [] params in
  crlf
  *> return
    { Message.
      prefix = maybe_prefix
    ; command
    ; params }
  <?> "message"
;;
