open Core

module Prefix = struct
  module Host = struct
    type t =
      | Hostname of string
      | Inet_addr of Unix.Inet_addr.Blocking_sexp.t
    [@@deriving variants, sexp]
    ;;

    let to_string = function
      | Hostname s -> s
      | Inet_addr addr -> Unix.Inet_addr.to_string addr
    ;;
  end

  module User = struct
    type t =
      { host : Host.t
      ; user : string option }
    [@@deriving sexp]
    ;;

    let to_string { host; user } =
      let user =
        match user with
        | Some u -> "!" ^ u
        | None -> ""
      in
      user ^ "@" ^ (Host.to_string host)
    ;;
  end

  type t =
    | Server of string
    | User of
        { nickname : string
        ; user : User.t option }
  [@@deriving sexp]
  ;;

  let to_string t =
    ":" ^
    (match t with
     | Server s -> s
     | User { nickname; user = maybe_user } ->
       match maybe_user with
       | None -> nickname
       | Some user -> nickname ^ User.to_string user)
  ;;
end

module Command = struct
  type t = string [@@deriving sexp]

  (* TODO: Actually validate the commands here. *)
  let of_string s = s
end

module Params = struct
  type t = string list [@@deriving sexp]

  let to_string t =
    let rec loop acc rest =
      match rest with
      | [] -> acc
      | last :: [] -> acc ^ " :" ^ last
      | elem :: rest -> loop (acc ^ " " ^ elem) rest
    in
    loop "" t
  ;;
end

type t =
  { prefix : Prefix.t option
  ; command : Command.t
  ; params : Params.t
  }
[@@deriving sexp, fields]
;;

let create ?prefix ~command ~params () =
  Fields.create ~prefix ~command ~params
;;

let to_string t =
  (match t.prefix with
   | Some prefix -> Prefix.to_string prefix ^ " "
   | None -> "")
  |> fun prefix ->
  prefix
  ^ t.command
  ^ (Params.to_string t.params)
;;
