open! Base
(* The following function has the signature:

   {| val divide : int -> int -> int |} 

   Looking at just the signature, it's not obvious which [int] argument is the
   dividend and which is the divisor.  *)
let divide dividend divisor  = dividend / divisor

(* We can fix this ambiguity using labeled arguments.

   To label an argument in a signature, we put "NAME:" before the type. Then,
   when defining the function, we put a tilde (~) before the name of the
   argument.

   The following function has the signature:

   {| val divide : dividend:int -> divisor:int -> int |} *)
let divide ~dividend ~divisor = dividend / divisor

(* We can then call it using:

   {| divide ~dividend:9 ~divisor:3 |} *)
let () = 
  assert ([%compare.equal: int] (divide ~dividend:9 ~divisor:3) 3);
  assert ([%compare.equal: int] (divide ~divisor:3 ~dividend:12) 4)

(* As you see above, labeled arguments can be passed in in any order!

   We can also pass variables into the labeled argument:

   {| 
       let nine = 9 in
       let three = 3 in
       divide ~dividend:nine ~divisor:three
   |}

   If the variable name happens to be the same as the labeled argument, we
   don't even have to write it twice:

   {|
       let dividend = 9 in
       let divisor  = 3 in
       divide ~dividend ~divisor
   |}
*)

(* Now, implement [modulo] using our version of divide with labeled
   arguments. Remember that you can look at the mli for the function
   signature. *)
let modulo ~dividend ~divisor = dividend % divisor

let%test "Testing modulo..." =
  Int.(=) 2 (modulo ~dividend:17 ~divisor:5)

let%test "Testing modulo..." =
  Int.(=) 0 (modulo ~dividend:99 ~divisor:9)

