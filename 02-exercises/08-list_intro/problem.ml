open! Base

(* OCaml natively supports lists as a part of the language. Lists are
   implemented as linked lists, and can only contain values of the same
   type. 

   Lists are commonly referred to as having a head and a tail. The head is the
   first element of the linked list The tail is everything else.

   To construct a list we use the cons infix operator [( :: )] to prepend
   elements to the front of a list:

   {| val (::) : 'a -> 'a list -> 'a list |}

   [] means "the empty list". hd :: tl means "the element hd added to the front
   of the list tl".

   The following assertion shows that we can construct lists in two ways.  *)
let () = assert ([%compare.equal: int list] [ 5; 1; 8; 4 ]  (5 :: 1 :: 8 :: 4  :: []))

(* When matching on a list, it's either empty or non-empty. To say it another
   way, it's either equal to [] or equal to (hd :: tl) where hd is the first
   element of the list and tl is all the rest of the elements of the list (which
   may itself be empty).

   For example, this function computes the length of a list. *)
let rec length lst =
  match lst with
  | [] -> 0
  | _ :: tl -> 1 + length tl
;;

(* Write a function to add up the elements of a list by matching on it. *)
let rec sum lst = failwith "For you to implement"

let%test "Testing sum..." = Int.( = ) 0 (sum [])
let%test "Testing sum..." = Int.( = ) 55 (sum [ 55 ])
let%test "Testing sum..." = Int.( = ) 0 (sum [ 5; -5; 1; -1 ])
let%test "Testing sum..." = Int.( = ) 12 (sum [ 5; 5; 1; 1 ])

(* Now write a function to multiply together the elements of a list. *)
let rec product xs = failwith "For you to implement" 

let%test "Testing product..." = Int.equal 1 (product [])
let%test "Testing product..." = Int.equal 55 (product [ 55 ])
let%test "Testing product..." = Int.equal 25 (product [ 5; -5; 1; -1 ])
let%test "Testing product..." = Int.equal 25 (product [ 5; 5; 1; 1 ])
