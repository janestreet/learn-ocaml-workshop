open! Base
(* Another non-basic type in OCaml is a tuple. A tuple is an ordered collection
   of values that can each be of a different type. The signature for a tuple is
   written by separating all the types within the tuple by a *.
*)
type int_and_string_and_char = int * string * char

(* Tuples are created by joining values with a comma: *)
let example : int_and_string_and_char = (5, "hello", 'A')

(* You can also extract the components of a tuple: *)
let (i,s,c) = example

let () =
  assert (i = 5);
  assert (s = "hello");
  assert (c = 'A')

(* Consider a coordinate type containing the x and y values of a coordinate.
   Write a function that computes the sum of two coordinates.
*)
type coordinate = int * int

(* TODO *)
let add coord1 coord2 =
  failwith "For you to implement"

(* Now consider a name type containing strings representing first and last name. *)
type name = string * string

(* Or an initials type containing chars representing first and last initials *)
type initials = char * char

(* Say we want to write a function that extracts the first element from a coordinate,
   name, or initials. We currently can't write that because they all have different
   types.

   Lets define a new pair type which is parameterized over the type contained in
   the pair. We write this as
*)
type 'a pair = 'a * 'a

(* Our types defined above could be rewritten as

   type coordinate = int    pair
   type name       = string pair
   type initials   = char   pair
*)

(* We can construct pairs just like we construct regular tuples *)
let int_pair : int pair = (5, 7)
let string_pair : string pair = ("foo", "bar")
let nested_char_pair : (char pair) pair = (('a','b'),('c','d'))

(* Write functions to extract the first and second elements from a pair. *)
(* val first : 'a pair -> 'a *)
(* TODO *)
let first pair = failwith "For you to implement"

(* val second : 'a pair -> 'a *)
(* TODO *)
let second pair = failwith "For you to implement"

(* Notice the cool [%compare.equal: int*int] here! *)
let%test "Testing add..." =
  [%compare.equal: int*int] (4,7) (add (5,3) (-1,4))

let%test "Testing first..." =
  String.(=) "foo" (first ("foo","bar"))

let%test "Testing second..." =
  Char.(=) 'b' (second ('a','b'))
