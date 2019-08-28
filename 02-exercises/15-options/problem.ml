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
   the data exists, and that data is [x], which is of type ['a]. Note that
   [option] is a parameterized data type, with ['a] as the type parameter. 

   Here's an example. *)
let what_number_am_i_thinking (my_number : int option) =
  match my_number with
  | None        -> "I'm not thinking of any number!"
  | Some number -> "My number is: " ^ (Int.to_string number)

let%test _ =
  String.(=) (what_number_am_i_thinking None) "I'm not thinking of any number!"

let%test _ =
  String.(=) (what_number_am_i_thinking (Some 7)) "My number is: 7"

(* Implement the function [safe_divide ~dividend ~divisor], which takes two
   [int]s and returns an [int option]. It should return [None] if [divisor = 0],
   and otherwise return [Some x] where [x] is the division result *)
let safe_divide ~dividend ~divisor = failwith "For you to implement"

let%test "Testing safe_divide..." =
  match (safe_divide ~dividend:3 ~divisor:2) with
  | Some 1 -> true
  | _      -> false

let%test "Testing safe_divide..." =
  match safe_divide ~dividend:3 ~divisor:0 with
  | None -> true
  | _    -> false

(* Implement a function [option_concatenate], which takes two [string option]s and
   returns a [string option] that is:
   - [Some x], where x is the concatenation of the two strings, if they both exist
   - [None] if either of the strings is [None]  *)
let option_concatenate string1 string2 = failwith "For you to implement" 

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

(* In addition to labeled arguments, OCaml supports optional arguments when
   defining functions. To denote that an argument is optional in a function
   signature, we put "?NAME:" before the type. Then, when defining the function,
   we can pass in the argument using a tilde (~), just like labeled arguments,
   or omit it entirely. We can also pass optional arguments in any order, just
   like labeled arguments.

   Within a function that has an optional argument, we can treat the optional
   argument as a value of an [option] type.

   Consider [concatenate], which concatenates two strings with an optional
   separator argument. Make sure to take a look at its signature. *)
let concatenate ?separator string1 string2 = 
  match separator with 
  | Some x -> string1 ^ x ^ string2
  | None -> string1 ^ string2

(* We can also supply a default with an optional argument when defining a
   function. For example, in [concatenate_with_default_separator], we give the
   optional argument [separator] a default value of [""]. This way, we don't
   have to explicitly handle the case where the optional argument is omitted by
   ourselves. *)
let concatenate_with_default_separator ?(separator = "") string1 string2 = 
  string1 ^ separator ^ string2

(* Do these assertions make sense? *)
let () = 
  let string1 = "hello" in
  let string2 = "world" in
  assert (
    [%compare.equal: string] 
      "helloworld"
      (concatenate string1 string2));
  assert (
    [%compare.equal: string] 
      "helloworld"
      (concatenate_with_default_separator string1 string2));
  assert (
    [%compare.equal: string] 
      "hello, world" 
      (concatenate ~separator:", " string1 string2));
  assert (
    [%compare.equal: string] 
      "hello, world" 
      (concatenate_with_default_separator ~separator:", " string1 string2))

(* An aside on optional argument "erasure":

   Consider [labeled_concatenate], which behaves exactly like
   [concatenate_with_default_separator], except that the string arguments to be
   concatenated are lableled. *)
let labeled_concatenate ?(separator = "")  ~string1 ~string2 =
  string1 ^ separator ^ string2

(* Try uncommenting this code. What is the compile error? *)
(* let () = 
 *   assert (String.(=) "hi" (labeled_concatenate ~string1:"h" ~string2:"i")) *)

(* This is because optional arguments can only be safely omitted if there's an
   unlabeled, non-optional argument after the optional argument in the function
   definition. In [concatenate_with_default_separator], [string1] and [string2]
   were both unlabeled, non-optional arguments. However, [labeled_concatenate]
   doesn't have any arguments that can be used to indicate that we are purposely
   not passing [separator].

   To fix this problem, we can specify [?separator:None] in the invocation of
   [labeled_concatenate] above. Try this and verify that the code compiles and
   runs successfully. *)

(*  We could also define our [labeled_concatenate] function with an additional
   [unit] argument at the end to allow us to erase the optional argument.

   Take a second to make sure this makes sense. Try writing a function signature
   for [better_labeled_concatenate] in the mli, and make sure that this code
   still compiles. *)
let better_labeled_concatenate ?(separator = "") ~string1 ~string2 () = 
  string1 ^ separator ^ string2

let () = 
  assert (String.(=) "hi" (better_labeled_concatenate ~string1:"h" ~string2:"i" ()))
