open Base

(* It is useful to refer to points in our grid using this record. This allows us
     to avoid making mistakes about which coordinate is the row and which is the column

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

(* This is useful for the graphics portion of the library.  Feel free to ignore all
   these functions *)
module For_drawing : sig
  val fill_rect : Graphics.color -> t -> t -> unit
  val draw_rect : Graphics.color -> t -> t -> unit
  val origin : t
end
