open! Base

type t =
  { col : int
  ; row : int
  }
[@@deriving compare, sexp]
