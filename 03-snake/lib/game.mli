open! Base

(** A [t] represents the entire game state, including the current snake, apple,
    and game state. *)
type t

(** [create] creates a new game with specified parameters. *)
val create
  :  height:int
  -> width:int
  -> initial_snake_length:int
  (* [amount_to_grow] is the amount the snake's length should increase by
     each time it eats an apple. *)
  -> amount_to_grow:int
  -> t

(** [snake] returns the snake that is currently in the game. *)
val snake : t -> Snake.t

(** [set_direction] updates the direction of the snake that is in the game. *)
val set_direction : t -> Direction.t -> unit

(** [apple] returns the apple that is currently in the game. *)
val apple : t -> Apple.t

(** [game_state] returns the state of the current game. *)
val game_state : t -> Game_state.t

(** [step] is called in a loop, and the game is re-rendered after each call. *)
val step : t -> unit

(** [in_bounds] returns [true] if the position references a valid square inside
    the game playing area. *)
val in_bounds : t -> Position.t -> bool
