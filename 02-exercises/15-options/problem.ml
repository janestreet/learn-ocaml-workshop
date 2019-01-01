open! Base

(* Many languages have a concept of "Null", which describes that some data is
   absent. In OCaml, we can model the presence/absence data using ordinary
   variants.

   Note: we're defining the [option] type here to show you that it isn't magic.
   In real life you would always use the [option] type provided by the standard
   library. [Base] comes with a convenient [Option] module with many useful
   functions. *)
type 'a option =
  | None
  | Some of 'a

(* An ['a option] is either [None], meaning absence of data, or [Some x] meaning
   the data exists, and that data specifically is [x]. Here's an example: *)

let what_number_am_i_thinking (my_number : int option) =
  match my_number with
  | None        -> "I'm not thinking of any number!"
  | Some number -> "My number is: " ^ (Int.to_string number)

let%test _ =
  String.(=) (what_number_am_i_thinking None) "I'm not thinking of any number!"

let%test _ =
  String.(=) (what_number_am_i_thinking (Some 7)) "My number is: 7"

(* Implement the function [safe_divide ~dividend ~divisor], which takes two ints
   and returns an int option. It should return None if [divisor = 0], and
   otherwise returns [Some x] where [x] is the division result *)
let safe_divide ~dividend ~divisor =
  failwith "For you to implement"

let%test "Testing safe_divide..." =
  match (safe_divide ~dividend:3 ~divisor:2) with
  | Some 1 -> true
  | _      -> false

let%test "Testing safe_divide..." =
  match safe_divide ~dividend:3 ~divisor:0 with
  | None -> true
  | _    -> false

(* Implement a function [concatenate string1 string2], which takes two
   [string option]s and returns a [string option] that is [Some x]
   where x is the concatenation of the two strings, if they exist, and
   [None] if either of the strings is [None]. *)
let option_concatenate string1 string2 = 
  failwith "For you to implement"

let%test "Testing option_concatenate..." =
  match option_concatenate (Some "hello") (Some "world") with
  | Some "helloworld" -> true
  | _ -> false

let%test "Testing option_concatenate..." =
  match option_concatenate None (Some "world") with
  | None -> true
  | _ -> false

let%test "Testing option_concatenate..." =
  match option_concatenate (Some "hello") None with
  | None -> true
  | _ -> false
