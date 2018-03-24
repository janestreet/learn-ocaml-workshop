open Scaffold

module Direction : sig
  type t
end

module Frog : sig
  type t 
  val facing   : t -> Direction.t
  val position : t -> Position.t
end

module Non_frog_character : sig
  module Kind : sig
    type t =
      | Car
      | Log
  end

  type t

  val kind             : t -> Kind.t
  val position         : t -> Position.t

  (** In units of grid-points/tick. Positive values indicate rightward motion,
     negative values leftward motion. *)
  val horizontal_speed : t -> int
end

module Game_state : sig
  type t =
    | Playing
    | Won
    | Dead
end

module World : sig
  type t

  val frog : t -> Frog.t
  val nfcs : t -> Non_frog_character.t list

  val state : t -> Game_state.t
end

val create       : unit -> World.t
val tick         : World.t -> World.t
val handle_input : World.t -> Key.t -> World.t
val draw         : World.t -> Display_list.t
val finished     : World.t -> bool

val handle_event : World.t -> Event.t -> World.t


