open! Base
(* The following function has the signature:

   val divide : int -> int -> int

   Looking at just the signature, it's not obvious which int argument is
   the dividend and which is the divisor.
*)
let divide dividend divisor  = dividend / divisor

(* We can fix this using labelled arguments.

   To label an argument in a signature, "NAME:" is put before the type.
   When defining the function, we put a tilde (~) before the name of the argument.

   The following function has the signature:

   val divide : dividend:int -> divisor:int -> int
*)
let divide ~dividend ~divisor = dividend / divisor

(* We can then call it using:

   divide ~dividend:9 ~divisor:3

   Labelled arguments can be passed in in any order (!)

   We can also pass variables into the labelled argument:

   let dividend = 9 in
   let divisor  = 3 in
   divide ~dividend:dividend ~divisor:divisor

   If the variable name happens to be the same as the labelled argument, we
   don't even have to write it twice:

   let dividend = 9 in
   let divisor  = 3 in
   divide ~dividend ~divisor
*)

(* Now implement [modulo ~dividend ~divisor] using our version of divide with labelled
   arguments (e.g. [modulo ~dividend:7 ~divisor:2] should equal 1) *)
(* TODO *)
let modulo ~dividend ~divisor = failwith "For you to implement"

let%test "Testing modulo..." =
  Int.(=) 2 (modulo ~dividend:17 ~divisor:5)

let%test "Testing modulo..." =
  Int.(=) 0 (modulo ~dividend:99 ~divisor:9)

