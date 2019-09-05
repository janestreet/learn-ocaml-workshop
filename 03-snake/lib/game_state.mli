open! Base

(** A [t] represents the current state of the game. *)
type t =
  | In_progress
  | Game_over of string (* The string is the reason the game ended. *)
  | Win
[@@deriving sexp_of]

(** [to_string] returns a pretty-prints the current game state into a string. *)
val to_string : t -> string
