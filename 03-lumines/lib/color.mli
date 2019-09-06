open Base

(* We have a simple color scheme with two colors: Orange and White. *)
type t =
  | Orange
  | White

(* [compare] compares two colors, returning 0 if they are the same. *)
val compare : t -> t -> int

(* [random] returns a random color. *)
val random : unit -> t
val equal : t -> t -> bool
