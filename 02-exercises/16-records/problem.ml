open! Base

(* OCaml allows you to define record types.
   These are like structs in C.
   Or in python/ruby/java - data members of a class.
*)

type person = (* The name of the type is [person] *)
  (* it contains four fields *)
  (* The first field, called "age" is of type int.  *)
  { age            : int
  ; first_name     : string
  ; last_name      : string
  ; number_of_cars : int
  } [@@deriving compare]

(* We can create a [person] like this.
   When defining and matching on a record, the fields
   can be listed in any order.
*)
let an_example : person =
  { first_name = "Cotton-eyed"
  ; last_name = "Joe"
  ; age = 22
  ; number_of_cars = 0
  }

(* In order to get a field out of a record we use the "." operator:
   VARIABLE.FIELD
*)
let age : int = an_example.age
let () = assert (age = 22)

(* We can also match on records to get field information. *)
let print_info {first_name; last_name; age; number_of_cars} =
  Stdio.print_endline first_name;
  Stdio.print_endline last_name;
  Stdio.printf "Age: %d, # of cars: %d\n" age number_of_cars
;;

(* If we don't care about an argument we can ignore it using "= _" *)
let print_name ({first_name; last_name; age = _; number_of_cars = _}) =
  Stdio.print_endline first_name;
  Stdio.print_endline last_name

(* Finally, we can perform "functional updates" by replacing the value of a field,
   yielding a brand new record. We use the "with" keyword to do this. *)

(* val add_one_to_age : person -> person *)
let add_one_to_age person =
  { person with age = person.age + 1 }

let () = assert (23 = (add_one_to_age an_example).age)

(* Write a function that does different things for different people:
   When the person's first name is "Jan",
   you should return a record with the age set to 30.

   Otherwise, you should increase the number of cars by 6.
*)

(* val modify_person : person -> person *)

let modify_person (person : person) =
  failwith "For you to implement"

module For_testing = struct
  let test_ex1 : person = {
    first_name = "Jan";
    last_name = "Saffer";
    age = 55;
    number_of_cars = 0;
  };;

  let test_ex1' : person = {test_ex1 with age = 30};;

  let test_ex2 : person = {
    first_name = "Hugo";
    last_name = "Heuzard";
    age = 4;
    number_of_cars = 55;
  };;

  let test_ex2' : person = { test_ex2 with number_of_cars = 61};;

  let%test "Testing modify_person..." =
    [%compare.equal: person] test_ex1' (modify_person test_ex1)
  ;;

  let%test "Testing modify_person..." =
    [%compare.equal: person] test_ex2' (modify_person test_ex2)
  ;;
end
