open! Base
open! Snake_lib
open Game
open For_testing

type nonrec t = Game.t [@@deriving sexp_of]

let step_n_times t n = List.iter (List.range 0 n) ~f:(fun _ -> step t)

let%expect_test "Testing [Game.step] with wall collision..." =
  let t =
    create_game_with_apple_exn
      ~height:10
      ~width:10
      ~initial_snake_length:3
      ~amount_to_grow:3
      ~apple_location:{ Position.row = 8; col = 1 }
  in
  step_n_times t 7;
  Stdio.printf !"%{sexp: t}\n%!" t;
  [%expect
    {|
        ((snake
          ((direction Right) (extensions_remaining 0)
           (locations (((col 9) (row 0)) ((col 8) (row 0)) ((col 7) (row 0))))))
         (apple ((location ((col 1) (row 8))))) (game_state In_progress) (height 10)
         (width 10) (amount_to_grow 3)) |}];
  step_n_times t 1;
  Stdio.printf !"%{sexp: t}\n%!" t;
  [%expect
    {|
        ((snake
          ((direction Right) (extensions_remaining 0)
           (locations (((col 10) (row 0)) ((col 9) (row 0)) ((col 8) (row 0))))))
         (apple ((location ((col 1) (row 8)))))
         (game_state (Game_over "Wall collision")) (height 10) (width 10)
         (amount_to_grow 3)) |}]
;;

let%expect_test "Testing [Game.step] with apple consumption..." =
  let t =
    create_game_with_apple_exn
      ~height:10
      ~width:10
      ~initial_snake_length:3
      ~amount_to_grow:3
      ~apple_location:{ Position.row = 9; col = 5 }
  in
  step_n_times t 3;
  set_direction t Direction.Up;
  step_n_times t 9;
  create_apple_and_update_game_exn t ~apple_location:{ Position.row = 7; col = 6 };
  Stdio.printf !"%{sexp: t}\n%!" t;
  [%expect
    {|
        ((snake
          ((direction Up) (extensions_remaining 3)
           (locations (((col 5) (row 9)) ((col 5) (row 8)) ((col 5) (row 7))))))
         (apple ((location ((col 6) (row 7))))) (game_state In_progress) (height 10)
         (width 10) (amount_to_grow 3)) |}];
  set_direction t Direction.Left;
  step_n_times t 3;
  Stdio.printf !"%{sexp: t}\n%!" t;
  [%expect
    {|
        ((snake
          ((direction Left) (extensions_remaining 0)
           (locations
            (((col 2) (row 9)) ((col 3) (row 9)) ((col 4) (row 9)) ((col 5) (row 9))
             ((col 5) (row 8)) ((col 5) (row 7))))))
         (apple ((location ((col 6) (row 7))))) (game_state In_progress) (height 10)
         (width 10) (amount_to_grow 3)) |}]
;;

let%expect_test "Testing [Game.step] with self collision..." =
  let t =
    create_game_with_apple_exn
      ~height:10
      ~width:10
      ~initial_snake_length:3
      ~amount_to_grow:3
      ~apple_location:{ Position.row = 9; col = 5 }
  in
  step_n_times t 3;
  set_direction t Direction.Up;
  step_n_times t 9;
  create_apple_and_update_game_exn t ~apple_location:{ Position.row = 7; col = 6 };
  set_direction t Direction.Left;
  step_n_times t 1;
  set_direction t Direction.Down;
  step_n_times t 1;
  Stdio.printf !"%{sexp: t}\n%!" t;
  [%expect
    {|
        ((snake
          ((direction Down) (extensions_remaining 1)
           (locations
            (((col 4) (row 8)) ((col 4) (row 9)) ((col 5) (row 9)) ((col 5) (row 8))
             ((col 5) (row 7))))))
         (apple ((location ((col 6) (row 7))))) (game_state In_progress) (height 10)
         (width 10) (amount_to_grow 3)) |}];
  set_direction t Direction.Right;
  step_n_times t 1;
  Stdio.printf !"%{sexp: t}\n%!" t;
  [%expect
    {|
        ((snake
          ((direction Right) (extensions_remaining 1)
           (locations
            (((col 4) (row 8)) ((col 4) (row 9)) ((col 5) (row 9)) ((col 5) (row 8))
             ((col 5) (row 7))))))
         (apple ((location ((col 6) (row 7)))))
         (game_state (Game_over "Self collision")) (height 10) (width 10)
         (amount_to_grow 3)) |}]
;;

let%expect_test "Testing [Game.step] with game winning..." =
  let t =
    create_game_with_apple_exn
      ~height:2
      ~width:3
      ~initial_snake_length:3
      ~amount_to_grow:3
      ~apple_location:{ Position.row = 1; col = 2 }
  in
  set_direction t Direction.Up;
  step_n_times t 1;
  set_direction t Direction.Left;
  step_n_times t 2;
  create_apple_and_update_game_exn t ~apple_location:{ Position.row = 0; col = 0 };
  Stdio.printf !"%{sexp: t}\n%!" t;
  [%expect
    {|
        ((snake
          ((direction Left) (extensions_remaining 4)
           (locations
            (((col 0) (row 1)) ((col 1) (row 1)) ((col 2) (row 1)) ((col 2) (row 0))
             ((col 1) (row 0))))))
         (apple ((location ((col 0) (row 0))))) (game_state In_progress) (height 2)
         (width 3) (amount_to_grow 3)) |}];
  set_direction t Direction.Down;
  step_n_times t 1;
  Stdio.printf !"%{sexp: t}\n%!" t;
  [%expect
    {|
        ((snake
          ((direction Down) (extensions_remaining 3)
           (locations
            (((col 0) (row 0)) ((col 0) (row 1)) ((col 1) (row 1)) ((col 2) (row 1))
             ((col 2) (row 0)) ((col 1) (row 0))))))
         (apple ((location ((col 0) (row 0))))) (game_state Win) (height 2) (width 3)
         (amount_to_grow 3)) |}]
;;
