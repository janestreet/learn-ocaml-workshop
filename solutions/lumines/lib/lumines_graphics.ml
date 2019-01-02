open Base 
open! Import

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
     set [display_mode] to true and then synchronize. This guarantees
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
  draw_sweeper game;
  Graphics.display_mode true;
  Graphics.synchronize ()
;;

let read_key () = if Graphics.key_pressed () then Some (Graphics.read_key ()) else None
