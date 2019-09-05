open! Base

type t =
  { (* [direction] represents the orientation of the snake's head. *)
    direction : Direction.t
  ; (* [extensions_remaining] represents how many more times we should extend the
       snake. *)
    extensions_remaining : int
  ; (* [locations] represents the current set of squares that the snake
       occupies. *)
    locations : Position.t list
  }
[@@deriving sexp_of]

(* TODO: Implement [create].

   Note that at the beginning of the game, the snake will not need to grow at all, so
   [extensions_remaining] should be initialized to 0. *)
let create ~length = failwith "For you to implement"

(* TODO: Implement [grow_over_next_steps].

   Read over the documentation of this function in the mli.

   Notice that this function should not actually grow the snake, but only record that we
   should grow the snake one block for the next [by_how_much] squares. *)
let grow_over_next_steps t by_how_much = failwith "For you to implement"

(* TODO: Implement [locations]. *)
let locations t = failwith "For you to implement"

(* TODO: Implement [head_location]. *)
let head_location t = failwith "For you to implement"

(* TODO: Implement [set_direction]. *)
let set_direction t direction = failwith "For you to implement"

(* TODO: Implement [step].

   Read over the documentation of this function in the mli.

   [step] should:
   - move the snake forward one block, growing it and updating [t.locations] if necessary
   - check for collisions *)
let step t = failwith "For you to implement"

let%test_module _ =
  (module struct
    let%expect_test "Testing [create]..." =
      let t = create ~length:5 in
      Stdio.printf !"%{sexp: t}\n%!" t;
      [%expect
        {|
        ((direction Right) (extensions_remaining 0)
         (locations
          (((col 4) (row 0)) ((col 3) (row 0)) ((col 2) (row 0)) ((col 1) (row 0))
           ((col 0) (row 0))))) |}]
    ;;

    let%expect_test "Testing [grow_over_next_steps]..." =
      let t = grow_over_next_steps (create ~length:5) 5 in
      Stdio.printf !"%{sexp: t}\n%!" t;
      [%expect
        {|
        ((direction Right) (extensions_remaining 5)
         (locations
          (((col 4) (row 0)) ((col 3) (row 0)) ((col 2) (row 0)) ((col 1) (row 0))
           ((col 0) (row 0))))) |}]
    ;;

    let%expect_test "Testing [locations]..." =
      let t = create ~length:5 in
      Stdio.printf !"%{sexp: Position.t list}\n%!" (locations t);
      [%expect
        {|
        (((col 4) (row 0)) ((col 3) (row 0)) ((col 2) (row 0)) ((col 1) (row 0))
         ((col 0) (row 0))) |}]
    ;;

    let%expect_test "Testing [head_location]..." =
      let t = create ~length:5 in
      Stdio.printf !"%{sexp: Position.t}\n%!" (head_location t);
      [%expect {| ((col 4) (row 0)) |}]
    ;;

    let%expect_test "Testing [set_direction]..." =
      let t = set_direction (create ~length:5) Direction.Up in
      Stdio.printf !"%{sexp: t}\n%!" t;
      [%expect
        {|
        ((direction Up) (extensions_remaining 0)
         (locations
          (((col 4) (row 0)) ((col 3) (row 0)) ((col 2) (row 0)) ((col 1) (row 0))
           ((col 0) (row 0))))) |}]
    ;;

    let step_n_times t n =
      List.fold (List.range 0 n) ~init:(Some t) ~f:(fun t _ ->
          match t with
          | Some t -> step t
          | None -> failwith "can't call step when previous step returned [None]!")
    ;;

    let%expect_test "Testing [step]..." =
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

    let%expect_test "Testing [step] with growth..." =
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

    let%expect_test "Testing [step] with growth and turn..." =
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

    let%expect_test "Testing [step] with self collision..." =
      let set_direction_if_some t dir =
        match t with
        | None ->
          failwith "tried to set direction, but previous step resulted in [None]!"
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
  end)
;;
