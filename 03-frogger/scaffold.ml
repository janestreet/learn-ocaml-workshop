open Base
 
module Position = struct
  type t =
    { x : int
    ; y : int
    } [@@deriving fields, sexp]

  let create = Fields.create
end

module Image = struct
  type t =
    | Frog_up
    | Frog_down
    | Frog_left
    | Frog_right

    | Car1_left
    | Car1_right
    | Car2_left
    | Car2_right
    | Car3_left
    | Car3_right

    | Log1
    | Log2
    | Log3

    | Confetti
    | Skull_and_crossbones
  [@@deriving sexp, variants]
end

module Display_list = struct
  module Display_command = struct
    type nonrec t = Image.t * Position.t [@@deriving sexp]
  end

  type t = Display_command.t list [@@deriving sexp]
end

module Key = struct
  type t =
    | Arrow_up
    | Arrow_down
    | Arrow_left
    | Arrow_right
end

module Event = struct
  type t =
    | Tick
    | Keypress of Key.t
end

module Board = struct
  (** Every row of the game board is one of these three kinds. *)
  module Row = struct
    type t =
      | Safe_strip
      | Road
      | River
  end

  let num_cols = 10

  (** The first and last rows are guaranteed to be [Safe_strip]s. *)
  let rows =
    let open Row in
    [ Safe_strip
    ; River
    ; River
    ; River
    ; River
    ; River
    ; Safe_strip
    ; Road
    ; Road
    ; Road
    ; Road
    ; Safe_strip
    ]
    |> List.rev
  ;;
end

let console_log s =
  Firebug.console##log s
;;
