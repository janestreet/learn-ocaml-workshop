open! Base
open! Snake_lib
open Game
open For_testing

type nonrec t = Game.t [@@deriving sexp_of]

let%expect_test "Testing [Game.in_bounds]..." =
  let t = create ~height:10 ~width:10 ~initial_snake_length:3 ~amount_to_grow:3 in
  let test ~row ~col =
    Stdio.printf "(%d, %d) in bounds? %b\n%!" row col (in_bounds t { Position.row; col })
  in
  test ~row:5 ~col:5;
  [%expect {| (5, 5) in bounds? true |}];
  test ~row:0 ~col:8;
  [%expect {| (0, 8) in bounds? true |}];
  test ~row:(-5) ~col:3;
  [%expect {| (-5, 3) in bounds? false |}];
  test ~row:7 ~col:12;
  [%expect {| (7, 12) in bounds? false |}]
;;

let%expect_test "Testing [Game.create]..." =
  let t =
    create_game_with_apple_exn
      ~height:10
      ~width:10
      ~initial_snake_length:3
      ~amount_to_grow:3
      ~apple_location:{ Position.row = 8; col = 1 }
  in
  Stdio.printf !"%{sexp: t}\n%!" t;
  [%expect
    {|
        ((snake
          ((direction Right) (extensions_remaining 0)
           (locations (((col 2) (row 0)) ((col 1) (row 0)) ((col 0) (row 0))))))
         (apple ((location ((col 1) (row 8))))) (game_state In_progress) (height 10)
         (width 10) (amount_to_grow 3)) |}]
;;

let%expect_test "Testing [Game.create] failure..." =
  let t =
    Or_error.try_with (fun () ->
        create ~height:1 ~width:2 ~initial_snake_length:3 ~amount_to_grow:3)
  in
  Stdio.printf !"%{sexp: t Or_error.t}\n%!" t;
  [%expect {| (Error (Failure "unable to create initial apple")) |}]
;;

let%expect_test "Testing [Game.create] failure..." =
  let t =
    Or_error.try_with (fun () ->
        create ~height:10 ~width:2 ~initial_snake_length:3 ~amount_to_grow:3)
  in
  Stdio.printf !"%{sexp: t Or_error.t}\n%!" t;
  [%expect {| (Error (Failure "unable to create initial snake")) |}]
;;
