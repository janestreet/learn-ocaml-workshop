open Base
open! Import

type t =
  { board : Board.t
  ; seconds_per_sweep : float
  ; mutable cur_pos : int
  }

let create board ~seconds_per_sweep = { board; seconds_per_sweep; cur_pos = 0 }
let cur_pos t = t.cur_pos

let seconds_per_step t =
  let steps = (pixels_per_square * t.board.Board.width) - 1 in
  let seconds_per_step = t.seconds_per_sweep /. Float.of_int steps in
  seconds_per_step
;;

let step t =
  let steps = (pixels_per_square * t.board.Board.width) - 1 in
  (* Clear squares *)
  if t.cur_pos % pixels_per_square = 0
  then (
    let check_col = t.cur_pos / pixels_per_square in
    let more_marked =
      List.fold_left (List.range 0 t.board.height) ~init:false ~f:(fun acc row ->
          let color = Board.get t.board { Point.row; col = check_col } in
          match color with
          | None -> acc
          | Some filled_square -> Filled_square.sweep filled_square || acc)
    in
    if not more_marked || t.cur_pos = steps then Board.remove_squares t.board);
  (* advance sweeper *)
  if t.cur_pos < steps then t.cur_pos <- t.cur_pos + 1 else t.cur_pos <- 0
;;
