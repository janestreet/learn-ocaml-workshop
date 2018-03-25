open! Base
(* It is common in all programming languages to want to store and operate on
   collections of the same data type. As you have seen in previous exercises, we
   can achieve this in OCaml using the ['a list] type (e.g. int list, bool list,
   string list list).

   When you first learn to program in languages like C and Java, you use "for"
   loops to operate on all the elements of an array, e.g.:

     for (int i = 0; i < array.length(); i++) { do_something_with(array[i]); }

   In OCaml, we use "higher order functions", in other words, functions which
   take other functions as input. Let's take a look at the [List.map] function,
   which has signature:

     val map : ('a -> 'b) -> 'a list -> 'b list

   Let's read this signature together. It takes two function arguments:

      1) a function from some type ['a] to some other type ['b] 2) a list of
   ['a]s

   and then it returns a list of ['b]s. What [map f la] does is take your
   function [f], apply it to each element of [la], and returns a new list [lb]
   where the the [i]th element of [lb] is equal to the function [f] applied to
   the [i] thelement of [la].

   Let's see some examples: *)

let my_ints : int list =
  [ 1; 2; 3; 4; 5 ]

let double_my_ints ints : int list =
  List.map ~f:(fun x -> x * 2) ints

let () =
  assert
    ([%compare.equal: int list]
       (double_my_ints my_ints)
       [ 2; 4; 6; 8; 10 ])

let my_strings ints : string list =
  List.map ~f:Int.to_string ints

let () =
  assert
    ([%compare.equal: string list]
       (my_strings my_ints)
       [ "1"; "2"; "3"; "4"; "5" ])

(* Exercise: implement the value [my_new_ints], which is obtained by adding 1 to each
   element of [my_ints] *)
let my_new_ints ints =
  failwith "For you to implement"

(* If the function you want to perform on each element of your list is one that returns
   [unit], meaning that all it does is perform some side-effect (like [printf]),
   there is a higher-order function called [List.iter] which has the following signature:

     val iter
       :  ('a -> unit)
       -> 'a list
       -> unit
*)
let () = List.iter ~f:(fun i -> Stdio.printf "here's an int: %i\n" i) my_ints

(* Another thing you might want to do with a list is combine all the elements together in
   some way. Here is the signature of [List.fold_left]:

     val fold_left
      :  ('b -> 'a -> 'b)
      -> 'b
      -> 'a list
      -> 'b

   Let's say your list [l] contains [a1; a2; a3]. Then if you call [fold_left f i l], then
   it will end up computing:

       (f (f (f i a1) a2) a3)

   Here's an example of using [fold_left] to compute a sum:
*)

let sum_of_my_ints ints : int =
  List.fold_left
    ~f:(fun total my_int -> total + my_int)
    ~init:0
    ints

let () = assert (sum_of_my_ints my_ints = 15)

(* Exercise: use [List.fold_left] to compute the number of elements of [my_ints] that are
   even *)

let num_even_ints ints =
  failwith "For you to implement"

(* Here's one more example of a useful list function: [List.find]:

     val find
       :  ('a -> bool)
       -> 'a list
       -> 'a
*)

let first_num_greater_than_3 ints =
  List.find_exn ~f:(fun x -> x > 3) ints

let () = assert (first_num_greater_than_3 my_ints = 4)

let%test "Testing my_new_ints..." =
  [%compare.equal: int list] [2;3;4;5;6] (my_new_ints my_ints)
;;

let%test "Testing num_even_ints..." =
  Int.equal 2 (num_even_ints my_ints)
;;
