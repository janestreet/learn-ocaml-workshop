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

(* TODO: Implement [in_bounds] *)
let in_bounds t { Position.row; col } =
  col >= 0 && col < t.width && row >= 0 && row < t.height
;;

(* TODO: Implement [create] *)
let create ~height ~width ~initial_snake_length ~amount_to_grow =
  let snake = Snake.create ~length:initial_snake_length in
  let apple = Apple.create ~height ~width ~invalid_locations:(Snake.locations snake) in
  match apple with
  | None -> failwith "unable to create initial apple"
  | Some apple ->
    let t = { snake; apple; game_state = In_progress; height; width; amount_to_grow } in
    if List.exists (Snake.locations snake) ~f:(fun pos -> not (in_bounds t pos))
    then failwith "unable to create initial snake"
    else t
;;

let snake t = t.snake
let apple t = t.apple
let game_state t = t.game_state

(* TODO: implement [set_direction] *)
let set_direction t direction = t.snake <- Snake.set_direction t.snake direction

let maybe_consume_apple t head =
  if not ([%compare.equal: Position.t] head (Apple.location t.apple))
  then ()
  else (
    let snake = Snake.grow_over_next_steps t.snake t.amount_to_grow in
    let apple =
      Apple.create
        ~height:t.height
        ~width:t.width
        ~invalid_locations:(Snake.locations snake)
    in
    match apple with
    | None -> t.game_state <- Win
    | Some apple ->
      t.snake <- snake;
      t.apple <- apple)
;;

(* TODO: Implement [step] *)
let step t =
  match Snake.step t.snake with
  | None -> t.game_state <- Game_over "Self collision"
  | Some snake ->
    t.snake <- snake;
    let head = Snake.head_location snake in
    if not (in_bounds t head)
    then t.game_state <- Game_over "Wall collision"
    else maybe_consume_apple t head
;;

