open! Base

(* It is sometimes useful to create a single mutable value. We can do this using
   a [ref]. We can create an [int ref] containing 0 as follows. *)
let x = ref 0

(* Then we can access the value in the ref using the [!] operator, and we can
   update it using the [:=] operator. So, we could increment our ref as
   follows. *)
let () =
  x := !x + 1

(* Write a function min_and_max which returns a tuple containing the minimum and
   maximum values in a non-empty list of positive integers. Your function should
   raise if the list is empty.

   You could do this using [List.fold], but for the purpose of this exercise,
   let's iterate over the list and explicitly maintain refs of the minimum and
   maximum values seen so far instead. *)
let min_and_max lst =
  let min_val = ref Int.max_value in
  let max_val = ref Int.min_value in
  let rec loop current_lst = 
    match current_lst with
    | [] -> !min_val, !max_val
    | h :: tl -> 
      if h < !min_val then min_val := h else if h > !max_val then max_val := h;
      loop tl
    in
  match lst with
  | [] -> failwith "it is not supporting empty list"
  | _  -> loop lst

(* By the way, can you guess how a [ref] is implemented under the hood? 

   (Hint: exercise 18.) *)

let%test "Testing min_and_max..." =
  [%compare.equal: int * int] (min_and_max [5;9;2;4;3]) (2,9) 
;;

let%test "Testing min_and_max..." =
  [%compare.equal: int*int] (min_and_max [11;15;7;34]) (7,34)
;;
