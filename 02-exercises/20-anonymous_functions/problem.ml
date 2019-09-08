open! Base

(* Recall: In OCaml, functions are values, so we can pass them in as arguments
   to other functions (higher order functions).

   As we've seen before, in order to represent a function in a signature, we
   wrap its type in parenthesis, with arrows separating arguments.

   Remember [add1] from exercise 4?

   {| val add1 : int -> int |}

   When we used its signature in a type, we had to write [(int -> int)]. *)

(* Now, let's define a function called [map_option]. [map_option] takes a
   function and an option.

   If the option has a value of [None], [map_option] returns [None].

   If the option has a value of [Some x], the function is called on x, and
   wrapped up in a [Some].

   It may seem unintuitive, but this kind of function is very useful because it
   allows you to continue applying functions to data without having to
   explicitly deal with [None] values or worry about null pointer exceptions if
   the data isn't there!

   Make sure to inspect and understand the signature for [map_option].  *)
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

(* In the previous example, we defined [double] separately before using it with
   [map_option]. Instead of defining the [double] beforehand, we can use an
   anonymous function.

   To write an anonymous function, we use the [fun] keyword in the following
   form:

   {| (fun ARG1 ARG2 ... -> BODY) |}

   The following has the same effect as above: *)
let () =
  assert
    ([%compare.equal: int option]
       (map_option (fun i -> 2 * i) (Some 2))
       (Some 4))

(* Define a function, [apply_if_nonzero], which takes a function from an integer
   to an integer and applies the function to the supplied argument if it is not
   zero, and otherwise just returns 0. *)
let apply_if_nonzero f i =
  failwith "For you to implement"

(* Now, using [apply_if_nonzero] with an anonymous function, write
   [add1_if_nonzero], which takes an integer and adds 1 to it if it is not zero,
   and otherwise just returns 0. *)
let add1_if_nonzero i = 
  failwith "For you to implement"

let%test "Testing add1_if_nonzero..." =
  Int.(=) 0 (add1_if_nonzero 0)

let%test "Testing add1_if_nonzero..." =
  Int.(=) 2 (add1_if_nonzero 1)

let%test "Testing add1_if_nonzero..." =
  Int.(=) 6 (add1_if_nonzero 5)
