open! Base

type t =
  { (* [direction] represents the orientation of the snake's head. *)
    direction : Direction.t
  ; (* [extensions_remaining] represents how many more times we should extend the
       snake. *)
    extensions_remaining : int
  ; (* [locations] represents the current set of squares that the snake
       occupies. The first element of the list is the head of the snake. We hold
       as an invariant that [locations] is always non-empty. *)
    locations : Position.t list
  }
[@@deriving sexp_of]

(* TODO: Implement [create].

   Note that at the beginning of the game, the snake will not need to grow at all, so
   [extensions_remaining] should be initialized to 0. *)
let create ~length = failwith "For you to implement"

(* TODO: Implement [grow_over_next_steps].

   Read over the documentation of this function in the mli.

   Notice that this function should not actually grow the snake, but only record that we
   should grow the snake one block for the next [by_how_much] squares. *)
let grow_over_next_steps t by_how_much = t

(* TODO: Implement [locations]. *)
let locations t = failwith "For you to implement"

(* TODO: Implement [head_location]. *)
let head_location t = { Position.row = 0; col = 0 }

(* TODO: Implement [set_direction]. *)
let set_direction t direction = t

(* TODO: Implement [step].

   Read over the documentation of this function in the mli.

   [step] should:
   - move the snake forward one block, growing it and updating [t.locations] if necessary
   - check for self collisions *)
let step t = Some t
