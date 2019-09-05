open! Core
open! Async

(** Represents interaction between a terminal and a user *)
type t

(** Widgets can be rendered to the screen.
    [horizontal_group] allows for horizontal grouping on a single line.
    [vertical_group] allows for there to be multiple lines printed.

    The types do not stop things like a [vertical_group] being placed
    inside of a [vertical_group], the library does not do anything
    clever to detect such situations. *)
module Widget : sig
  type t

  val text : string -> t

  (** [horizontal_group ts] will perform a horizontal grouping without a line break
      (just a space) between each [t]. *)
  val horizontal_group : t list -> t

  (** [vertical_group ts] will insert line breaks between each [t] in [ts]. *)
  val vertical_group : t list -> t
end

module User_input : sig
  type t =
    | Ctrl_c
    | Escape
    | Backspace
    | Return (* Enter key *)
    | Char of char
  [@@deriving sexp_of]
end

(** [with_rendering f] will start rendering to the terminal, and
    will return a pipe for reading user input, as well as a [t].
    When [f] becomes determined, the screen rendering will end.  *)
val with_rendering : (User_input.t Pipe.Reader.t * t -> 'a Deferred.t) -> 'a Deferred.t

(** [screen_dimensions t] returns the terminal dimensions that were
    determined when [with_rendering] was invoked. *)
val screen_dimensions : t -> Screen_dimensions.t

(** [render t w] requests that the widget [w] be rendered upon the screen.
    There is no horizontal or vertical alignment performed; the screen
    is cleared, and then [w] is drawn.

    [render] will stop drawing immediately after the last horizontal element
    provided to it in [w], there is no guarantee that will be the last row
    in the terminal.

    Users are encouraged to pad their widgets with empty [text]s in order to
    pad height *)
val render : t -> Widget.t -> unit Deferred.t
