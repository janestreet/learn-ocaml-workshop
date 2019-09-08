open! Base

(* OCaml allows us to define record types.

   Records are like structs in C, or data members of a class in
   python/ruby/java.  *)

(* Consider this example of the type [person], which contains four fields. *)
type person = 
  { age            : int
  ; first_name     : string
  ; last_name      : string
  ; number_of_cars : int
  } [@@deriving compare]

(* We can create a [person] by specifying each of the fields.

   When defining (or matching on) a record, the fields can be listed in any
   order.  *)
let an_example : person =
  { first_name = "Cotton-eyed"
  ; last_name = "Joe"
  ; age = 22
  ; number_of_cars = 0
  }

(* We can use the "." operator to get the value of a field out of a record:
   VARIABLE.FIELD *)
let age : int = an_example.age
let () = assert (age = 22)

(* We can also match on records to get values for multiple fields at once.

   Note that we can assign the value of a field to a different variable name
   (like we do here with [age]). *)
let print_info {first_name; last_name; age = number_of_years_alive; number_of_cars} =
  Stdio.print_endline first_name;
  Stdio.print_endline last_name;
  Stdio.printf "Age: %d, # of cars: %d\n" number_of_years_alive number_of_cars
;;

(* If we don't care about an argument we can ignore it by assigning it to [_]. *)
let print_name ({first_name; last_name; age = _; number_of_cars = _}) =
  Stdio.print_endline first_name;
  Stdio.print_endline last_name

(* Finally, we can perform "functional updates" by replacing the value of a
   field, yielding a brand new record. We use the [with] keyword to do this.

   Verify the type of [add_one_to_age] in the mli.  *)
let add_one_to_age person =
  { person with age = person.age + 1 }

let () = assert (23 = (add_one_to_age an_example).age)

(* Write a function that does different things for different people:

   - When the person's first name is "Jan", you should return a record with the
     age set to 30.

   - Otherwise, you should increase the number of cars by 6.  *)
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
