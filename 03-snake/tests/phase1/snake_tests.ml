open! Base
open! Snake_lib
open Snake

let%expect_test "Testing [Snake.create]..." =
  let t = create ~length:5 in
  Stdio.printf !"%{sexp: t}\n%!" t;
  [%expect
    {|
    ((direction Right) (extensions_remaining 0)
     (locations
      (((col 4) (row 0)) ((col 3) (row 0)) ((col 2) (row 0)) ((col 1) (row 0))
       ((col 0) (row 0))))) |}]
;;

let%expect_test "Testing [Snake.locations]..." =
  let t = create ~length:5 in
  Stdio.printf !"%{sexp: Position.t list}\n%!" (locations t);
  [%expect
    {|
    (((col 4) (row 0)) ((col 3) (row 0)) ((col 2) (row 0)) ((col 1) (row 0))
     ((col 0) (row 0))) |}]
;;
