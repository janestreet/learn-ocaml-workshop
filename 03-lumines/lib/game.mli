open Base

(* This module holds the entire game state. *)
type t =
  { board : Board.t
  ; height : int
  ; width : int
  ; mutable moving_piece : Moving_piece.t
  ; (* We represent the location of the moving piece by the bottom left corner
       of the piece. Note that the origin of [board] is the lower left
       corner. *)
    mutable moving_piece_col : int
  ; mutable moving_piece_row : int
  ; game_over : bool ref
  ; sweeper : Sweeper.t
  }

val create : height:int -> width:int -> seconds_per_sweep:float -> t

(* [new_moving_piece] puts a random new block at the top of the board *)
val new_moving_piece : t -> unit

(* Functions to move the piece on the board *)
val move_left : t -> unit
val move_right : t -> unit
val rotate_left : t -> unit
val rotate_right : t -> unit
val drop : t -> unit

(* [tick] handles everything that needs to happen when the clock ticks once *)
val tick : t -> unit
