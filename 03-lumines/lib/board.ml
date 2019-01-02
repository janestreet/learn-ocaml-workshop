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

(* Tests *)
let is_filled_with_color t ~row ~col color = 
  match get t { Point. row; col} with
  | None -> false
  | Some square -> Color.equal color square.color
;;

let is_marked t ~row ~col = 
  match get t { Point. row; col} with
  | None -> false
  | Some square ->
    Filled_square.Sweeper_state.equal
      square.Filled_square.sweeper_state
      Filled_square.Sweeper_state.To_sweep
;;

let test_piece = 
  { Moving_piece. top_left = Filled_square.create (Color.Orange)
  ; top_right = Filled_square.create (Color.White)
  ; bottom_left = Filled_square.create (Color.White)
  ; bottom_right = Filled_square.create (Color.White)
  }
;;

let%test "Testing Add_piece add one..." = 
  let t = create ~height:4 ~width:4 in
  add_piece t ~moving_piece:test_piece ~col:0
  && is_filled_with_color t ~row:0 ~col:0 Color.White
  && is_filled_with_color t ~row:0 ~col:1 Color.White
  && is_filled_with_color t ~row:1 ~col:0 Color.Orange
  && is_filled_with_color t ~row:1 ~col:1 Color.White
;;

let%test "Testing Add_piece add many..." =
  let t = create ~height:4 ~width:4 in
  (add_piece t ~moving_piece:test_piece ~col:0)
  && (add_piece t ~moving_piece:test_piece ~col:0)
  && (not (add_piece t ~moving_piece:test_piece ~col:0))
;;

let test_removable_piece = 
  { Moving_piece. top_left = Filled_square.create (Color.White)
  ; top_right = Filled_square.create (Color.White)
  ; bottom_left = Filled_square.create (Color.White)
  ; bottom_right = Filled_square.create (Color.White)
  }
;;

let%test "Testing Mark_squares..." =
  let t = create ~height:4 ~width:4 in
  assert (add_piece  t ~moving_piece:test_removable_piece ~col:0);
  assert (add_piece  t ~moving_piece:test_piece ~col:0);
  mark_squares t;
  is_marked t ~row:0 ~col:0 
  && is_marked t ~row:0 ~col:1
  && is_marked t ~row:1 ~col:0
  && is_marked t ~row:1 ~col:1
  && is_marked t ~row:2 ~col:0
  && is_marked t ~row:2 ~col:1
  && not (is_marked t ~row:3 ~col:0)
  && not (is_marked t ~row:3 ~col:1)
;;

let sweep_board t = 
  Array.iter t.board
    ~f:(fun row ->
        Array.iter row ~f:(fun square -> 
            Option.iter square
              ~f:(fun square -> ignore (Filled_square.sweep square))))
;;

let%test "Testing Remove_squares..." =
  let t = create ~height:4 ~width:4 in
  assert (add_piece  t ~moving_piece:test_removable_piece ~col:0);
  assert (add_piece  t ~moving_piece:test_piece ~col:0);
  mark_squares t;
  sweep_board t;
  remove_squares t;
  is_filled_with_color t ~row:0 ~col:0 Color.Orange
  && is_filled_with_color t ~row:0 ~col:1 Color.White
;;
