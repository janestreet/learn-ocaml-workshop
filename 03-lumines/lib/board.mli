open Base

(* The board is a 2-dimensional array of filled_square options. If
     the square is empty, we represent it with [None].  If it is filled,
     we represent it with [Some Filled_Square].  We have provided getter
     and setter functions to get and set values of the array *)
type t =
  { board : Filled_square.t option array array
  ; height : int
  ; width : int
  }

(* given a height and width, create a board *)
val create : height:int -> width:int -> t

(* get the value at a given row and col *)
val get : t -> Point.t -> Filled_square.t option

(* set the value at a given row and col *)
val set : t -> Point.t -> Filled_square.t option -> unit

(* [remove_squares] will be called by the sweeper. It should delete any squares
   marked as [Swept] from the board and leave the board in a valid state *)
val remove_squares : t -> unit

(* [add_piece] takes a piece and the column number of the left side of
   the piece and inserts it into the board. Returns:
   true  if it was able to add the piece to the board
   false otherwise *)
val add_piece : t -> moving_piece:Moving_piece.t -> col:int -> bool

(* [is_empty] takes a row and a col and returns:
   true  if that square is empty
   false if that square is filled
*)
val is_empty : t -> Point.t -> bool
