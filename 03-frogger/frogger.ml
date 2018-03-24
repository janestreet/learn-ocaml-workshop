open Base
open Scaffold

module Frog = struct
  type t =
    { position : Position.t
    } [@@deriving fields]

  let create = Fields.create
end

module World = struct
  type t =
    { frog  : Frog.t
    } [@@deriving fields]

  let create = Fields.create
end

let create_frog () =
  failwith
    "Figure out how to initialize the [Frog.t] at the beginning of the game. \
     Call [Frog.create] with some arguments."
;;

let create () =
  failwith
    "Call [World.create] and [create_frog] to construct the initial state \
     of the game. Try using [Random.int] -- variety is the spice of life!"
;;

let tick (world : World.t) =
  failwith
    "This function will end up getting called every timestep, which happens to \
     be set to 1 second for this game in the scaffold (so you can easily see \
     what's going on). For the first step (just moving the frog/camel around), \
     you can just return [world] here. Later you'll want do interesting things \
     like move all the cars and logs, detect collisions and figure out if the \
     player has died or won. "
;;

let handle_input (world : World.t) key =
  failwith
    "This function will end up getting called whenever the player presses one of \
     the four arrow keys. What should the new state of the world be? Create and \
     return it based on the current state of the world (the [world] argument), \
     and the key that was pressed ([key]). Use either [World.create] or the \
     record update syntax:
    { world with frog = Frog.create ... }
"
;;

let draw (world : World.t) =
  failwith
    "Return a list with a single item: a tuple consisting of one of the choices \
     in [Images.t] in [scaffold.mli]; and the current position of the [Frog]."
;;

let handle_event world event =
  failwith
    "This function should probably be just 3 lines long: [match event with ...]"
;;

let finished world =
  failwith
    "This can probably just return [false] in the beginning."
;;
