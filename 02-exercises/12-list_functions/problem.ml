open! Base

(* Many of the list functions we've been writing by hand are actually available
   in the language in a nice first class way.  

   Let's take look at some of the useful functions that are given to you.
*)

(* List.fold

   val fold : 'a list ‑> init:'b ‑> f:('b ‑> 'a ‑> 'b) ‑> 'b

   Maybe this looks familiar?  This is the same as the every
   function we wrote in the last problem.  

   Let's rewrite simpler_sum and simpler_product using List.fold
*) 

let simpler_sum xs = failwith "For you to implement"
let simpler_product xs = failwith "For you to implement"

(* List.map

   val map : 'a list ‑> f:('a ‑> 'b) ‑> 'b list

   [map] allows us to transforms lists from one type to lists
   of another type by applying some function (f) to every element
   of the list.

   Let's write a function that takes in an int list and transforms
   it into a float list
*)

let float_of_int xs = failwith "For you to implement"

(* List.init

   val init : int -> f:(int -> 'a) -> 'a t

   [init] allows you to construct new lists.  Given a number
   representing the number of elements to generate and a function to
   construct a new element, it returns a new list

   Let's rewrite the range function we wrote in problem 9 to use [init]
*)

let range from to_ = failwith "For you to implement"

(* List.range

   Turns out this special case of [List.init] is useful enough that it has it's own 
   function:

   val range : 
       ?stride:int
       -> ?start:[ `exclusive | `inclusive ]
       -> ?stop:[ `exclusive | `inclusive ]
       -> int 
       -> int 
       -> int list *)

(* List.iter 

   val iter : 'a list -> f:('a -> unit) -> unit

   Sometimes you want to do something side-effecting to all the elements of a list,
   such as printing them out. [iter] allows you to run a side-effecting 
   function on every element of a list

   Lets use [iter] to print a list of ints
*)

let print_int_list xs = failwith "For you to implement"

(* There are many more useful List functions but a couple that are worth noting are

   * List.find 

   val find : 'a list -> f:('a -> bool) -> 'a option

   This allows you to find the first element in a list that satifies some condition f

   * List.filter

   val filter : 'a list -> f:('a -> bool) -> 'a list

   This allows you to remove all elements from a list that do not satisfy some condition f

   * List.mapi

   val mapi : 'a list -> f:(int -> 'a -> 'b) -> 'b list

   This is just like map, but it also tells you the index of the element in the list

   * List.zip 

   val zip : 'a list -> 'b list -> ('a * 'b) list option

   This allows you to combine two lists pairwise.  It will return None if the lists are not 
   equal in length
*)

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
