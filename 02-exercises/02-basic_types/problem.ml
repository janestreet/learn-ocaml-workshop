open! Base
(** ========= Introduction ========= **)
(* In OCaml there are 6 basic types: [int], [float], [char], [string], [bool],
   and [unit].

   The following exercises and examples will give you a brief introduction to
   these types. Feel free to play around with them in utop as well.

   Note the keyword [let], which is how we do variable assignment in OCaml. *)

(** ========= Type Signatures ========= **)
(* [four] is a value with the type int. We write the signature like this:

   {| val four : int |}

   Read it like this: "[four] is a value of type int".

   Signatures are similar to type declarations in other languages. They tell the
   compiler (and human readers of your code!) the types of variables and
   functions in your program. For example, in C, C++, and Java, the signature
   above would be written like so:

   // C, C++, or Java type signature
   int four; 
*)
let four = 4

(* [float_four] is a value with the type float. We write the signature like
   this:

   {| val float_four : float |}

   You may have noticed that the two signatures we showed you were in comments.
   Signatures are not always required! In many situations, you may omit them,
   and the compiler will infer the type of values.

   However, if you do write a signature for a value, the compiler will make sure
   to check that it's consistent with how that value is used. Signatures are
   kept in interface files (named with a .mli extension). Check out problem.mli
   in this directory before continuing. In general, reading signatures in mli
   files will be helpful to understanding what a function is supposed to do.

   Now, try inserting an incorrect signature for [float_four] in the mli to see
   what error the compiler gives you. *)
let float_four = 4.

(* In OCaml, floats are distinguished from ints by the presence of a decimal
   point. [0] is an int, [0.] is a float.

   In addition, the basic math operations for floats are also distinguished by a
   decimal point. For example, [( + )] allows you to add two ints and [( +. )]
   allows you to add two floats. *)

(** ========== Function Signatures ========== **)
(* In OCaml, functions are also values! This means that we can write type
   signatures for functions and use [let] for function definitions, just like we
   did above.

   In a function signature, the arrow [->] denotes an argument. The last type in
   a function signature is the result.

   So the signature for a function that takes two integers and returns an
   integer is:

   {| val int_average : int -> int -> int |}

   You can verify that this is the same as the signature defined in the mli.

   In OCaml there's no explicit return statement: functions just return the
   value of the last statement in that function.

   Try implementing [int_average].  *)
let int_average x y = failwith "For you to implement"

(* Now try implementing [float_average]. Remember that you can check the mli for
   the type of this function. *)
let float_average x y = failwith "For you to implement"

(* Note that in OCaml, parenthese are not necessary when applying a function! So
   the following expression computes the average of 10 and 20:

   {| int_average 10 20 |} *)

(** ========== Strings ========== **)
(* As in many languages strings are denoted with double quotes ("") and chars
   are denoted with single quotes (''). *)

(* Check the mli for the signature of [first_name]. *)
let first_name = "Fred"

(* You can also write type annotations in definitions using a colon like so. *)
let last_name : string = "Flintstone"

(* String concatenation is done with the [( ^ )] operator.  *)
let full_name = first_name ^ " " ^ last_name

(** ========== Booleans ========== **)                
let a_boolean_false : bool = false

(* You can use
   [( && )] for logical and
   [( || )] for logical or

   What does the following do? *)
let () = assert (true || a_boolean_false)

(** ========== The [unit] Type  ========== **)
(* [unit] is a special type in OCaml that has only one possible value, written
   ().  It is generally used for mutation and I/O-operations.

   (I/O stands for input/output. Examples: printing to screen, reading a file,
   sending and receiving network requests.) *)

let () = Stdio.print_endline "Hi, my name is Fred Flintstone and I am 5 years old"

(* To combine several unit operations together, the [;] operator is used. *)
let () =
  Stdio.print_endline "Hi, my name is ";
  Stdio.print_endline full_name;
  Stdio.print_endline " and I am 5 years old"

(* When evaluating a unit operation on the toplevel, you should wrap it in a
   [let] binding, as in

   {| let () = ... |}

   This isn't actually necessary in all cases, but it will save you from some
   frustrating debugging of compiler issues if you just always include it.

   For this reason, idiomatic OCaml code has [let () = ...] as its entrypoint,
   similar to the [main] function in languages like C, C++ and Java (although in
   those languages it is required).  *)

(* An aside on printing: Like many other programming languages, you can use
   formatted strings for printing! We also use the '\n' character for printing
   newlines. *)
let () =
  Stdio.printf "Hi, my name is %s and I am %d years old\n" full_name 5

(** ========== Inline Tests ========== *)
(* The lines that follow are inline tests. Each evaluates a boolean expression.
   They are run during the build, and failures -- evaluating to false -- are
   treated like compile errors by the build tool and editors.

   We will see other kinds of inline tests later, and some interesting patterns
   for using them. *)

(* An aside on modules and comparison: While OCaml supports polymorphic
   comparison (i.e. comparison of values of arbitrary types), it is good
   practice to use equality and comparison functions specific to each type.

   Types, and functions that operate on those types, are gathered into
   namespaces that we call "modules". We can access functions inside modules
   using the syntax [Module.function].

   So, [Int.equal] is the [equal] function defined in the [Int] module. Its
   signature is

   {| val equal : int -> int -> bool |}

   In words: [equal] takes two [int]s and returns a [bool]. The following line
   is applying that function to two inputs, [5] and [int_average 5 5]. *)

let%test "Testing int_average..." =
  Int.equal (int_average 5 5) 5

(* Modules can also contain operators. By convention, the equality operator is
   defined and equivalent to the [equal] function. To reference an operator in a
   module, we need to surround it with parentheses.

   Try removing the parentheses around the "=" and compiling to see what error
   you get.

   [Int.(=)] is the same as [Int.equal]. *)

let%test "Testing int_average..." =
  Int.(=) (int_average 50 100) 75

let%test "Testing float_average..." =
  Float.(=) (float_average 5. 5.) 5.

let%test "Testing float_average..." =
  Float.equal (float_average 5. 10.) 7.5
