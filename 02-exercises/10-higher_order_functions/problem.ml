open! Base

let plus x y = x + y
let times x y = x * y

(* Sometimes, multiple functions look similar. For example, consider
   [add_every_number_up_to] and [factorial]. *)
let rec add_every_number_up_to x =
  match x with
  | 0 -> 0
  | _ -> plus x (add_every_number_up_to (x - 1))
;;

let rec factorial x =
  match x with
  | 0 -> 1
  | _ -> times x (factorial (x - 1))
;;

(* These functions have a lot in common:

   {| 
       let rec NAME x =
       match x with
       | 0 -> ANSWER
       | _ -> COMBINE x (NAME (x-1))
   |}
*)

(* OCaml lets us write the common parts just once. We just have to add some
   extra arguments. *)
let rec up_to answer combine x =
  match x with
  | 0 -> answer
  | _ -> combine x (up_to answer combine (x - 1))
;;

(* Now we can write our original functions in one line each!

   Check out the signature for [up_to] in the mli. Do all the arguments make
   sense?

   Note that the [combine] argument of [up_to] is a function. (Remember higher
   order functions?) *)
let simpler_add_every_number_up_to x = up_to 0 plus x
let simpler_factorial x = up_to 1 times x

(* Infix operators like [( + )] and [( * )] can actually be passed as functions
   too, without writing [plus] and [times] like we did above. Another way to
   write the above two functions would be:

   [let simpler_add_every_number_up_to x = up_to 0 ( + ) x]
   [let simpler_factorial x = up_to 1 ( * ) x] *)

(* Now let's try refactoring another example. 

   Remember [sum] and [product]? *)
let rec sum xs =
  match xs with
  | [] -> 0
  | x :: ys -> plus x (sum ys)
;;

let rec product xs =
  match xs with
  | [] -> 1
  | x :: ys -> times x (product ys)
;;

(* These functions look pretty similar too! 

   Try factoring out the common parts like we did above. *)
let rec every answer combine xs = failwith "For you to implement"

(* Can you write a signature in the mli for [every]? How does it compare with [up_to]? 

   Now, rewrite sum and product in just one line each using [every]. *)
let simpler_sum xs = failwith "For you to implement"
let simpler_product xs = failwith "For you to implement"

let%test "Testing simpler_product..." = Int.( = ) 1 (simpler_product [])
let%test "Testing simpler_product..." = Int.( = ) 55 (simpler_product [ 55 ])
let%test "Testing simpler_product..." = Int.( = ) 25 (simpler_product [ 5; -5; 1; -1 ])
let%test "Testing simpler_product..." = Int.( = ) 25 (simpler_product [ 5; 5; 1; 1 ])
let%test "Testing simpler_sum..." = Int.( = ) 0 (simpler_sum [])
let%test "Testing simpler_sum..." = Int.( = ) 55 (simpler_sum [ 55 ])
let%test "Testing simpler_sum..." = Int.( = ) 0 (simpler_sum [ 5; -5; 1; -1 ])
let%test "Testing simpler_sum..." = Int.( = ) 12 (simpler_sum [ 5; 5; 1; 1 ])
