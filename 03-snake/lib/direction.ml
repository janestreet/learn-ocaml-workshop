open! Base

type t =
  | Left
  | Up
  | Right
  | Down
[@@deriving sexp_of]

(* TODO: Implement [next_position]. *)
let next_position t position = failwith "For you to implement"

let%expect_test "Testing [next_position]..." =
  let position = { Position.row = 5; col = 5 } in
  Stdio.printf !"%{sexp: Position.t}\n%!" (next_position Left position);
  [%expect {| ((col 4) (row 5)) |}];
  Stdio.printf !"%{sexp: Position.t}\n%!" (next_position Right position);
  [%expect {| ((col 6) (row 5)) |}];
  Stdio.printf !"%{sexp: Position.t}\n%!" (next_position Up position);
  [%expect {| ((col 5) (row 6)) |}];
  Stdio.printf !"%{sexp: Position.t}\n%!" (next_position Down position);
  [%expect {| ((col 5) (row 4)) |}]
;;
