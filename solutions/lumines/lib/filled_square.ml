open Base

module Sweeper_state = struct
  type t =
    | Unmarked
    | To_sweep
    | Swept

  let equal t1 t2 =
    match t1, t2 with
    | Unmarked, Unmarked
    | To_sweep, To_sweep
    | Swept, Swept -> true
    | _ -> false
  ;;
end

type t =
  { color : Color.t
  ; mutable sweeper_state : Sweeper_state.t
  }

let create color = { color; sweeper_state = Unmarked }
let unmark t = t.sweeper_state <- Unmarked
let to_sweep t = t.sweeper_state <- To_sweep

let sweep t =
  match t.sweeper_state with
  | To_sweep ->
    t.sweeper_state <- Swept;
    true
  | Unmarked | Swept -> false
;;

let equal t1 t2 =
  Color.equal t1.color t2.color
  && Sweeper_state.equal t1.sweeper_state t2.sweeper_state
;;
