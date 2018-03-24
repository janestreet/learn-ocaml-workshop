open Base
open Js_of_ocaml
(* ## - method will get called as soon I deref.
   `##.prop_name := ` to set a property
   ##.prop_name to read (no deref)

   put a table here ; bg here ; each cell has an id
*)

let get_foo_div () =
  Option.value_exn (
    (Js.Opt.to_option (Dom_html.document##getElementById (Js.string "foo"))))
;;

let () =
  Dom_html.window##.onload := (Dom.handler (fun _ ->
      let foo_div = get_foo_div () in
      foo_div##.textContent := Js.Opt.return (Js.string "Hello, world!");
      Js._true
    ));
  Dom_html.window##.onkeydown := (Dom.handler (fun key_event ->
      let foo_div = get_foo_div () in
      let key = Option.value_exn (Js.Optdef.to_option (key_event##.key)) in
      let () = 
        match Js.to_string key with
        | "ArrowUp"
        | "ArrowDown"
        | "ArrowLeft"
        | "ArrowRight" -> foo_div##.textContent := Js.Opt.return key
        | _            -> ()
      in
      Js._true));
  let ticktock = ref "tick" in
  let _ =
    Dom_html.window##setInterval (Js.wrap_callback (fun () ->
        let foo_div = get_foo_div () in
        foo_div##.textContent := Js.Opt.return (Js.string !ticktock);
        ticktock := (
        match !ticktock with
        | "tick" -> "tock"
        | "tock" -> "tick"
        | _      -> "error"
      )
      ))
      1000.0
  in
  ()
;;
