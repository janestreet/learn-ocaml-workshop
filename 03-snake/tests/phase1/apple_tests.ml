open! Base
open! Snake_lib
open Apple

let%expect_test "Testing [Apple.create]..." =
  let apple = create ~height:10 ~width:10 ~invalid_locations:[] in
  match apple with
  | None -> failwith "[create] returned [None] when [Some _] was expected!"
  | Some apple ->
    let { Position.row; col } = location apple in
    if row < 0 || row >= 10 || col < 0 || col >= 10
    then failwith "[create] returned an invalid apple!"
    else ()
;;

let%expect_test "Testing [Apple.create]..." =
  let invalid_locations =
    List.init 10 ~f:(fun row -> List.init 10 ~f:(fun col -> { Position.row; col }))
    |> List.concat
  in
  let apple = create ~height:10 ~width:10 ~invalid_locations in
  Stdio.printf !"%{sexp: t option}\n%!" apple;
  [%expect {| () |}]
;;
