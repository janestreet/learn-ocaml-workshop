(* Welcome to Jane Street's OCaml challenges!

   This exercise is just meant to familiarize you with the build process and
   tools.

   Write OCaml code using your favorite text editor; if you aren't already
   committed to one, we recommend Visual Studio Code. *)

let () = Stdio.printf "Hello, World!

(** =========== Compilation ========== **)
(* To compile your code and run inline tests, run

   $ dune runtest

   in a terminal session in this exercise's directory.

   Try building this code.

   You should see a compilation error because the line of code above is missing
   the end quote. Add the end quote and re-run. You should see that the code
   compiled and ran!

   This process of building/running tests, fixing compilation errors, and
   repeating until all tests pass should roughly be your workflow as you work
   through these exercises. Make sure to only build inside each exercise's
   directory, so you don't have to sift through irrelevant output from other
   exercises' tests. *)

(** =========== utop ========== **)
(* OCaml has a toplevel interpreter (i.e. a REPL, or read-eval-print loop)
   called utop. Try starting up utop in the command line like so:

   $ utop

   You can also execute code in this environment directly. Try pasting the
   previous line of code into utop and running it there.

   Note that in utop, every line must end with a double semi-colon (;;). Your
   session should look like this: 

   {|
       utop # Stdio.printf "Hello, world";; 
       Hello, world- : unit = ()
   |}

   If you see "Error: Unbound module Stdio", your utop environment might be 
   missing the stdio package. Try running the following:

   {| 
       utop # #require "stdio";;
   |}

   and retrying. 

   While going through these exercises, it may be helpful to play around in utop! *)

