open Core

module Prefix : sig
  module Host : sig
    type t =
      | Hostname of string
      | Inet_addr of Unix.Inet_addr.Blocking_sexp.t
    [@@deriving variants, sexp]
    ;;
  end

  module User : sig
    type t =
      { host : Host.t
      ; user : string option }
    [@@deriving sexp]
    ;;
  end

  type t =
    | Server of string
    | User of
        { nickname : string
        ; user : User.t option }
  [@@deriving sexp]
  ;;
end
module Command : sig
  type t = string
  [@@deriving sexp]

  val of_string : string -> t
end

module Params : sig
  type t = string list
  [@@deriving sexp]
end

type t =
  { prefix : Prefix.t option
  ; command : Command.t
  ; params : Params.t
  }
  [@@deriving sexp, fields]
;;

val create
  :  ?prefix:Prefix.t
  -> command:Command.t
  -> params:Params.t
  -> unit
  -> t

val to_string : t -> string
