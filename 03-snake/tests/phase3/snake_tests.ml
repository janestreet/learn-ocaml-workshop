open! Base
open! Snake_lib
open Snake

let step_n_times t n =
  List.fold (List.range 0 n) ~init:(Some t) ~f:(fun t _ ->
      match t with
      | Some t -> step t
      | None -> failwith "can't call step when previous step returned [None]!")
;;

let%expect_test "Testing [Snake.step]..." =
  let t = create ~length:5 in
  let t = step_n_times t 5 in
  Stdio.printf !"%{sexp: t option}\n%!" t;
  [%expect
    {|
    (((direction Right) (extensions_remaining 0)
      (locations
       (((col 9) (row 0)) ((col 8) (row 0)) ((col 7) (row 0)) ((col 6) (row 0))
        ((col 5) (row 0)))))) |}]
;;

let%expect_test "Testing [Snake.step] with growth..." =
  let t = grow_over_next_steps (create ~length:5) 5 in
  let t = step_n_times t 5 in
  Stdio.printf !"%{sexp: t option}\n%!" t;
  [%expect
    {|
    (((direction Right) (extensions_remaining 0)
      (locations
       (((col 9) (row 0)) ((col 8) (row 0)) ((col 7) (row 0)) ((col 6) (row 0))
        ((col 5) (row 0)) ((col 4) (row 0)) ((col 3) (row 0)) ((col 2) (row 0))
        ((col 1) (row 0)) ((col 0) (row 0)))))) |}]
;;

let%expect_test "Testing [Snake.step] with growth and turn..." =
  let t =
    create ~length:5
    |> fun t ->
    grow_over_next_steps t 5
    |> fun t -> set_direction t Direction.Up |> fun t -> step_n_times t 5
  in
  Stdio.printf !"%{sexp: t option}\n%!" t;
  [%expect
    {|
    (((direction Up) (extensions_remaining 0)
      (locations
       (((col 4) (row 5)) ((col 4) (row 4)) ((col 4) (row 3)) ((col 4) (row 2))
        ((col 4) (row 1)) ((col 4) (row 0)) ((col 3) (row 0)) ((col 2) (row 0))
        ((col 1) (row 0)) ((col 0) (row 0)))))) |}]
;;

let%expect_test "Testing [Snake.step] with self collision..." =
  let set_direction_if_some t dir =
    match t with
    | None -> failwith "tried to set direction, but previous step resulted in [None]!"
    | Some t -> set_direction t dir
  in
  let t =
    create ~length:10
    |> fun t ->
    step_n_times t 1
    |> fun t ->
    set_direction_if_some t Direction.Up
    |> fun t ->
    step_n_times t 1
    |> fun t ->
    set_direction_if_some t Direction.Left
    |> fun t ->
    step_n_times t 1
    |> fun t -> set_direction_if_some t Direction.Right |> fun t -> step_n_times t 1
  in
  Stdio.printf !"%{sexp: t option}\n%!" t;
  [%expect {| () |}]
;;
