open! Base
open! Snake_lib
open Snake

let%expect_test "Testing [Snake.grow_over_next_steps]..." =
  let t = grow_over_next_steps (create ~length:5) 5 in
  Stdio.printf !"%{sexp: t}\n%!" t;
  [%expect
    {|
    ((direction Right) (extensions_remaining 5)
     (locations
      (((col 4) (row 0)) ((col 3) (row 0)) ((col 2) (row 0)) ((col 1) (row 0))
       ((col 0) (row 0))))) |}]
;;

let%expect_test "Testing [Snake.head_location]..." =
  let t = create ~length:5 in
  Stdio.printf !"%{sexp: Position.t}\n%!" (head_location t);
  [%expect {| ((col 4) (row 0)) |}]
;;

let%expect_test "Testing [Snake.set_direction]..." =
  let t = set_direction (create ~length:5) Direction.Up in
  Stdio.printf !"%{sexp: t}\n%!" t;
  [%expect
    {|
    ((direction Up) (extensions_remaining 0)
     (locations
      (((col 4) (row 0)) ((col 3) (row 0)) ((col 2) (row 0)) ((col 1) (row 0))
       ((col 0) (row 0))))) |}]
;;
