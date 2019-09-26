open! Base

type t [@@deriving sexp_of]

(** [create] takes in the [height] and [width] of the area in which an apple can be
    generated, as well as a list of [Position.t]s representing the locations on the board
    that the apple cannot be placed, and creates an [Apple.t].

    [create] returns [None] if there are no valid positions for the apple. *)
val create : height:int -> width:int -> invalid_locations:Position.t list -> t option

(** [location] returns the location of the apple on the board. *)
val location : t -> Position.t
