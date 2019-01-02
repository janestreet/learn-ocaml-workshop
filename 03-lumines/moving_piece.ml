open Base

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
  t
;;

let rotate_right t =
  (* TODO : rotate the piece to the right *)
  ignore t;
  t
;;

let coords ~bottom_left:{ Point.col; row } : Point.t list =
  [ { col; row }
  ; { col = col + 1; row }
  ; { col; row = row + 1 }
  ; { col = col + 1; row = row + 1 }
  ]
;;
