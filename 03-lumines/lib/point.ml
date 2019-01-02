open Base 

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
