open! Base

(* Remember that functions can call functions?
   They can call themselves too. But only with a special keyword.

   First try to compile this. We see "Unbound value add_every_number_up_to".

   Now change "let" to "let rec" and recompile.
*)

let add_every_number_up_to x =
  (* make sure we don't call this on negative numbers! *)
  assert (x >= 0);
  match x with
  | 0 -> 0
  | _ -> x + (add_every_number_up_to (x-1))

(* Let's write a function to multiply every number up to x. Remember: [factorial 0] is 1 *)
let rec factorial x =
  assert (x >= 0);
  failwith "For you to implement"

let%test "Testing factorial..." =
  Int.(=) 1 (factorial 0)

let%test "Testing factorial..." =
  Int.(=) 120 (factorial 5)

let%test "Testing factorial..." =
  Int.(=) (479001600) (factorial 12)

