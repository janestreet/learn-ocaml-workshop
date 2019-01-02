open Base

type t =
  { board : Board.t
  ; height : int
  ; width : int
  ; mutable moving_piece :
      Moving_piece.t
  (* we will choose the bottom left corner to be the block we refer to the piece by *)
  ; mutable moving_piece_col : int
  ; mutable moving_piece_row : int
  ; game_over : bool ref
  ; sweeper : Sweeper.t
  }

let create ~height ~width ~seconds_per_sweep =
  let board = Board.create ~height ~width in
  { board
  ; height
  ; width
  ; moving_piece = Moving_piece.create ()
  ; moving_piece_col = (width - 1) / 2
  ; moving_piece_row = height
  ; game_over = ref false
  ; sweeper = Sweeper.create board ~seconds_per_sweep
  }
;;

let new_moving_piece t =
  t.moving_piece <- Moving_piece.create ();
  t.moving_piece_col <- (t.width - 1) / 2;
  t.moving_piece_row <- t.height
;;

let can_move ~row ~col t =
  (* TODO: Check if the moving the piece so the bottom left corner is at [row] [col]
     will cause it to be invalid either because it collides with a filled-in square
     on the board or because it runs off the board *)
  ignore row;
  ignore col;
  ignore t;
;;

let move_left t =
  (* TODO: Move the active piece left one square *)
  ignore t;
  ignore (can_move ~row:0 ~col:0 t);
;;

let move_right t =
  (* TODO: Move the active piece right one square *)
  ignore t;
;;

let rotate_right t = t.moving_piece <- Moving_piece.rotate_right t.moving_piece
let rotate_left t = t.moving_piece <- Moving_piece.rotate_left t.moving_piece

let drop t =
  (* TODO: drop the active piece all the way to to bottom *)
  ignore t;
;;

let tick t =
  (* TODO: handle to 1 second clock tick.
     The moving piece should try to move down one square.
     If it can't it we should check if the game is over or
     add it to the board and mark and new squares if appropriate *)
  ignore t;
;;
