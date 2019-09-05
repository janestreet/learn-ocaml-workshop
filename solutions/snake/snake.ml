open! Base

type t =
  { (* [direction] represents the orientation of the snake's head. *)
    direction : Direction.t
  ; (* [extensions_remaining] represents how many more times we should extend the
       snake. *)
    extensions_remaining : int
  ; (* [locations] represents the current set of squares that the snake
       occupies. *)
    locations : Position.t list
  }
[@@deriving sexp_of]

(* TODO: Implement [create].

   Note that at the beginning of the game, the snake will not need to grow at all, so
   [extensions_remaining] should be initialized to 0. *)
let create ~length =
  { direction = Right
  ; extensions_remaining = 0
  ; locations = List.init length ~f:(fun col -> { Position.row = 0; col }) |> List.rev
  }
;;

(* TODO: Implement [grow_over_next_steps].

   Read over the documentation of this function in the mli.

   Notice that this function should not actually grow the snake, but only record that we
   should grow the snake one block for the next [by_how_much] squares. *)
let grow_over_next_steps t by_how_much =
  { t with extensions_remaining = t.extensions_remaining + by_how_much }
;;

(* TODO: Implement [locations]. *)
let locations t = t.locations

(* TODO: Implement [head_location]. *)
let head_location t = List.hd_exn t.locations

(* TODO: Implement [set_direction]. *)
let set_direction t direction = { t with direction }

(* TODO: Implement [step].

   Read over the documentation of this function in the mli.

   [step] should:
   - move the snake forward one block, growing it and updating [t.locations] if necessary
   - check for self collisions *)
let remove_last_elt lst =
  match List.rev lst with
  | [] -> []
  | _ :: xs -> List.rev xs
;;

let step ({ direction; extensions_remaining; locations } as t) =
  let body, extensions_remaining =
    if extensions_remaining > 0
    then locations, extensions_remaining - 1
    else remove_last_elt locations, extensions_remaining
  in
  let new_head = Direction.next_position direction (head_location t) in
  match List.mem body new_head ~equal:[%compare.equal: Position.t] with
  | true -> None
  | false -> Some { t with locations = new_head :: body; extensions_remaining }
;;
