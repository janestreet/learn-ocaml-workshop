open! Base
open! Js_of_ocaml
open! Import

open Scaffold

module Screen = struct
  type t =
    { context : Html.canvasRenderingContext2D Js.t 
    ; width   : int
    ; height  : int
    }
end

module Image_impl = struct
  type t =
    { image_element  : Html.imageElement Js.t
    }

  let create path =
    let image_element = Html.createImg document in
    image_element##.src := Js.string path;
    { image_element
    }
  ;;

  (* If we were using a concurrency library like [Async] or [Lwt], we would want
     to make [width] and [height] members of the record. But they can only be
     read after the image has loaded. *)
  let width  t = jsoptdef_value_exn (t.image_element##.naturalWidth )
  let height t = jsoptdef_value_exn (t.image_element##.naturalHeight)

  let draw (screen : Screen.t) t x y img_width img_height =
    let f = Int.to_float in
    screen.context##drawImage_full
      t.image_element
      0. 0.
      (width t |> f) (height t |> f)
      x y
      (f img_width) (f img_height)
end

module Wad = struct
  type t =
    { background           : Image_impl.t
    ; skull_and_crossbones : Image_impl.t
    ; frog_up              : Image_impl.t
    ; frog_down            : Image_impl.t
    ; frog_left            : Image_impl.t
    ; frog_right           : Image_impl.t
    ; car1_left            : Image_impl.t
    ; car2_left            : Image_impl.t
    ; car1_right           : Image_impl.t
    ; car2_right           : Image_impl.t
    ; car3_left            : Image_impl.t
    ; car3_right           : Image_impl.t
    ; confetti             : Image_impl.t
    ; log1                 : Image_impl.t
    ; log2                 : Image_impl.t
    ; log3                 : Image_impl.t
    }
  [@@deriving fields]

  let create (config : Config.t) =
    let background           = Image_impl.create "assets/background.png" in
    let skull_and_crossbones = Image_impl.create "assets/skull.png"  in
    let frog_up              = Image_impl.create "assets/camel-up.png"  in
    let frog_down            = Image_impl.create "assets/camel-down.png"  in
    let frog_left            = Image_impl.create "assets/camel-left.png"  in
    let frog_right           = Image_impl.create "assets/camel-right.png"  in
    let car1_left            = Image_impl.create "assets/buggy-left.png"  in
    let car1_right           = Image_impl.create "assets/buggy-right.png"  in
    let car2_left            = Image_impl.create "assets/truck-left.png"  in
    let car2_right           = Image_impl.create "assets/truck-right.png"  in
    let car3_left            = Image_impl.create "assets/police-car-left.png"  in
    let car3_right           = Image_impl.create "assets/police-car-right.png"  in
    let log1                 = Image_impl.create "assets/carpet_blue.png"  in
    let log2                 = Image_impl.create "assets/carpet_green.png"  in
    let log3                 = Image_impl.create "assets/carpet_red.png"  in
    let confetti             = Image_impl.create "assets/confetti.png"  in
    { background
    ; skull_and_crossbones
    ; frog_up             
    ; frog_down           
    ; frog_left           
    ; frog_right          
    ; car1_left           
    ; car2_left           
    ; car1_right          
    ; car2_right
    ; car3_left
    ; car3_right
    ; confetti
    ; log1
    ; log2
    ; log3
    }
  ;;

  let lookup_image t (image : Image.t) =
    match image with
    | Frog_up              -> t.frog_up
    | Frog_down            -> t.frog_down
    | Frog_left            -> t.frog_left
    | Frog_right           -> t.frog_right

    | Car1_left            -> t.car1_left
    | Car1_right           -> t.car1_right
    | Car2_left            -> t.car2_left
    | Car2_right           -> t.car2_right
    | Car3_left            -> t.car3_left
    | Car3_right           -> t.car3_right

    | Log1                 -> t.log1
    | Log2                 -> t.log2
    | Log3                 -> t.log3

    | Confetti             -> t.confetti
    | Skull_and_crossbones -> t.skull_and_crossbones
end
