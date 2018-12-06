open! Base

type 'a option =
  | None
  | Some of 'a

val safe_divide : dividend:int -> divisor:int -> int option
