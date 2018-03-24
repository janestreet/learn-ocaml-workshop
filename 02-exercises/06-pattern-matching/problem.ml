open! Base
(* Pattern matching lets us compare inputs to known values.
   Patterns following "|" are tested in order.
   On the first match, we use the result following "->".
   The "_" pattern means "could be anything".
*)
let is_superman x =
  match x with
  | "Clark Kent" -> true
  | _ -> false

(* Let's use our own pattern matching. Write a function that returns
   whether x is non zero by matching on x *)
let non_zero x =
  failwith "For you to implement"

let%test "Testing non_zero..." =
  Bool.(=) false (non_zero 0)

let%test "Testing non_zero..." =
  Bool.(=) true (non_zero 500)

let%test "Testing non_zero..." =
  Bool.(=) true (non_zero (-400))
