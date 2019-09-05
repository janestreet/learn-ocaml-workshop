open! Base

type t [@@deriving sexp_of]

(** [create] returns [None] if there are no valid positions for the apple. *)
val create : height:int -> width:int -> invalid_locations:Position.t list -> t option

(** [location] returns the location of the apple on the board. *)
val location : t -> Position.t
