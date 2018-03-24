open! Base
(* We use let to define functions.

   Definitions take on the form:
   let FUNCTION_NAME ARG1 ARG2 ... = BODY

   In OCaml, outside of strings, whitespace and newlines are the same.

   So, you could also write
   let  FUNCTION_NAME
     ARG1
     ARG2
   =
     BODY

   and it's the same to the compiler.

   For example, here we define a function add1 that takes a single int
   argument and returns that argument plus 1.
*)
let add1 arg =
  arg + 1

(* This function uses the built-in ^ operator to append strings. *)
let string_append x y = x ^ y

(* Let's define our own functions using +, -, *, and / below. *)

let plus x y   = failwith "For you to implement"

let times x y  = failwith "For you to implement"

let minus x y  = failwith "For you to implement"

let divide x y = failwith "For you to implement"

let%test "Testing plus..." =
  Int.(=) 2 (plus 1 1)

let%test "Testing plus..." = 
  Int.(=) 49 (plus (-1) 50)

let%test "Testing times..." = 
  Int.(=) 64 (times 8 8)

let%test "Testing times..." = 
  Int.(=) (-2048) (times (-2) 1024)

let%test "Testing minus..." = 
  Int.(=) (-4) (minus (-2) 2)

let%test "Testing minus..." = 
  Int.(=) 1000 (minus 1337 337)

let%test "Testing divide..." = 
  Int.(=) 512 (divide 1024 2)

let%test "Testing divide..." = 
  Int.(=) 1010 (divide 31337 31)

