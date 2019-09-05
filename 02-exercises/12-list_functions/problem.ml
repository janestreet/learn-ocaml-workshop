open! Base

(* Remember the list functions we wrote in exercises 8-10? Many of those
   functions that we've been writing by hand are actually available in the
   language in a nice, first class way in the [List] module. 

   Let's take look at some of the useful functions that are given to you. *)

(** ========== [List.fold] ========== **)
(* [List.fold] has the following signature:

   {| val fold : 'a list ‑> init:'b ‑> f:('b ‑> 'a ‑> 'b) ‑> 'b |}

   Maybe this looks familiar?  This is almost the same as the [every] function
   we wrote in exercise 11.

   Let's rewrite [simpler_sum] and [simpler_product] using List.fold *) 

let simpler_sum xs = failwith "For you to implement"
let simpler_product xs = failwith "For you to implement"

(** ========== [List.map] ========== **)
(* [List.map] has the following signature:

   {| val map : 'a list ‑> f:('a ‑> 'b) ‑> 'b list |}

   [map] allows us to transforms lists from one type to lists of another type by
   applying some function [f] to every element of the list.

   Let's write a function that takes in an int list and transforms it into a
   float list. (Hint: you can cast an int to a float using [Float.of_int].) *)
                       
let float_of_int xs = failwith "For you to implement"

(** ========== [List.init] ========== **)
(* [List.init] has the following signature:

   {| val init : int -> f:(int -> 'a) -> 'a t |}

   [init] allows you to construct new lists.  Given a number representing the
   number of elements to generate and a function to construct a new element, it
   returns a new list

   Let's rewrite the [range] function we wrote in problem 9 to use [init].  *)

let range from to_ = failwith "For you to implement"

(** ========== [List.range] ========== **)
(* Turns out this special case of [List.init] is useful enough that it has it's own 
   function:

   {|
       val range : 
           ?stride:int
           -> ?start:[ `exclusive | `inclusive ]
           -> ?stop:[ `exclusive | `inclusive ]
           -> int 
           -> int 
           -> int list
   |} 

   The arguments that are preceded with a question mark (i.e. [stride], [start], 
   and [stop]) are called "optional arguments", and are arguments that don't have to 
   be passed when invoking the function. We'll learn about optional arguments in more 
   detail in exercise 15.*)

(** ========== [List.iter] ========== **)
(* [List.iter] has the following signature:

   {| val iter : 'a list -> f:('a -> unit) -> unit |}

   Sometimes you want to do something side-effecting to all the elements of a
   list, such as printing them out. [iter] allows you to run a side-effecting
   function on every element of a list.

   Let's use [iter] to print a list of ints. Remember that we can use
   [Stdio.printf] to print formatted strings. *)

let print_int_list xs = failwith "For you to implement"

(* There are many more useful [List] functions, which you can read about here:
   https://ocaml.janestreet.com/ocaml-core/latest/doc/base/Base/List/index.html

   A couple that are worth noting:

   * [List.find]

   {| val find : 'a list -> f:('a -> bool) -> 'a option |}

   This allows you to find the first element in a list that satifies some
   condition [f].

   * [List.filter]

   {| val filter : 'a list -> f:('a -> bool) -> 'a list |}

   This allows you to remove all elements from a list that do not satisfy some
   condition [f].

   * [List.mapi]

   {| val mapi : 'a list -> f:(int -> 'a -> 'b) -> 'b list |}

   This is just like map, but it also gives [f] the index of the element in the
   list.

   * [List.zip]

   {| val zip : 'a list -> 'b list -> ('a * 'b) list option |}

   This allows you to combine two lists pairwise.  It will return [None] if the
   lists are not equal in length. (You will learn about options and what [None]
   means in exercise 15.) *)

let%test "Testing simpler_product..." = Int.( = ) 1 (simpler_product [])
let%test "Testing simpler_product..." = Int.( = ) 55 (simpler_product [ 55 ])
let%test "Testing simpler_product..." = Int.( = ) 25 (simpler_product [ 5; -5; 1; -1 ])
let%test "Testing simpler_product..." = Int.( = ) 25 (simpler_product [ 5; 5; 1; 1 ])
let%test "Testing simpler_sum..." = Int.( = ) 0 (simpler_sum [])
let%test "Testing simpler_sum..." = Int.( = ) 55 (simpler_sum [ 55 ])
let%test "Testing simpler_sum..." = Int.( = ) 0 (simpler_sum [ 5; -5; 1; -1 ])
let%test "Testing simpler_sum..." = Int.( = ) 12 (simpler_sum [ 5; 5; 1; 1 ])

let%test "Testing float_of_int..." = [%compare.equal: float list] (float_of_int [1; 2; 3]) [ 1.0; 2.0; 3.0 ]

let%test "Testing range..." = [%compare.equal: int list] (range 1 4) [ 1; 2; 3 ]

let%test "Testing range..." =
  [%compare.equal: int list] (range (-5) 3) [ -5; -4; -3; -2; -1; 0; 1; 2 ]
;;
