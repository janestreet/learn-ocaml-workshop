open! Base

(* In OCaml there are 6 basic types: int, float, char, string, bool, and unit.

   The following exercises and examples will give you a brief introduction to
   these types. Feel free to play around with them in utop.

   Note the keyword [let], which is how variable assignment is done in OCaml.

   In OCaml floats are distinguished from ints by their decimal points. 0 is an
   int, 0. is a float.

   In addition the basic math operations are also distinguished by a decimal
   point. For example, + allows you to add two ints and +. allows you to add two
   floats. *)

(* Signatures
   ==========

   four is a value with the type int. We write the signature like this:

   val four : int

   Read it like this: "[four] is a value of type int".

   Signatures are similar to type declarations in other languages. They tell the
   compiler (and human readers of your code!) the types of variables and
   functions in your program. For example, in C, C++, and Java, the signature
   above would be written like so:

   int four;
*)
let four = 4

(* float_four is a value with the type float. We write the signature like this:

   val float_four : float

   You may have noticed that the two signatures we showed you were in comments.
   Signatures are not always required! In many situations, you may omit them,
   and the compiler will infer the type of values.

   However, if you do write a signature for a value, the compiler will make sure
   to check that it's consistent with how that value is used.

   Try inserting an incorrect signature for [float_four] to see what error the
   compiler gives you. *)
let float_four = 4.

(* Function signatures
   ===================

   In OCaml, functions are also values!

   In a signature, the arrow [->] denotes an argument. The last type in a
   function signature is the result.

   So the signature for a function that takes two integers and returns an
   integer is:

   val int_average : int -> int -> int

   In Ocaml there's no explicit return statement: functions just return the
   value of the last statement in that function. *)
let int_average x y = failwith "For you to implement"

(* val float_average : float -> float -> float *)
let float_average x y = failwith "For you to implement"

(* There will be more about functions later, but note that in OCaml, there are
   no parentheses when applying a function! So the following expression computes
   the average of 10 and 20:

   int_average 10 20
*)

(* As in many languages strings are denoted with "" and chars are denoted with ''.

   String concatenation is done with the ^ operator.
*)

(* val first_name : string *)
let first_name = "Fred"

(* You can also write type annotations in definitions *)
let last_name : string = "Flintstone"

let full_name = first_name ^ " " ^ last_name

let a_boolean_false : bool = false

(* You can use
   && for logical and
   || for logical or
*)
let () = assert (true || a_boolean_false)

(* The [unit] type
   ===============

   unit is a special type in OCaml that has only one possible value written ().
   It is generally used for mutation and io-operations such as printing.

   (I/O stands for input/output. Examples: printing to screen, reading a file,
   sending and receiving network requests.)

   To combine several unit operations together the ; operator is used.

   When evaluating a unit operation on the toplevel, you should wrap it in a let
   binding, as in

   let () = ...

   This isn't actually necessary in all cases, but it will save you from some
   frustrating debugging of compiler issues if you just always include it.

   For this reason, idiomatic OCaml code has [let () = ...] as its entrypoint,
   similar to the [main] function in languages like C, C++ and Java (however,
   in those languages it is required).
*)
let () =
  Stdio.print_endline "Hi, My name is ";
  Stdio.print_endline full_name;
  Stdio.print_endline " and I am 5 years old"

(* Like many other programming languages, you can use format strings too *)
let () =
  Stdio.printf "Hi, My name is %s and I am %d years old\n" full_name 5

(* The lines that follow are inline tests. Each evaluates a boolean expression.
   They are run during the build, and failures -- evaluating to false -- are
   treated like compile errors by the build tool and editors.

   We will see other kinds of inline tests later, and some interesting patterns
   for using them. *)

(* While OCaml supports polymorphic comparison, it is good practice to use
   equality and comparison functions specific to each type.

   So, [Int.equal] is the [equal] function defined in the [Int] module. Its
   signature is

   val equal : int -> int -> bool

   In words: [equal] takes two [int]s and returns a [bool]. The following line
   is applying that function to two inputs, [5] and [int_average 5 5]. *)

let%test "Testing int_average..." =
  Int.equal (int_average 5 5) 5

(* Modules can also contain operators. By convention, the equality operator is
   defined and equivalent to the [equal] function. To reference an operator in a
   module, we need to surround it with parentheses. Try removing the parentheses
   to see what error you get.

   Int.(=) is the same as Int.equal
*)

let%test "Testing int_average..." =
  Int.(=) (int_average 50 100) 75

let%test "Testing float_average..." =
  Float.(=) (float_average 5. 5.) 5.

let%test "Testing float_average..." =
  Float.equal (float_average 5. 10.) 7.5

(* .mli files
   ==========

   Check out the [problem.mli] file in this directory! It declares the types for
   the two functions you had to implement. If the types in the [.mli] don't
   match the types of the values in the [.ml], the compiler will flag that as an
   error.
*)
