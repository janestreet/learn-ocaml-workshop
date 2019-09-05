open! Base

type t = { location : Position.t } [@@deriving sexp_of]

let location t = t.location

(* TODO: Implement [create]. *)
let create ~height ~width ~invalid_locations = failwith "For you to implement"

let%test_module _ =
  (module struct
    let%expect_test "Testing [create]..." =
      Random.init 0;
      let apple = create ~height:10 ~width:10 ~invalid_locations:[] in
      Stdio.printf !"%{sexp: t option}\n%!" apple;
      [%expect {| (((location ((col 2) (row 5))))) |}]
    ;;

    let%expect_test "Testing [create]..." =
      let invalid_locations =
        List.init 10 ~f:(fun row -> List.init 10 ~f:(fun col -> { Position.row; col }))
        |> List.concat
      in
      let apple = create ~height:10 ~width:10 ~invalid_locations in
      Stdio.printf !"%{sexp: t option}\n%!" apple;
      [%expect {| () |}]
    ;;
  end)
;;
