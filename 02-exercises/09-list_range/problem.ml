open! Base

(* Recall the append infix operator, [( @ )], which concatenates two lists:

   {| val (@) : 'a list -> 'a list -> 'a list |}

   This function is the same as the [List.append] function.  *)
let () =
  assert ([%compare.equal: int list] ([ 5; 1 ] @ [ 8; 4 ]) [ 5; 1; 8; 4 ]);
  assert ([%compare.equal: int list] (List.append [ 5; 1 ] [ 8; 4 ]) [ 5; 1; 8; 4 ])
;;

(* Write a function to construct a list of all integers in the range from [from] to [to_]

   including [from] but excluding [to_] in increasing order.

   {| val range : int -> int -> int list |}
*)
let range from to_ = failwith "For you to implement"

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
let%test "Testing range..." = [%compare.equal: int list] (range 1 4) [ 1; 2; 3 ]

let%test "Testing range..." =
  [%compare.equal: int list] (range (-5) 3) [ -5; -4; -3; -2; -1; 0; 1; 2 ]
;;
