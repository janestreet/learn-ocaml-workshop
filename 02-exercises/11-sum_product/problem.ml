open! Base
let plus x y = x + y
let times x y = x * y

(* Sometimes, multiple functions look similar: *)
let rec add_every_number_up_to x =
  match x with
  | 0 -> 0
  | _ -> plus x (add_every_number_up_to (x-1))

let rec factorial x =
  match x with
  | 0 -> 1
  | _ -> times x (factorial (x-1))

(*
   These functions have a lot in common:

   let rec NAME x =
     match x with
     | 0 -> ANSWER
     | _ -> COMBINE x (NAME (x-1))
*)

(*
   OCaml lets us write the common parts just once.
   We just add an extra input for every part that changes (other than the name):
*)
let rec up_to answer combine x =
  match x with
  | 0 -> answer
  | _ -> combine x (up_to answer combine (x-1))

(* Now we can write our original functions in one line each! *)
let simpler_add_every_number_up_to x = up_to 0 plus x
let simpler_factorial x = up_to 1 times x

(* Note that with infix operators like + and *, you can actually pass them as functions!
   You can do this by writing ( + ) and ( * ). So another way to write the above two
   functions would be:

     let simpler_add_every_number_up_to x = up_to 0 ( + ) x
     let simpler_factorial x = up_to 1 ( * ) x
*)

(* Remember sum and product? *)
let rec sum xs =
  match xs with
  | [] -> 0
  | x :: ys -> plus x (sum ys)

let rec product xs =
  match xs with
  | [] -> 1
  | x :: ys -> times x (product ys)

(*
   These functions look pretty similar too:

   let rec NAME xs =
     match xs with
     | [] -> ANSWER
     | x :: ys -> COMBINE x (NAME ys)
*)

(* Let's write the common parts just once: *)
let rec every answer combine xs =
  failwith "For you to implement"

(* Now let's rewrite sum and product in just one line each using every *)
let simpler_sum xs     = failwith "For you to implement"
let simpler_product xs = failwith "For you to implement"

let%test "Testing simpler_product..." =
  Int.(=) 1 (simpler_product [])

let%test "Testing simpler_product..." =
  Int.(=) 55 (simpler_product [55])

let%test "Testing simpler_product..." =
  Int.(=) 25 (simpler_product [5; (-5) ; 1 ; (-1)])

let%test "Testing simpler_product..." =
  Int.(=) 25 (simpler_product [5 ; 5 ; 1 ; 1])

let%test "Testing simpler_sum..." =
  Int.(=) 0 (simpler_sum [])

let%test "Testing simpler_sum..." =
  Int.(=) 55 (simpler_sum [55])

let%test "Testing simpler_sum..." =
  Int.(=) 0 (simpler_sum [5 ; (-5) ; 1 ; (-1)])

let%test "Testing simpler_sum..." =
  Int.(=) 12 (simpler_sum [5 ; 5 ; 1 ; 1])
