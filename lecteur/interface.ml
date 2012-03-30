external play: 'a -> 'b -> unit = "call_play";; (*LAUUL*)
external load: string -> 'b -> 'a = "call_load";;
external stop: 'a -> 'b -> unit = "call_stop";;
external pause: 'a -> 'b -> unit = "call_pause";;
external init: unit -> 'a = "call_init";;

let getInit = 
  let i = init () in
    fun () -> i

let window =
  GMain.init ();
  let wnd = GWindow.window
    ~title:"TeGaSz"
    ~position:`CENTER
    ~resizable:false
    ~width:500 ~height:200 () in
  wnd#connect#destroy GMain.quit;
  wnd

(*========== VBOX (PRINCIPAL) ========== *)

let vbox = GPack.vbox
  ~spacing:2
  ~border_width:2
  ~packing:window#add ()

let toolbar = GButton.toolbar
  ~orientation:`HORIZONTAL
  ~style:`ICONS
  ~packing:(vbox#pack ~expand:false) ()

(*========== BOUTONS MULTIMEDIAS ========= *)

let bbox = GPack.button_box `HORIZONTAL
  ~layout:`EDGE
  ~border_width:2
  ~packing:(vbox#pack ~expand:false) ()


let play =
  let btn = GButton.button
    ~stock: `MEDIA_PLAY
    ~label: ">"
    ~packing: bbox#add() in
  btn#connect#clicked ~callback: (fun() -> play 0 (getInit ()))

let stop = GButton.button
  ~packing: bbox#add()
~stock: `MEDIA_STOP
  ~label: "[]"
  
let next = GButton.button
~packing: bbox#add()
~stock: `MEDIA_NEXT
 ~label: ">>|"
(* fonction1#connect#clicked ~callback: fonction args*)

let forward = GButton.button
~packing: bbox#add()
~stock:`MEDIA_FORWARD
~label: "|<<"
(* fonction1#connect#clicked ~callback: fonction args*)

(*bonjour *)

(*========== corps de l'interface ==========*)

let hbox=
  GPack.hbox
    ~homogeneous:false
    ~spacing:4
    ~border_width:4
    ~packing:vbox#add ()


let view = GPack.vbox
  ~packing:hbox#add ()


let cbox = GPack.button_box `VERTICAL
~show:false
  ~layout:`EDGE
  ~border_width:20
  ~packing:(hbox#pack ~expand:false) ()

  (*========== PLAYLIST ==========*)


 let hide = GButton.button
~label:"Cacher"
~packing:cbox#add ()

  (*========== TOOLBAR ==========*)

let item1 = GButton.tool_item ~packing:toolbar#insert ()
let sep1 = GButton.separator_tool_item ~packing:toolbar#insert ()
let item2 = GButton.tool_item ~packing:toolbar#insert ()
let item3 = GButton.tool_item ~packing:toolbar#insert ()
let item4 = GButton.tool_item ~packing:toolbar#insert ()
let sep2 = GButton.separator_tool_item ~packing:toolbar#insert ()
let item5 = GButton.tool_item ~packing:toolbar#insert ()
let item6 = GButton.tool_item ~packing:toolbar#insert ()


let buttonopen =  GFile.chooser_button
~action:`OPEN
~packing:item1#add ()


let edit = GButton.button
 ~label: "afficher la playlist "
~packing: item2#add ()


let help_button =
  let dlg = GWindow.message_dialog

~message:"<b><big> AIDE  </big>\n\n\
  wesh si si bien la famille les poneys  </b>"
    ~parent:window
    ~destroy_with_parent:true
    ~use_markup:true
    ~message_type:`QUESTION
    ~position:`CENTER_ON_PARENT
    ~buttons:GWindow.Buttons.ok()
 in
  let btn = GButton.button
~label: "Aide"
~packing:item3#add ()
  in
   GMisc.image ~stock:`HELP ~packing:btn#set_image ();
  btn#connect#clicked (fun () -> ignore (dlg#run ()); dlg#misc#hide ());
  btn

let about_button =
  let dlg = GWindow.about_dialog
    ~authors:["Julien Garagnon, Julien Szkudlarek,
 Maxime Temple, "]
    ~copyright:"Copyright (c) 2012 "
    ~license:"Public License."
    ~version:"0.42"
    ~website:"http///www.tegasz.com"
    ~website_label:"Visit our website"
    ~position:`CENTER_ON_PARENT
    ~parent:window
    ~destroy_with_parent:true () in
  let btn = GButton.button
~label: "A propos"
~packing:item4#add () in
   GMisc.image
     ~stock:`ABOUT
     ~packing:btn#set_image ();
  btn#connect#clicked (fun () -> ignore (dlg#run ()); dlg#misc#hide ());
  btn

 let test = GMisc.label
   ~text: ""
~packing: item5#add ()

let buttonquit =
  let btn = GButton.button
    ~stock:`QUIT
    ~packing:item6#add () in
  btn#connect#clicked
  ~callback:GMain.quit;
btn


  (*========= FUNCTIONS ========== *)


let confirm _ =
  let dlg = GWindow.message_dialog
    ~message:"<b><big>Voulez-vous vraiment quitter ?</big>\n\n\
      Attention :\nvous perdrez toutes les modifications que  vous y avez apportées </b>\n"
    ~parent:window
    ~destroy_with_parent:true
    ~use_markup:true
    ~message_type:`QUESTION
    ~position:`CENTER_ON_PARENT
    ~buttons:GWindow.Buttons.yes_no () in
  let res = dlg#run () = `NO in
  dlg#destroy ();
  res

(*========== APPEL ==========*)

let _ =
  edit#connect#clicked  cbox#misc#show;
  hide#connect#clicked ~callback:cbox#misc#hide;
  window#event#connect#delete confirm;
  window#show ();
  GMain.main ()
