open! Base

(* As in most languages, you can define your own types.
   The keyword "type" introduces a type definition.

   One of the non-basic types in OCaml is called the variant type.
   Variant types are similar to Enums in other languages. They are
   types which may take on multiple forms, where each form is marked
   by an explicit tag. A variant type is defined as follows:
*)
type color =
  | Red
  | Green
  | Blue

(* Variants are very useful in combination with pattern matching *)
let to_string color =
  match color with
  | Red   -> "red"
  | Green -> "green"
  | Blue  -> "blue"

(* Ocaml variants are in many ways more powerful than Enums because the different
   constructors of your variant can include data in them. Here's an example:
*)
type card_value =
  | Ace
  | King
  | Queen
  | Jack
  | Number of int

let one_card_value : card_value = Queen
let another_card_value : card_value = Number 8

let card_value_to_string card_value =
  match card_value with
  | Ace      -> "Ace"
  | King     -> "King"
  | Queen    -> "Queen"
  | Jack     -> "Jack"
  | Number i -> Int.to_string i

(* Write a function that computes the score of a card (aces should score 11
   and face cards should score 10). *)
let card_value_to_score card_value =
  failwith "For you to implement"

let%test "Testing card_value_to_score..." =
  Int.(=) 11 (card_value_to_score Ace)

let%test "Testing card_value_to_score..." =
  Int.(=) 10 (card_value_to_score King)

let%test "Testing card_value_to_score..." =
  Int.(=) 10 (card_value_to_score Queen)

let%test "Testing card_value_to_score..." =
  Int.(=) 10 (card_value_to_score Jack)

let%test "Testing card_value_to_score..." =
  Int.(=) 5 (card_value_to_score (Number 5))

