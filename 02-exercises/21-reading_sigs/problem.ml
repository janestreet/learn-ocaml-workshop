open! Base

(* OCaml, like many other languages, provides a way to interact with code via
   interfaces. This allows implementation details to be hidden away, and for
   grouped units of code to restrict how they are used.

   Thusfar, we've only dealt with interfaces in the context of mli files. mli
   files define what is exposed to code outside of the ml file; anything that is
   not exposed in the mli cannot be accessed outside of the ml file.

   We can also define modules and signatures within a single ml file. Just like
   when we define a signature in an mli file, signatures defined in ml files
   determine what functions are exposed to the rest of the code.

   Here's an example of a module signature coupled with an implementation. The
   signature is wrapped in a [sig] / [end] pair. The implementation is wrapped
   in a [struct] / [end] pair. *)
module Example : sig
  (* Here, just as in mli files, [val] indicates that we are exposing a
     value. This value is an integer *)
  val the_meaning_of_life_the_universe_and_everything : int

  (* To declare functions, again we use [val] (remember, in OCaml, functions are
     values). This value takes an integer as a parameter and returns an integer.
  *)
  val subtract_one : int -> int
end = struct
  let the_meaning_of_life_the_universe_and_everything = 42
  let subtract_one x = x - 1

  (* [a_secret_value] is not exposed in the mli, so it will not be accessible
     outside the code. *)
  let a_secret_value = 17
end

(* Here's how we use these values. *)
let one_less_than_the_meaning_of_life_etc =
  Example.subtract_one Example.the_meaning_of_life_the_universe_and_everything
;;

let () =
  assert (one_less_than_the_meaning_of_life_etc = 41)

(* Try uncommenting this line of code. What does the compiler tell you? *)
(* let () = 
 *   assert (Example.a_secret_value = 17)  *)
    
(* Types can be exposed via signatures in OCaml as well. Here's an example of
   declaring an "abstract" type - one where the definition of the type is not
   exposed. *)
module Abstract_type_example : sig
  (* We do not let the user know the underlying representation of [t]. *)
  type t

  (* This function allows [t] to be coerced into an integer. *)
  val to_int : t -> int

  (* Users need some way to start with some [t]. *)
  val zero : t
  val one : t

  (* Let them do something with the [t]. *)
  val add : t -> t -> t
end = struct
  type t = int

  let to_int x = x
  let zero = 0
  let one = 1
  let add = ( + )
end

(* Here's an example of adding 2 and 2 *)
let two = Abstract_type_example.add Abstract_type_example.one Abstract_type_example.one
let four = Abstract_type_example.to_int (Abstract_type_example.add two two);;

assert (four = 4)

module Fraction : sig
  type t
  (* Now, add signatures for the create and value functions to expose them in
     the [Fraction] module. Note that you shouldn't need to change any of the
     underlying implementation, nor change anything about how [t] is exposed. *)
end = struct
  type t = int * int

  let create ~numerator ~denominator = numerator, denominator
  let value (numerator, denominator) = Float.of_int numerator /. Float.of_int denominator
end

let%test "Testing Fraction.value..." =
  Float.( = ) 2.5 (Fraction.value (Fraction.create ~numerator:5 ~denominator:2))
;;

let%test "Testing Fraction.value..." =
  Float.( = ) 0.4 (Fraction.value (Fraction.create ~numerator:4 ~denominator:10))
;;
