open Base

(* We have implemented the sweeper for you.
   Feel free to look at this code for reference, but you shouldn't need to change
   anything within this module unless you are making a different variant of the game. *)
type t

val create : Board.t -> seconds_per_sweep:float -> t

(* get the current postion of the sweeper *)
val cur_pos : t -> int

(* [seconds_per_step] returns how quickly the step function should be called to make it
   sweep the board in the time given by seconds per sweep *)
val seconds_per_step : t -> float

(* step advances the sweeper one square and potentially removes squares from the board *)
val step : t -> unit
