open! Base

type card_value

val card_value_to_string : card_value -> string
val card_value_to_score : card_value -> int

type color = 
  | Red
  | Green
  | Blue

val to_string : color -> string
