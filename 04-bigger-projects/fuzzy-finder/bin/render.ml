open! Core
open! Async

let every ~how_often_to_render ~render f =
  let init = Deferred.unit in
  let next_render_time () = Clock.after how_often_to_render in
  Deferred.repeat_until_finished (init, f ()) (fun (next_render, f_call) ->
    match%bind
      Deferred.choose
        [ choice next_render (fun () -> `Render)
        ; choice f_call (fun x -> `F_call x)
        ]
    with
    | `Render ->
      let%map () = render () in
      `Repeat (next_render_time (), f_call)
    | `F_call (`Finished _ as x)  -> return x
    | `F_call (`Repeat ()) ->
      let next_f = f () in
      return (`Repeat (next_render, next_f))
  )
;;
