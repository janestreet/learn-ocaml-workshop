open Base

(* A moving piece is made up of 4 squares *)
type t =
  { top_left : Filled_square.t
  ; top_right : Filled_square.t
  ; bottom_left : Filled_square.t
  ; bottom_right : Filled_square.t
  }

(* [create] creates a new random piece *)
val create : unit -> t

(* [rotate_left] returns a new moving piece where the colors have been rotated left *)
val rotate_left : t -> t

(* [rotate_right] returns a new moving piece where the colors have been rotated right *)
val rotate_right : t -> t

(* given the column and row of the bottom left block of the pice,
   [coords] return a list of the coordinates of all four blocks in
   the piece *)
val coords : bottom_left:Point.t -> Point.t list
