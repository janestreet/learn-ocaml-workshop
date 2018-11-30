open Base

(* For this game we have given you a framework and you will need to implement the
   actual logic to make the game run.

   We've given you the event-loop that drives the game and handles keyboard input.

   You will have to implement the logic that keeps the game state correct and updates
   things based on those inputs!

   Fill in the functions marked with TODO to get the game running.

   Once this is working there are many extensions that we'd love to see you try
   and implement, for example:
   - calculate a score
   - make the game speed up over time
   - change the color scheme after a certain number of blocks have been cleared
   - add blocks that have different abilities (e.g. one that clears adjacent blocks )

   We're sure you can come up with some interesting extensions of your own too.
*)

(* this is hard-coded so that we can refer to in in a few places in the code *)
let pixels_per_square = 28

(* We have a simple colors scheme with two colors: Orange and white *)
module Color : sig
  type t =
    | Orange
    | White

  (* compares two colors. returns 0 if they are the same *)

  val compare : t -> t -> int

  (* get a random color *)

  val random : unit -> t
  val equal : t -> t -> bool
end = struct
  type t =
    | Orange
    | White

  let compare t1 t2 =
    match t1, t2 with
    | White, White
    | Orange, Orange -> 0
    | White, Orange -> 1
    | Orange, White -> -1
  ;;

  let random () = if Random.int 2 = 0 then Orange else White
  let equal t1 t2 = compare t1 t2 = 0
end

(* A filled in square on the board has two pieces of state. The color
   that it is right, now and the "state" that it's currently in.

   The state is one of:
   - Unmarked : this means that it is not part of any completed square
   - To_sweep : this means it is part of a completed square and the sweeper will delete
     it when it passes all connected to_sweep [Filled_square]s
   - Swept : this means that the sweeper has passed this, square and it is 'deleted'
     it will be actually removed from the board when the sweeper reaches the end of the
     blocks to delete *)
