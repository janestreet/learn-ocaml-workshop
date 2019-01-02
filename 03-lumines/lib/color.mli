open Base

(* We have a simple colors scheme with two colors: Orange and white *)
type t =
  | Orange
  | White

(* compares two colors. returns 0 if they are the same *)
val compare : t -> t -> int

(* get a random color *)
val random : unit -> t
val equal : t -> t -> bool
