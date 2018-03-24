open! Base

(* Here are some example functions: *)
let square x = x * x
let half x = x / 2
let add x y = x + y

(* You can order function invocations with parentheses or let bindings *)
(* Parens *)
let () =
  Stdio.printf "(5^2)/2 = %i" (half (square 5))

(* Let bindings *)
let () =
  let squared = square 5 in
  let halved = half squared in
  Stdio.printf "(5^2)/2 = %i" halved

(* Try to write [average] by reusing [add] and [half] *)
let average x y = failwith "For you to implement"

let%test "Testing average..."  =
  Int.(=) 5 (average 5 5)

let%test "Testing average..." =
  Int.(=) 75 (average 50 100)
