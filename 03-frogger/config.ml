open! Base
open! Import

open Scaffold

type t =
  { num_cols           : int
  ; num_rows           : int
  ; grid_size_in_px    : int
  ; render_interval_ms : float
  ; logic_interval_ms  : float
  }

let default =
  { num_rows           = List.length Board.rows
  ; num_cols           = Board.num_cols
  ; grid_size_in_px    = 50
  ; render_interval_ms = 50.
  ; logic_interval_ms  = 1000.
  }

let width  t = t.num_cols * t.grid_size_in_px
let height t = t.num_rows * t.grid_size_in_px


