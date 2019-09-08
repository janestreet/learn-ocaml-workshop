open! Base

(* Functions can call other functions. They can call themselves too, but only
   with a special keyword.

   First, try to compile this directory. What is the error that you see?

   Now change [let] to [let rec] and recompile.

   A function is only allowed to call itself if the [rec] flag is specified. *)
let add_every_number_up_to x =
  (* Make sure we don't call this on negative numbers! *)
  assert (x >= 0);
  match x with
  | 0 -> 0
  | _ -> x + add_every_number_up_to (x - 1)
;;

(* Now, let's write a function to take the product of every number up to [x]. *)
let rec factorial x =
  assert (x >= 0);
  failwith "For you to implement"
;;

let%test "Testing factorial..." = Int.( = ) 1 (factorial 0)
let%test "Testing factorial..." = Int.( = ) 120 (factorial 5)
let%test "Testing factorial..." = Int.( = ) 479001600 (factorial 12)
