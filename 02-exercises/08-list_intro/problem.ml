open! Base

(*
   OCaml natively supports linked lists as part of the language.
   Lists are commonly referred to as having heads and tails.
   The head is the first element of the linked list
   The tail is everything else.

   [] means "the empty list".
   hd :: tl means "the element hd added to the front of the list tl".

   When matching on a list, it's either empty or non-empty. To say it another way, it's
   either equal to [] or equal to (hd :: tl) where hd is the first element of the list
   and tl] is all the rest of the elements of the list (which may itself be empty).
*)

(* This function computes the length of a list. *)
let rec length lst =
  match lst with
  | [] -> 0
  | _ :: tl -> 1 + (length tl)

(* Write a function to add up the elements of a list by matching on it. *)
let rec sum lst =
  failwith "For you to implement"

(* The signature for the append operator is
   val (@) : 'a list -> 'a list -> 'a list

   It's an infix operator. You can use it one of two ways:
*)
let list_append       first second = first @ second
let other_list_append first second = (@) first second

(* The way you put something on the head to the list
   uses the same kind of syntax for matching on lists.
   val (::) : 'a -> 'a list -> 'a list
*)
let new_head hd rest = hd :: rest

let%test "Testing sum..." =
  Int.(=) 0 (sum [])

let%test "Testing sum..." =
  Int.(=) 55 (sum [55])

let%test "Testing sum..." =
  Int.(=) 0 (sum [5 ; (-5) ; 1 ; (-1)])

let%test "Testing sum..." =
  Int.(=) 12 (sum [5 ; 5 ; 1 ; 1])
