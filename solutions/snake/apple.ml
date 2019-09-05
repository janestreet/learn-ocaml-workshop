open! Base

type t = { location : Position.t } [@@deriving sexp_of]

let location t = t.location

(* TODO: Implement [create]. *)
let create ~height ~width ~invalid_locations =
  let possible_locations =
    List.concat_map (List.range 0 height) ~f:(fun row ->
        List.map (List.range 0 width) ~f:(fun col -> { Position.row; col }))
    |> List.filter ~f:(fun pos ->
           not (List.mem invalid_locations pos ~equal:[%compare.equal: Position.t]))
  in
  match possible_locations with
  | [] -> None
  | _ -> Some { location = List.random_element_exn possible_locations }
;;

let%test_module _ =
  (module struct
    let%expect_test "Testing [create]..." =
      Random.init 0;
      let apple = create ~height:10 ~width:10 ~invalid_locations:[] in
      Stdio.print_s ([%sexp_of: t option] apple);
      [%expect {| (((location ((col 2) (row 5))))) |}]
    ;;

    let%expect_test "Testing [create]..." =
      let invalid_locations =
        List.init 10 ~f:(fun row -> List.init 10 ~f:(fun col -> { Position.row; col }))
        |> List.concat
      in
      let apple = create ~height:10 ~width:10 ~invalid_locations in
      Stdio.print_s ([%sexp_of: t option] apple);
      [%expect {| () |}]
    ;;
  end)
;;
