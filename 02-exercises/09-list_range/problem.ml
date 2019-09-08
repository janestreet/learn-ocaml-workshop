open! Base

(* The append infix operator, [( @ )], which concatenates two lists:

   {| val (@) : 'a list -> 'a list -> 'a list |} *)
let () =
  assert ([%compare.equal: int list] ([ 5; 1 ] @ [ 8; 4 ]) [ 5; 1; 8; 4 ]);
  assert ([%compare.equal: int list] (List.append [ 5; 1 ] [ 8; 4 ]) [ 5; 1; 8; 4 ])
;;

(* Write a function to construct a list of all integers in the range from [from] to [to_]

   including [from] but excluding [to_] in increasing order.

   {| val range : int -> int -> int list |} *)
let range from to_ = failwith "For you to implement"

(* You might've noticed that the list type in the function definitions of the
   operator [( @ )] (and also [( :: )]) look a bit different from every other
   type we've used thusfar. This is because a list is a "parameterized data
   type". You can't just have a list; you have to have a list of somethings
   (like a list of integers).

   The ['a list] in the signature means that this functions can be used on lists
   containing any type of data, as long as the contained data is the same in the
   two argument lists (you can't concatenate a list of integers with a list of
   strings).

   Here, the ['a] is called a "type parameter", and [list_append] is described as
   a "polymorphic function". We'll revisit parametrized types in later
   exercises. *)

let%test "Testing range..." = [%compare.equal: int list] (range 1 4) [ 1; 2; 3 ]

let%test "Testing range..." =
  [%compare.equal: int list] (range (-5) 3) [ -5; -4; -3; -2; -1; 0; 1; 2 ]
;;

(* By the way, [%compare.equal: t] is some syntatic magic that the OCaml ppx
   processor turns into the standard equality function for comparing two values
   of type [t].

   For example, [%compare.equal: float] is replaced at compile-time with the
   equality function for floats, whilte [%compare.equal: int list] is the
   equality function for lists of integers.

   One situation where this is really useful is instantiations of containers
   (like the [int list] example above). Instead of writing an equality function
   by hand, or defining a module specialized to that type just to use its
   equality operator, you can ask the [ppx_compare] syntax extension to create
   it for you on the fly.  *)
