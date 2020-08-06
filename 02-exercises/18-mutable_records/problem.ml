open! Base

(* Sometimes rather than redefining the record you would like to have a field or
   a set of fields that you can modify on the fly.

   In OCaml, we can use the [mutable] keyword to indicate that a particular
   field in a record can be modified in place. Then we can use [<-] to set the
   record value to a new value. *)
type color =
  | Red
  | Yellow
  | Green

(* An aside: Note that for the [stoplight] type definition is followed by
   [@@deriving compare]. This is a ppx (remember the [%compare.equal] ppx from
   exercise 9?) that gives us functions for comparing values of the [stoplight]
   type without having to define them by hand.

   Before changing anything in this exercise, you'll get an error about "Unbound
   value compare_color". This is because we tried to use the [compare] ppx for
   [stoplight] below, which has a [color] as one of its fields, but the compiler
   does not know how to compare two [color]s.

   We can fix this compile error by either manually writing a compare function
   for the [color] type, or (much more easily) by adding the [compare] ppx to
   the [color] type as well. *)
type stoplight =
  { location : string (* stoplights don't usually move *)
  ; mutable color : color  (* but they often change color *)
  }
[@@deriving compare]

(* On creation, mutable fields are defined just like normal fields. *)
let an_example : stoplight =
  { location = "The corner of Vesey Street and the West Side highway"; color = Red }
;;

(* Now rather than using a functional update we can use a mutable update. This
   doesn't return a new stoplight, it modifies the input stoplight.

   Inspect the type of [set_color]. *)
let set_color stoplight color = stoplight.color <- color

(* For this exercise, assume that stoplights always transition from [Green] to
   [Yellow], [Yellow] to [Red], and [Red] to [Green]. Since we know this is the
   only transition, we can just write a function to advance the color of the
   light without taking an input color. *)
let advance_color stoplight = failwith "For you to implement"

module For_testing = struct
  let test_ex_red : stoplight = { location = ""; color = Red }
  let test_ex_red' : stoplight = { test_ex_red with color = Green }
  let test_ex_yellow : stoplight = { location = ""; color = Yellow }
  let test_ex_yellow' : stoplight = { test_ex_red with color = Red }
  let test_ex_green : stoplight = { location = ""; color = Green }
  let test_ex_green' : stoplight = { test_ex_red with color = Yellow }

  let%test "Testing advance_color..." =
    advance_color test_ex_green;
    [%compare.equal: stoplight] test_ex_green' test_ex_green
  ;;

  let%test "Testing advance_color..." =
    advance_color test_ex_yellow;
    [%compare.equal: stoplight] test_ex_yellow' test_ex_yellow
  ;;

  let%test "Testing advance_color..." =
    advance_color test_ex_red;
    [%compare.equal: stoplight] test_ex_red' test_ex_red
  ;;
end
