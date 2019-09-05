open! Base

type t =
  | Left
  | Up
  | Right
  | Down
[@@deriving sexp_of]

(* TODO: Implement [next_position]. *)
let next_position t { Position.row; col } : Position.t =
  match t with
  | Left -> { row; col = col - 1 }
  | Right -> { row; col = col + 1 }
  | Up -> { row = row + 1; col }
  | Down -> { row = row - 1; col }
;;

let%expect_test "Testing [next_position]..." =
  let position = { Position.row = 5; col = 5 } in
  Stdio.print_s ([%sexp_of: Position.t] (next_position Left position));
  [%expect {| ((col 4) (row 5)) |}];
  Stdio.print_s ([%sexp_of: Position.t] (next_position Right position));
  [%expect {| ((col 6) (row 5)) |}];
  Stdio.print_s ([%sexp_of: Position.t] (next_position Up position));
  [%expect {| ((col 5) (row 6)) |}];
  Stdio.print_s ([%sexp_of: Position.t] (next_position Down position));
  [%expect {| ((col 5) (row 4)) |}]
;;
