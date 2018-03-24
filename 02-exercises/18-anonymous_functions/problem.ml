open! Base

(* In OCaml, functions are values, so we can pass them in as
   arguments to other functions.

   To represent a function in a signature, you wrap its type in parenthesis,
   with arrows separating arguments.

   Recall: a function called add1 which takes an integer and returns an integer has the type
   val add1 : int -> int

   so, to use that signature in a type, we'd write
   (int -> int)

   We now define a function called map_option.
   map_option takes a function and an option.

   If the option has a value of None, map_option returns None
   If the option has a value of Some x, the function is called on x,
   and wrapped up in a Some.

   This may seem unintuitive, but this kind of function is very useful.
   It means that you can continue working on data, and ignore if
   the data isn't there (no null pointer exceptions!)

   The signature for the function is

   val map_option : ('a -> 'b) -> 'a option -> 'b option
*)
let map_option f opt =
  match opt with
  | None -> None
  | Some i -> Some (f i)

let double i = 2 * i

let () =
  assert
    ([%compare.equal: int option]
       (map_option double None)
       None)

let () =
  assert
    ([%compare.equal: int option]
       (map_option double (Some 2))
       (Some 4))

(* Instead of defining the function double beforehand, we can use
   an anonymous function.

   To write an anonymous function, the "fun" keyword is used in the following form

   (fun ARG1 ARG2 ... -> BODY)

   The following has the same effect as above:
*)
let () =
  assert
    ([%compare.equal: int option]
       (map_option (fun i -> 2 * i) (Some 2))
       (Some 4))

(* Define a function apply_if_nonzero which takes a function from
   int to int and an int, and applies the function if the integer
   is not zero, and otherwise just returns 0.
*)
(* TODO *)
let apply_if_nonzero f i =
  failwith "For you to implement"

let%test "Testing apply_if_nonzero..." =
  Int.(=) 0 (apply_if_nonzero (fun x -> 10 / x) 0)

let%test "Testing apply_if_nonzero..." =
  Int.(=) 2 (apply_if_nonzero (fun x -> 10 / x) 5)