module Filled_square : sig
  module Sweeper_state : sig
    type t =
      | Unmarked
      | To_sweep
      | Swept

    val equal : t -> t -> bool
  end

  type t =
    { color :
        Color.t
    (* recall from our earlier exercise, by marking this as mutable we can change it in
       place rather than making a new one every time the state update *)
    ; mutable sweeper_state : Sweeper_state.t
    }

  (* create takes a color and returns a filled_square.  All squares start off with
     a state of Unmarked *)

  val create : Color.t -> t

  (* unmark sets the state to Unmarked *)

  val unmark : t -> unit

  (* to_sweep sets the state to To_sweep *)

  val to_sweep : t -> unit

  (* sweep checks the current state of t.
     if it is To_sweep it marks it as swept and returns true
     otherwise it doesn't change the state and returns false *)

  val sweep : t -> bool
  val equal : t -> t -> bool
end = struct
  module Sweeper_state = struct
    type t =
      | Unmarked
      | To_sweep
      | Swept

    let equal t1 t2 =
      match t1, t2 with
      | Unmarked, Unmarked
      | To_sweep, To_sweep
      | Swept, Swept -> true
      | _ -> false
    ;;
  end

  type t =
    { color : Color.t
    ; mutable sweeper_state : Sweeper_state.t
    }

  let create color = { color; sweeper_state = Unmarked }
  let unmark t = t.sweeper_state <- Unmarked
  let to_sweep t = t.sweeper_state <- To_sweep

  let sweep t =
    match t.sweeper_state with
    | To_sweep ->
      t.sweeper_state <- Swept;
      true
    | Unmarked | Swept -> false
  ;;

  let equal t1 t2 =
    Color.equal t1.color t2.color
    && Sweeper_state.equal t1.sweeper_state t2.sweeper_state
  ;;
end

module Point : sig
  (* It is uesful to refer to points in our grid using this record. This allows us
     to avoid making mistakes about which coordinate is the row and which is to column

     We have provided a selection of useful functions, but feel free to add any others
     you find you want
  *)

  type t =
    { col : int
    ; row : int
    }

  (* [add] takes two t's and returns the t that is the sum of their rows and columns *)

  val add : t -> t -> t

  (* returns 0 if the rows are equal a positive number if the first is > the second
     and a negative number if the first is < the second *)

  val compare_by_row : t -> t -> int

  (* returns 0 if the cols are equal a positive number if the first is > the second
     and a negative number if the first is < the second *)

  val compare_by_col : t -> t -> int

  (* This is uesful for the graphics portion of the library.  Feel free to ignore all
     these functions *)
  module For_drawing : sig
    val fill_rect : Graphics.color -> t -> t -> unit
    val draw_rect : Graphics.color -> t -> t -> unit
    val origin : t
  end
end = struct
  type t =
    { col : int
    ; row : int
    }

  let add t1 t2 = { col = t1.col + t2.col; row = t1.row + t2.row }
  let compare_by_row { col = _; row = row1 } { col = _; row = row2 } = row1 - row2
  let compare_by_col { col = col1; row = _ } { col = col2; row = _ } = col1 - col2

  module For_drawing = struct
    let for_rect
          ~f
          color
          { col = from_col; row = from_row }
          { col = to_col; row = to_row }
      =
      Graphics.set_color color;
      f from_col from_row (to_col - from_col) (to_row - from_row)
    ;;

    let fill_rect = for_rect ~f:Graphics.fill_rect
    let draw_rect = for_rect ~f:Graphics.draw_rect
    let origin = { col = 0; row = 0 }
  end
end

module Moving_piece : sig
  (* A moving piece is made up of 4 squares *)

  type t =
    { top_left : Filled_square.t
    ; top_right : Filled_square.t
    ; bottom_left : Filled_square.t
    ; bottom_right : Filled_square.t
    }

  (* create creates a new random peice *)

  val create : unit -> t

  (* rotate_left returns a new moving peice where the colors have been rotated left *)

  val rotate_left : t -> t

  (* rotate_right returns a new moving peice where the colors have been rotated right *)

  val rotate_right : t -> t

  (* given the column and row of the bottom left block return a list of the 4 coordinates
     of the block (returned in (col,row) order) *)

  val coords : bottom_left:Point.t -> Point.t list
end = struct
  type t =
    { top_left : Filled_square.t
    ; top_right : Filled_square.t
    ; bottom_left : Filled_square.t
    ; bottom_right : Filled_square.t
    }

  let create () =
    { top_left = Filled_square.create (Color.random ())
    ; top_right = Filled_square.create (Color.random ())
    ; bottom_left = Filled_square.create (Color.random ())
    ; bottom_right = Filled_square.create (Color.random ())
    }
  ;;

  let rotate_left t =
    (* TODO : rotate the piece to the left *)
    ignore t;
    assert false
  ;;

  let rotate_right t =
    (* TODO : rotate the piece to the right *)
    ignore t;
    assert false
  ;;

  let coords ~bottom_left:{ Point.col; row } : Point.t list =
    [ { col; row }
    ; { col = col + 1; row }
    ; { col; row = row + 1 }
    ; { col = col + 1; row = row + 1 }
    ]
  ;;
end

module Board : sig
  (* The board is a 2dimensional array of filled_square options. If the
     square is empty we represent that with None.  If it is is filled
     we represent it with Some Filled_Square.  We have provided getter
     and setter functions to get values out of the array *)

  type t =
    { board : Filled_square.t option array array
    ; height : int
    ; width : int
    }

  (* given a height and width, make a board *)

  val create : height:int -> width:int -> t

  (* get the value at a given row and col *)

  val get : t -> Point.t -> Filled_square.t option

  (* set the value at a given row and col *)

  val set : t -> Point.t -> Filled_square.t option -> unit

  (* remove_squares will be called by the sweeper.  It should delete any squares
     marked as Swept from the board and leave the board in a valid state *)

  val remove_squares : t -> unit

  (* add_piece takes a piece, and the left column, insert it into the board
     returns true if it was able to add the peice to the baord and false
     otherwise *)

  val add_piece : t -> moving_piece:Moving_piece.t -> col:int -> bool

  (* [is_empty] takes a row and a col and returns:
     true  if that square is empty
     false if that square is filled
  *)

  val is_empty : t -> Point.t -> bool
end = struct
  type t =
    { board : Filled_square.t option array array
    ; height : int
    ; width : int
    }

  let create ~height ~width =
    { board = Array.make_matrix ~dimx:width ~dimy:height None; height; width }
  ;;

  let get t { Point.col; row } = t.board.(col).(row)
  let set t { Point.col; row } value = t.board.(col).(row) <- value

  let mark_squares t =
    (* TODO: at the end of this function the all
       filled_squares that are part of completed squares
       (anything that is in a single color square of 4 parts which includes
       combined groups)
       should be in sweeper state [`to_sweep] and
       all other squares should be [`unmarked]
    *)
    ignore t;
    assert false
  ;;

  let remove_squares t =
    (* TODO: any sqaures that are marked as [`swept] should be removed from the board.
       Gravity should be applied appropriately.

       at the end of this function we should call [mark_squares] so that we ensure that
       we leave the board in a valid state
    *)
    ignore (mark_squares t);
    assert false
  ;;

  let add_piece t ~moving_piece ~col =
    (* TODO: insert the moving piece into the board applying gravity appropriately *)
    ignore t;
    ignore moving_piece;
    ignore col;
    assert false
  ;;

  let is_empty t point =
    match get t point with
    | None -> true
    | Some _ -> false
  ;;
end

(* We have implemented the sweeper for you.
   Feel free to look at this code for reference, but you shouldn't need to change
   anything within this module unless you are making a different variant of the game. *)
module Sweeper : sig
  type t

  val create : Board.t -> seconds_per_sweep:float -> t

  (* get the current postion of the sweeper *)

  val cur_pos : t -> int

  (* [seconds_per_step] returns how quickly the step function should be called to make it
     sweep the board in the time given by seconds per sweep *)

  val seconds_per_step : t -> float

  (* step advances the sweeper one square and potentially removes squares from the board *)

  val step : t -> unit
end = struct
  type t =
    { board : Board.t
    ; seconds_per_sweep : float
    ; mutable cur_pos : int
    }

  let create board ~seconds_per_sweep = { board; seconds_per_sweep; cur_pos = 0 }
  let cur_pos t = t.cur_pos

  let seconds_per_step t =
    let steps = (pixels_per_square * t.board.Board.width) - 1 in
    let seconds_per_step = t.seconds_per_sweep /. Float.of_int steps in
    seconds_per_step
  ;;

  let step t =
    let steps = (pixels_per_square * t.board.Board.width) - 1 in
    (* Clear squares *)
    if t.cur_pos % pixels_per_square = 0
    then (
      let check_col = t.cur_pos / pixels_per_square in
      let more_marked =
        List.fold_left (List.range 0 t.board.height) ~init:false ~f:(fun acc row ->
          let color = Board.get t.board { Point.row; col = check_col } in
          match color with
          | None -> acc
          | Some filled_square -> Filled_square.sweep filled_square || acc)
      in
      if not more_marked || t.cur_pos = steps then Board.remove_squares t.board);
    (* advance sweeper *)
    if t.cur_pos < steps then t.cur_pos <- t.cur_pos + 1 else t.cur_pos <- 0
  ;;
end

module Game : sig
  (* This module holds the entire game state  *)

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

  val create : height:int -> width:int -> seconds_per_sweep:float -> t

  (* put a new piece at the top of the board *)

  val new_moving_piece : t -> unit

  (* move the piece on the board *)

  val move_left : t -> unit
  val move_right : t -> unit
  val rotate_left : t -> unit
  val rotate_right : t -> unit
  val drop : t -> unit

  (* handle the clock ticking once *)

  val tick : t -> unit
end = struct
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
       will cause it to be invalid either because it collides with a filled in square
       on the board or because it runs off the board *)
    ignore row;
    ignore col;
    ignore t;
    assert false
  ;;

  let move_left t =
    (* TODO: Move the active peice left one square *)
    ignore t;
    ignore (can_move ~row:0 ~col:0 t);
    assert false
  ;;

  let move_right t =
    (* TODO: Move the active peice right one square *)
    ignore t;
    assert false
  ;;

  let rotate_right t = t.moving_piece <- Moving_piece.rotate_right t.moving_piece
  let rotate_left t = t.moving_piece <- Moving_piece.rotate_left t.moving_piece

  let drop t =
    (* TODO: drop the active piece all the way to to bottom *)
    ignore t;
    assert false
  ;;

  let tick t =
    (* TODO: handle to 1 second clock tick.
       The moving peice should try to move down one square.
       If it can't it we should check if the game is over or
       add it to the board and mark and new squares if appropriate *)
    ignore t;
    assert false
  ;;
end

module Graphics : sig
  (* This module handles the graphics for the game.  We have implemented this
     for you so you don't need to change anything here, but feel free to look around
     and once you have the game working, feel free to alter this to make things fancier *)

  (* Fails if called twice *)

  val init_exn : Game.t -> unit

  (* redraw the board *)

  val draw : Game.t -> unit

  (* return for keyboard input if it's available *)

  val read_key : unit -> char option
end = struct
  let only_one : bool ref = ref false
  let part_size = { Point.col = pixels_per_square; row = pixels_per_square }
  let extra_part_size_above = 2

  let dimensions (game : Game.t) =
    { Point.col = game.width * part_size.col
    ; row =
        (game.height + extra_part_size_above) * part_size.row
        (* We want 2 extra moving_pieces on top *)
    }
  ;;

  let init_exn game =
    (* Should raise if called twice *)
    if !only_one then failwith "Can only call init_exn once" else only_one := true;
    let { Point.col; row } = dimensions game in
    Graphics.open_graph (Printf.sprintf " %dx%d" row col)
  ;;

  let filled_square_to_rgb (filled_square : Filled_square.t) =
    let open Graphics in
    match filled_square.color, filled_square.sweeper_state with
    | Color.White, Unmarked -> rgb 230 242 230
    | Orange, Unmarked -> rgb 251 110 22
    | Orange, To_sweep -> rgb 252 159 53
    | White, To_sweep -> rgb 206 204 202
    | _, Swept -> rgb 60 60 60
  ;;

  let draw_part filled_square ~from =
    (* Make things look pretty *)
    (match filled_square.Filled_square.sweeper_state with
     | To_sweep | Swept ->
       Point.For_drawing.fill_rect
         Graphics.(rgb 198 197 196)
         from
         (Point.add from part_size)
     | Unmarked -> ());
    Point.For_drawing.fill_rect
      (filled_square_to_rgb filled_square)
      (Point.add from { Point.col = 2; row = 2 })
      (Point.add (Point.add from part_size) { Point.col = -2; row = -2 })
  ;;

  let draw_moving_piece
        ~(draw_bottom_left : Point.t)
        { Moving_piece.top_left; top_right; bottom_left; bottom_right }
    =
    draw_part bottom_left ~from:draw_bottom_left;
    draw_part
      bottom_right
      ~from:(Point.add draw_bottom_left { Point.col = part_size.col; row = 0 });
    draw_part
      top_left
      ~from:(Point.add draw_bottom_left { Point.col = 0; row = part_size.row });
    draw_part top_right ~from:(Point.add draw_bottom_left part_size)
  ;;

  let draw_bg ~from =
    Point.For_drawing.fill_rect
      Graphics.(rgb 33 32 31)
      (Point.add from { Point.col = 1; row = 1 })
      (Point.add (Point.add from part_size) { Point.col = -1; row = -1 })
  ;;

  let draw_sweeper (game : Game.t) =
    let height = game.height * pixels_per_square in
    let pos = Sweeper.cur_pos game.sweeper in
    Point.For_drawing.fill_rect
      Graphics.(rgb 0 229 255)
      { Point.col = pos; row = 0 }
      { Point.col = pos + 1; row = height }
  ;;

  let draw game =
    let open Graphics in
    (* We want double-buffering. See
       https://caml.inria.fr/pub/docs/manual-ocaml/libref/Graphics.html
       for more info!

       So, we set [display_mode] to false, draw to the background buffer,
       set [display_mode] to true and then synchronized. This guarantees
       that there won't be flickering!
    *)
    Graphics.display_mode false;
    set_color black;
    let dims = dimensions game in
    Point.For_drawing.fill_rect black Point.For_drawing.origin dims;
    List.iter (List.range 0 game.Game.width) ~f:(fun col ->
      List.iter (List.range 0 game.Game.height) ~f:(fun row ->
        draw_bg ~from:{ col = part_size.col * col; row = part_size.row * row }));
    draw_moving_piece
      ~draw_bottom_left:
        { Point.col = game.Game.moving_piece_col * part_size.col
        ; row = game.Game.moving_piece_row * part_size.row
        }
      game.Game.moving_piece;
    List.iter (List.range 0 game.Game.width) ~f:(fun col ->
      List.iter (List.range 0 game.Game.height) ~f:(fun row ->
        match Board.get game.Game.board { row; col } with
        | None -> ()
        | Some color ->
          draw_part
            color
            ~from:{ col = part_size.col * col; row = part_size.row * row }));
    draw_sweeper game
  ;;

  let read_key () = if Graphics.key_pressed () then Some (Graphics.read_key ()) else None
end

let every seconds ~f ~stop =
  let open Async in
  let open Core in
  let rec loop () =
    if !stop
    then return ()
    else (
      Clock.after (Time.Span.of_sec seconds)
      >>= fun () ->
      f ();
      loop ())
  in
  don't_wait_for (loop ())
;;

(* run_sweeper sets up a loop that steps the sweeper forward
   and redraws the game *)
let run_sweeper (game : Game.t) =
  every ~stop:game.game_over (Sweeper.seconds_per_step game.sweeper) ~f:(fun () ->
    Sweeper.step game.sweeper;
    Graphics.draw game)
;;

let handle_keys (game : Game.t) =
  every ~stop:game.game_over 0.01 ~f:(fun () ->
    match Graphics.read_key () with
    | None -> ()
    | Some key ->
      let update =
        match key with
        | 'a' ->
          Game.move_left game;
          true
        | 'd' ->
          Game.move_right game;
          true
        | 'w' ->
          Game.rotate_left game;
          true
        | 's' ->
          Game.rotate_right game;
          true
        | ' ' ->
          Game.drop game;
          true
        | _ -> false
      in
      if update && not !(game.game_over) then Graphics.draw game)
;;

let handle_clock_tick (game : Game.t) =
  every ~stop:game.game_over 1. ~f:(fun () ->
    Game.tick game;
    Graphics.draw game)
;;

(* this is the core loop that powers the game *)
let run () =
  let game = Game.create ~height:14 ~width:16 ~seconds_per_sweep:3. in
  handle_keys game;
  run_sweeper game;
  handle_clock_tick game
;;

let () =
  run ();
  Core_kernel.never_returns (Async.Scheduler.go ())
;;
