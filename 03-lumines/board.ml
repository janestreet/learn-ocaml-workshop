open Base

type t =
  { board : Filled_square.t option array array
  ; height : int
  ; width : int
  }

let create ~height ~width =
  { board = Array.make_matrix ~dimx:width ~dimy:height None; height; width }
;;

let get t { Point.col; row } = t.board.(col).(row)
let set t { Point.col; row } value = t.board.(col).(row) <- value

let mark_squares t =
  (* TODO: at the end of this function the all
     filled_squares that are part of completed squares
     (anything that is in a single color square of 4 parts which includes
     combined groups)
     should be in sweeper state [`to_sweep] and
     all other squares should be [`unmarked]
  *)
  ignore t
;;

let remove_squares t =
  (* TODO: any squares that are marked as [`swept] should be removed from the board.
     Gravity should be applied appropriately.

     at the end of this function we should call [mark_squares] so that we ensure that
     we leave the board in a valid state
  *)
  ignore (mark_squares t)
;;

let add_piece t ~moving_piece ~col =
  (* TODO: insert the moving piece into the board applying gravity appropriately *)
  ignore t;
  ignore moving_piece;
  ignore col;
  true
;;

let is_empty t point =
  match get t point with
  | None -> true
  | Some _ -> false
;;
