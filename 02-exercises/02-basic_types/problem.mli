open! Base

(* This is an mli, a file that declares the interface that the corresponding
   implementation file (problem.ml) exposes to other code.

   The compiler will enforce that the implementations you write for
   [int_average] and [float_average] in problem.ml have the type signatures
   written below.
*)

val int_average   : int   -> int   -> int
val float_average : float -> float -> float

(* dune automatically checks that every variable defined in an ml file
   is used. You can see these warnings by running [dune
   runtest]. These warnings are useful to make sure we didn't forget
   to expose something in the mli that we meant to. Uncomment the
   following signatures to resolve dune's unused variable warnings. *)
(* val four : int
 * val float_four : float *)
