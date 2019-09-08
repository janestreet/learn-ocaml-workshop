open! Base

(* Another non-basic type in OCaml is a tuple. A tuple is an ordered collection
   of values that can each be of a different type. The signature for a tuple is
   written by separating all the types within the tuple by a [*].  *)
type string_and_int = string * int
type int_and_string_and_char = int * string * char

(* Tuples are created by joining values with a comma. *)
let example : int_and_string_and_char = 5, "hello", 'A'

(* You can also extract the components of a tuple. *)
let i, s, c = example

let () =
  assert (i = 5);
  assert (String.( = ) s "hello");
  assert (Char.( = ) c 'A')
;;

(* Consider a coordinate type containing the x and y values of a coordinate.
   Write a function that computes the sum of two coordinates. *)
type coordinate = int * int

let add coord1 coord2 = failwith "For you to implement"

(* Now consider a [name] type containing two [string]s representing the first and
   the last name. *)
type name = string * string

(* Or an [initials] type containing two [char]s representing the first and the
   last initial. *)
type initials = char * char

(* Say we want to write a function that extracts the first element from a
   coordinate, name, or initials. We currently can't write that because they all
   have different types.

   Let's define a new [pair] type which is parameterized over the type contained
   in the pair. *)
type 'a pair = 'a * 'a

(* Our types defined above could be rewritten as

   {|
       type coordinate = int    pair
       type name       = string pair
       type initials   = char   pair
   |}
*)

(* We can construct pairs just like we construct regular tuples *)
let int_pair : int pair = 5, 7
let string_pair : string pair = "foo", "bar"
let nested_char_pair : char pair pair = ('a', 'b'), ('c', 'd')

(* Write functions to extract the first and second elements from a pair. Their
   signatures can be found in the mli. *)
let first pair = failwith "For you to implement"
let second pair = failwith "For you to implement"

(* Notice the cool [%compare.equal: int * int] here!  *)
let%test "Testing add..." = [%compare.equal: int * int] (4, 7) (add (5, 3) (-1, 4))
let%test "Testing first..." = String.( = ) "foo" (first ("foo", "bar"))
let%test "Testing second..." = Char.( = ) 'b' (second ('a', 'b'))
