open Scaffold

module World : sig
  type t
end

val create       : unit -> World.t
val handle_event : World.t -> Event.t -> World.t
val draw         : World.t -> Display_list.t
val finished     : World.t -> bool


