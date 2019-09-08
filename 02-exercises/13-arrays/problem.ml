open! Base

(* Arrays are mutable data structures with a fixed size. Like lists, arrays can
   only contain elements of the same type. Unlike lists, arrays have fast access
   and modification, so they are often used in the more imperative style of
   OCaml. *)

(* We can create an array of a given length, initialized with a given value,
   using [create]:

   {| val create : len:int -> 'a -> 'a array |}

   We can also use the array literal "[||]":

   {| let array = [| 1; 2; 3 |] |}

   We can query for the length of an array with [length]:

   {| val length : 'a array -> int |}

   We can access a value at a given index in an array using [get]:

   {| val get : 'a array -> int -> 'a |}

   We can write a value to a given index in an array using [set]:

   {| val set : 'a array -> int -> 'a -> unit |} *)
let () = 
  let array = Array.create ~len:5 "hello" in
  assert (String.(=) "hello" (Array.get array 1));
  Array.set array 2 "hello world";
  assert (String.(=) "hello world" (Array.get array 2))

(* OCaml also provides some nice syntatic sugar for accessing values and setting
   the value at [INDEX] in an array [ARRAY]: 

   {| ARRAY.(INDEX) |} 

   The following code behaves exactly as the previous block of code. *)
let () = 
  let array = Array.create ~len:5 "hello" in
  assert (String.(=) "hello" array.(1));
  array.(2) <- "hello world";
  assert (String.(=) "hello world" array.(2))

(* We can apply a function [f] to each element of an array using [iter]:

   {| val iter : 'a array -> f:('a -> unit) -> unit |}

   [iteri] works almost the same way, it also gives [f] the index of the element
   in the array (like [List.mapi] from exercise 12).

   {| val iteri : 'a array -> f:(int -> 'a -> unit) -> unit |}

   Let's implement a function [double] using [Array.iteri], which takes an [int
   array] and doubles each element of the array in place. *)
let double array : unit = failwith "For you to implement"

let%test "Testing double..." = 
  let array = [| 1; 1; 1 |] in
  double array;
  [%compare.equal: int array]
    [| 2; 2; 2 |] 
    array

let%test "Testing double..." = 
  let array = [| 1; 2; 3; 4; 5 |] in
  double array;
  [%compare.equal: int array] 
    [| 2; 4; 6; 8; 10 |] 
    array

(* Write a function that takes an [int array] and a list of indicies and
   doubles each of the elements at the specified indices. *)
let double_selectively array indices : unit = failwith "For you to implement"

let%test "Testing double_selectively..." = 
  let array = [| 1; 1; 1 |] in
  (double_selectively array [ 1 ]);
  [%compare.equal: int array] 
    [| 1; 2; 1 |]
    array

let%test "Testing double_selectively..." = 
  let array = [| 1; 2; 3; 4; 5 |] in
  double_selectively array [ 0; 2; 4];
  [%compare.equal: int array] 
    [| 2; 2; 6; 4; 10 |] 
    array

(* Two-dimensional arrays are common enough in code that OCaml provides special
   functions just for constructing them!

   {| val make_matrix : dimx:int -> dimy:int -> 'a -> 'a array array |}

   We can access and set values in a two-dimensional array just as we do a
   one-dimensional array. *)
let () = 
  let matrix = Array.make_matrix ~dimx:5 ~dimy:3 "hello" in
  assert (String.(=) "hello" matrix.(1).(2));
  matrix.(4).(1) <- "hello world";
  assert (String.(=) "hello world" matrix.(4).(1))

(* Write a function that takes an [int array array] and doubles each of the
   elements at the specified indices. *)
let double_matrix matrix : unit = failwith "For you to implement"

let%test "Testing double_matrix..." = 
  let matrix = [| [| 1; 2; 3 |]; [| 1; 1; 1 |] |] in
  (double_matrix matrix);
  [%compare.equal: int array array] 
    [| [| 2; 4; 6 |]; [| 2; 2; 2 |] |] 
    matrix
