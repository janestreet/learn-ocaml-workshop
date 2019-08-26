open! Base

(* Write a function that adds 1 to an int. (This exercise may seem familiar!) *)
let add1 x = failwith "For you to implement" 

(* Now write a function that squares its argument. *)
let square x = failwith "For you to implement"

(* Functions are "first class" in OCaml. This means that you can take a function
   and pass it around as an argument to other functions. We call functions that
   take other functions as arguments "higher order functions".

   Let's write a function named [twice], which will take a function as its first
   argument, and apply that function two times to its second argument.

   Hint: it may be necessary to use parenthesis to specify which function is
   applied to which value. *)
let twice f x = failwith "For you to implement" 

(* Now that we have [twice], try writing [add2] and [raise_to_the_fourth] using
   [add1] and [square]. *)
let add2 = failwith "For you to implement"
let raise_to_the_fourth = failwith "For you to implement"

let%test "Testing add1..." =
  Int.(=) 5 (add1 4)

let%test "Testing square..." =
  Int.(=) 16 (square 4)

let%test "Testing square..." =
  Int.(=) 16 (square (-4))

let%test "Testing add1..." =
  Int.(=) 5 (twice add1 3)

let%test "Testing add2..." =
  Int.(=) 1337 (add2 1335)

let%test "Testing raise_to_the_fourth..." =
  Int.(=) 1 (raise_to_the_fourth 1)

let%test "Testing raise_to_the_fourth..." =
  Int.(=) 10000 (raise_to_the_fourth 10)
