open Core

type t

val create : spin_every:Time.Span.t -> t
val finish : t -> unit
val to_char : t -> char option
val advance : t -> unit