let%test_module _ =
  (module struct
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
      Random.init 0;
      let t = create ~height:10 ~width:10 ~initial_snake_length:3 ~amount_to_grow:3 in
      Stdio.print_s ([%sexp_of: t] t);
      [%expect
        {|
    ((snake
      ((direction Right) (extensions_left 0)
       (locations (((col 2) (row 0)) ((col 1) (row 0)) ((col 0) (row 0))))))
     (apple ((location ((col 1) (row 8))))) (game_state In_progress) (height 10)
     (width 10) (amount_to_grow 3)) |}]
    ;;

    let%expect_test "Testing [create] failure..." =
      Random.init 0;
      let t =
        Or_error.try_with (fun () ->
            create ~height:1 ~width:2 ~initial_snake_length:3 ~amount_to_grow:3)
      in
      Stdio.print_s ([%sexp_of: t Or_error.t] t);
      [%expect {|
    (Error (Failure "unable to create initial apple")) |}]
    ;;

    let%expect_test "Testing [create] failure..." =
      Random.init 0;
      let t =
        Or_error.try_with (fun () ->
            create ~height:10 ~width:2 ~initial_snake_length:3 ~amount_to_grow:3)
      in
      Stdio.print_s ([%sexp_of: t Or_error.t] t);
      [%expect {|
    (Error (Failure "unable to create initial snake")) |}]
    ;;

    let%expect_test "Testing [set_direction]..." =
      Random.init 0;
      let t = create ~height:10 ~width:10 ~initial_snake_length:3 ~amount_to_grow:3 in
      set_direction t Down;
      Stdio.print_s ([%sexp_of: t] t);
      [%expect
        {|
           ((snake
             ((direction Down) (extensions_left 0)
              (locations (((col 2) (row 0)) ((col 1) (row 0)) ((col 0) (row 0))))))
            (apple ((location ((col 1) (row 8))))) (game_state In_progress) (height 10)
            (width 10) (amount_to_grow 3)) |}]
    ;;

    let step_n_times t n = List.iter (List.range 0 n) ~f:(fun _ -> step t)

    let%expect_test "Testing [step] with wall collision..." =
      Random.init 0;
      let t = create ~height:10 ~width:10 ~initial_snake_length:3 ~amount_to_grow:3 in
      step_n_times t 7;
      Stdio.print_s ([%sexp_of: t] t);
      [%expect
        {|
    ((snake
      ((direction Right) (extensions_left 0)
       (locations (((col 9) (row 0)) ((col 8) (row 0)) ((col 7) (row 0))))))
     (apple ((location ((col 1) (row 8))))) (game_state In_progress) (height 10)
     (width 10) (amount_to_grow 3)) |}];
      step_n_times t 1;
      Stdio.print_s ([%sexp_of: t] t);
      [%expect
        {|
    ((snake
      ((direction Right) (extensions_left 0)
       (locations (((col 10) (row 0)) ((col 9) (row 0)) ((col 8) (row 0))))))
     (apple ((location ((col 1) (row 8)))))
     (game_state (Game_over "Wall collision")) (height 10) (width 10)
     (amount_to_grow 3)) |}]
    ;;

    let%expect_test "Testing [step] with apple consumption..." =
      Random.init 2;
      let t = create ~height:10 ~width:10 ~initial_snake_length:3 ~amount_to_grow:3 in
      step_n_times t 3;
      set_direction t Up;
      step_n_times t 9;
      Stdio.print_s ([%sexp_of: t] t);
      [%expect
        {|
    ((snake
      ((direction Up) (extensions_left 3)
       (locations (((col 5) (row 9)) ((col 5) (row 8)) ((col 5) (row 7))))))
     (apple ((location ((col 6) (row 7))))) (game_state In_progress) (height 10)
     (width 10) (amount_to_grow 3)) |}];
      set_direction t Left;
      step_n_times t 3;
      Stdio.print_s ([%sexp_of: t] t);
      [%expect
        {|
    ((snake
      ((direction Left) (extensions_left 0)
       (locations
        (((col 2) (row 9)) ((col 3) (row 9)) ((col 4) (row 9)) ((col 5) (row 9))
         ((col 5) (row 8)) ((col 5) (row 7))))))
     (apple ((location ((col 6) (row 7))))) (game_state In_progress) (height 10)
     (width 10) (amount_to_grow 3)) |}]
    ;;

    let%expect_test "Testing [step] with self collision..." =
      Random.init 2;
      let t = create ~height:10 ~width:10 ~initial_snake_length:3 ~amount_to_grow:3 in
      step_n_times t 3;
      set_direction t Up;
      step_n_times t 9;
      set_direction t Left;
      step_n_times t 1;
      set_direction t Down;
      step_n_times t 1;
      Stdio.print_s ([%sexp_of: t] t);
      [%expect
        {|
    ((snake
      ((direction Down) (extensions_left 1)
       (locations
        (((col 4) (row 8)) ((col 4) (row 9)) ((col 5) (row 9)) ((col 5) (row 8))
         ((col 5) (row 7))))))
     (apple ((location ((col 6) (row 7))))) (game_state In_progress) (height 10)
     (width 10) (amount_to_grow 3)) |}];
      set_direction t Right;
      step_n_times t 1;
      Stdio.print_s ([%sexp_of: t] t);
      [%expect
        {|
        ((snake
          ((direction Right) (extensions_left 1)
           (locations
            (((col 4) (row 8)) ((col 4) (row 9)) ((col 5) (row 9)) ((col 5) (row 8))
             ((col 5) (row 7))))))
         (apple ((location ((col 6) (row 7)))))
         (game_state (Game_over "Self collision")) (height 10) (width 10)
         (amount_to_grow 3)) |}]
    ;;

    let%expect_test "Testing [step] with game winning..." =
      Random.init 71;
      let t = create ~height:2 ~width:3 ~initial_snake_length:3 ~amount_to_grow:3 in
      set_direction t Up;
      step_n_times t 1;
      set_direction t Left;
      step_n_times t 2;
      Stdio.print_s ([%sexp_of: t] t);
      [%expect
        {|
    ((snake
      ((direction Left) (extensions_left 4)
       (locations
        (((col 0) (row 1)) ((col 1) (row 1)) ((col 2) (row 1)) ((col 2) (row 0))
         ((col 1) (row 0))))))
     (apple ((location ((col 0) (row 0))))) (game_state In_progress) (height 2)
     (width 3) (amount_to_grow 3)) |}];
      set_direction t Down;
      step_n_times t 1;
      Stdio.print_s ([%sexp_of: t] t);
      [%expect
        {|
    ((snake
      ((direction Down) (extensions_left 3)
       (locations
        (((col 0) (row 0)) ((col 0) (row 1)) ((col 1) (row 1)) ((col 2) (row 1))
         ((col 2) (row 0)) ((col 1) (row 0))))))
     (apple ((location ((col 0) (row 0))))) (game_state Win) (height 2) (width 3)
     (amount_to_grow 3)) |}]
    ;;
  end)
;;
