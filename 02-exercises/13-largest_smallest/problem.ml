open! Base
(* Here is [every] from the "Sum Product" problem *)
let rec every answer combine xs =
  match xs with
  | [] -> answer
  | x::xs -> combine x (every answer combine xs)

(* Here are two functions which compute the largest and smallest integers in a list of
   integers: *)

let rec largest xs =
  match xs with
  | []      -> Float.neg_infinity
  | x :: ys -> Float.max x (largest ys)

let rec smallest xs =
  match xs with
  | [] -> Float.infinity
  | x :: ys -> min x (smallest ys)

(* Let's rewrite them using every: *)
let simpler_largest  xs = every (failwith "For you to implement") xs
let simpler_smallest xs = every (failwith "For you to implement") xs

let%test "Testing simpler_smallest..." =
  Float.(=) Float.infinity (simpler_smallest [])

let%test "Testing simpler_smallest..." =
  Float.(=) 55. (simpler_smallest [55.])

let%test "Testing simpler_smallest..." =
  Float.(=) (-5.) (simpler_smallest [5. ;(-5.) ; 1. ;(-1.)])

let%test "Testing simpler_smallest..." =
  Float.(=) 1. (simpler_smallest [5. ; 5. ; 1. ; 1.])

let%test "Testing simpler_largest..." =
  Float.(=) Float.neg_infinity (simpler_largest [])

let%test "Testing simpler_largest..." =
  Float.(=) 55. (simpler_largest [55.])

let%test "Testing simpler_largest..." =
  Float.(=) (5.) (simpler_largest [5. ; (-5.) ; 1. ; (-1.)])

let%test "Testing simpler_largest..." =
  Float.(=) 5. (simpler_largest [5. ; 5. ; 1. ; 1.])
