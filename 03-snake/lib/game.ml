open! Base

type t =
  { mutable snake : Snake.t
  ; mutable apple : Apple.t
  ; mutable game_state : Game_state.t
  ; height : int
  ; width : int
  ; amount_to_grow : int
  }
[@@deriving sexp_of]

(* TODO: Implement [in_bounds]. *)
let in_bounds t { Position.row; col } = failwith "For you to implement"

(* TODO: Implement [create]. *)
let create ~height ~width ~initial_snake_length ~amount_to_grow =
  failwith "For you to implement"
;;

let snake t = t.snake
let apple t = t.apple
let game_state t = t.game_state

(* TODO: Implement [set_direction]. *)
let set_direction t direction : unit = failwith "For you to implement"

(* TODO: Implement [step].

   [step] should:
   - move the snake forward one square
   - check for collisions
   - consume and regenerate apple, if necessary *)
let step t = failwith "For you to implement"

let%test_module _ =
  (module struct
    module Apple_utils = struct
      (* [create_force_location_exn], [create_and_update_game_exn], and
         [create_game_with_apple_exn] are helper functions for forcing the location of an apple
         on a board. This is helpful to get around non-determinism due to randomness in
         tests. *)
      let create_force_location_exn ~height ~width ~location =
        let invalid_locations =
          List.init height ~f:(fun row ->
              List.init width ~f:(fun col -> { Position.row; col }))
          |> List.concat
          |> List.filter ~f:(fun pos -> not ([%compare.equal: Position.t] location pos))
        in
        match Apple.create ~height ~width ~invalid_locations with
        | None -> failwith "[Apple.create] returned [None] when [Some _] was expected!"
        | Some apple -> apple
      ;;

      let create_and_update_game_exn t ~height ~width ~apple_location =
        let apple = create_force_location_exn ~height ~width ~location:apple_location in
        t.apple <- apple
      ;;

      let create_game_with_apple_exn
          ~height
          ~width
          ~initial_snake_length
          ~amount_to_grow
          ~apple_location
        =
        let t = create ~height ~width ~initial_snake_length ~amount_to_grow in
        create_and_update_game_exn t ~height ~width ~apple_location;
        t
      ;;
    end

    open Apple_utils

    let%expect_test "Testing [in_bounds]..." =
      let t = create ~height:10 ~width:10 ~initial_snake_length:3 ~amount_to_grow:3 in
      let test ~row ~col =
        Stdio.printf
          "(%d, %d) in bounds? %b\n%!"
          row
          col
          (in_bounds t { Position.row; col })
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

    let%expect_test "Testing [create]..." =
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

    let%expect_test "Testing [create] failure..." =
      let t =
        Or_error.try_with (fun () ->
            create ~height:1 ~width:2 ~initial_snake_length:3 ~amount_to_grow:3)
      in
      Stdio.printf !"%{sexp: t Or_error.t}\n%!" t;
      [%expect {| (Error (Failure "unable to create initial apple")) |}]
    ;;

    let%expect_test "Testing [create] failure..." =
      let t =
        Or_error.try_with (fun () ->
            create ~height:10 ~width:2 ~initial_snake_length:3 ~amount_to_grow:3)
      in
      Stdio.printf !"%{sexp: t Or_error.t}\n%!" t;
      [%expect {| (Error (Failure "unable to create initial snake")) |}]
    ;;

    let%expect_test "Testing [set_direction]..." =
      let t =
        create_game_with_apple_exn
          ~height:10
          ~width:10
          ~initial_snake_length:3
          ~amount_to_grow:3
          ~apple_location:{ Position.row = 8; col = 1 }
      in
      set_direction t Direction.Down;
      Stdio.printf !"%{sexp: t}\n%!" t;
      [%expect
        {|
        ((snake
          ((direction Down) (extensions_remaining 0)
           (locations (((col 2) (row 0)) ((col 1) (row 0)) ((col 0) (row 0))))))
         (apple ((location ((col 1) (row 8))))) (game_state In_progress) (height 10)
         (width 10) (amount_to_grow 3)) |}]
    ;;

    let step_n_times t n = List.iter (List.range 0 n) ~f:(fun _ -> step t)

    let%expect_test "Testing [step] with wall collision..." =
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

    let%expect_test "Testing [step] with apple consumption..." =
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
      create_and_update_game_exn
        t
        ~height:10
        ~width:10
        ~apple_location:{ Position.row = 7; col = 6 };
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

    let%expect_test "Testing [step] with self collision..." =
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
      create_and_update_game_exn
        t
        ~height:10
        ~width:10
        ~apple_location:{ Position.row = 7; col = 6 };
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

    let%expect_test "Testing [step] with game winning..." =
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
      create_and_update_game_exn
        t
        ~height:2
        ~width:3
        ~apple_location:{ Position.row = 0; col = 0 };
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
  end)
;;
