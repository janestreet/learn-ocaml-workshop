open! Base

(* Pattern matching lets us compare inputs to known values. 

   In general, pattern matching looks like this:

   {| 
       match SOMETHING with 
       | PATTERN1 -> WHAT TO DO IF PATTERN1 MATCHES
       | PATTERN2 -> WHAT TO DO IF PATTERN2 MATCHES
       ...
   |}

   Patterns are tested (i.e. checked for whether they match) in order starting
   from the top. 

   On the first pattern that matches, we go into the code block following [->].

   Note that the [_] pattern matches anything. (Can you think of why this might
   be dangerous?) *)
let is_superman x =
  match x with
  | "Clark Kent" -> true
  | _ -> false
;;

(* We can also pattern match on multiple values at the same time. Notice how we
   can group different patterns together to avoid repeating code following
   [->]. *)
let is_same_person x y = 
  match x, y with 
  | "Clark Kent", "Superman" 
  | "Peter Parker", "Spiderman" -> true
  | _ -> false
;;

(* Let's write our own pattern matching. Write a function that returns whether [x]
   is non-zero by matching on [x]. *)
let non_zero x = failwith "For you to implement"

let%test "Testing non_zero..." = Bool.( = ) false (non_zero 0)
let%test "Testing non_zero..." = Bool.( = ) true (non_zero 500)
let%test "Testing non_zero..." = Bool.( = ) true (non_zero (-400))

(* Now, write a function that returns true if [x] and [y] are both non-zero by
   matching on both of them at the same time. *)
let both_non_zero x y = failwith "For you to implement"

let%test "Testing both_non_zero..." = Bool.( = ) false (both_non_zero 0 0)
let%test "Testing both_non_zero..." = Bool.( = ) false (both_non_zero 0 1)
let%test "Testing both_non_zero..." = Bool.( = ) false (both_non_zero (-20) 0)
let%test "Testing both_non_zero..." = Bool.( = ) true (both_non_zero 400 (-5))
