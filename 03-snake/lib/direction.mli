open! Base

type t =
  | Left
  | Up
  | Right
  | Down
[@@deriving sexp_of]

(** [next_position] takes a direction and a starting position and returns the
    next position after taking one step in the specified direction. *)
val next_position : t -> Position.t -> Position.t
