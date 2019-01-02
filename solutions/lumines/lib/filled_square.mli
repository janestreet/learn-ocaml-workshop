open Base

(* A filled in square on the board has two pieces of state. The color
   that it is right now, and the "state" that it's currently in.

   The state is one of:
   - [Unmarked] : this means that it is not part of any completed square
   - [To_sweep] : this means it is part of a completed square and the sweeper will delete
     it when it passes all connected [Filled_square]s marked as [To_sweep]
   - [Swept] : this means that the sweeper has passed this, square and it is 'deleted'
     it will be actually removed from the board when the sweeper reaches the end of the

     blocks to delete *)
module Sweeper_state : sig
  type t =
    | Unmarked
    | To_sweep
    | Swept

  val equal : t -> t -> bool
end

type t =
  { color :
      Color.t
  (* recall from our earlier exercise, by marking this as mutable we can change it in
     place rather than making a new one every time the state updates *)
  ; mutable sweeper_state : Sweeper_state.t
  }

(* [create] takes a color and returns a filled_square.  All squares start off with
   a state of Unmarked *)
val create : Color.t -> t

(* [unmark] sets the state to Unmarked *)
val unmark : t -> unit

(* [to_sweep] sets the state to To_sweep *)
val to_sweep : t -> unit

(* [sweep] checks the current state of t.
   if it is [To_sweep], it marks it as [Swept] and returns true
   otherwise it doesn't change the state and returns false *)
val sweep : t -> bool
val equal : t -> t -> bool
