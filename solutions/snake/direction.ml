open! Base

type t =
  | Left
  | Up
  | Right
  | Down
[@@deriving sexp_of]

(* TODO: Implement [next_position].

   Make sure to take a look at the signature of this function to understand what it does.
   Recall that the origin of the board is in the lower left hand corner. *)
let next_position t { Position.row; col } : Position.t =
  match t with
  | Left -> { row; col = col - 1 }
  | Right -> { row; col = col + 1 }
  | Up -> { row = row + 1; col }
  | Down -> { row = row - 1; col }
;;
