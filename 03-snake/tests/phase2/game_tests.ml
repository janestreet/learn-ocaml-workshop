open! Base
open! Snake_lib
open Game
open For_testing

type nonrec t = Game.t [@@deriving sexp_of]

let%expect_test "Testing [Game.set_direction]..." =
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
