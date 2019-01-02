open Base

(* This module holds the entire game state  *)
type t =
  { board : Board.t
  ; height : int
  ; width : int
  ; mutable moving_piece :
      Moving_piece.t
  (* we will choose the bottom left corner to be the block we refer to the piece by *)
  ; mutable moving_piece_col : int
  ; mutable moving_piece_row : int
  ; game_over : bool ref
  ; sweeper : Sweeper.t
  }

val create : height:int -> width:int -> seconds_per_sweep:float -> t

(* put a new piece at the top of the board *)
val new_moving_piece : t -> unit

(* move the piece on the board *)
val move_left : t -> unit
val move_right : t -> unit
val rotate_left : t -> unit
val rotate_right : t -> unit
val drop : t -> unit

(* handle the clock ticking once *)
val tick : t -> unit
