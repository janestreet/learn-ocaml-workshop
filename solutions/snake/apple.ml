open! Base

type t = { location : Position.t } [@@deriving sexp_of]

let location t = t.location

(* TODO: Implement [create].

   Make sure to inspect the mli to understand the signature of [create]. [create] will
   take in the height and width of the board area, as well as a list of locations where
   the apple cannot be generated, and create a [t] with a random location on the board. *)
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

(* See the "Expect Tests" in the README for more details on these tests. *)
let%test_module _ =
  (module struct
    let%expect_test "Testing [create]..." =
      let apple = create ~height:10 ~width:10 ~invalid_locations:[] in
      match apple with
      | None -> failwith "[create] returned [None] when [Some _] was expected!"
      | Some apple ->
        let { Position.row; col } = apple.location in
        if row < 0 || row >= 10 || col < 0 || col >= 10
        then failwith "[create] returned an invalid apple!"
        else ()
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
