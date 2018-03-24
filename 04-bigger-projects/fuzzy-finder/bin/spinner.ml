open Core
open Async

module Spin_state = struct
  type t =
    | Vert_bar
    | Lower_left_to_top_right
    | Dash
    | Lower_right_to_top_left

  let advance = function
    | Vert_bar                -> Lower_left_to_top_right
    | Lower_left_to_top_right -> Dash
    | Dash                    -> Lower_right_to_top_left
    | Lower_right_to_top_left -> Vert_bar

  let to_char = function
    | Vert_bar                -> '|'
    | Lower_left_to_top_right -> '/'
    | Dash                    -> '-'
    | Lower_right_to_top_left -> '\\'
end

type t = Spin_state.t option ref

let finish t =
  t := None
;;

let to_char t =
  Option.map ~f:Spin_state.to_char !t
;;

let advance t =
  t := Option.map ~f:Spin_state.advance !t
;;

let create ~spin_every =
  let t = ref (Some (Spin_state.Vert_bar)) in
  Clock.every spin_every (fun () -> advance t);
  t
;;
