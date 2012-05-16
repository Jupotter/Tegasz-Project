external play: 'a -> 'b -> unit = "call_play";; (*LAUUL*)
external load: string -> 'b -> 'a = "call_load";;
external stop: 'a -> unit = "call_stop";;
external unpause: 'a -> unit = "call_pause";;
external init: unit -> 'a = "call_init";;
external volume: float -> 'a -> unit = "set_volume";;

class playlist = 
object
  val mutable plist = []
  val mutable current = -1

  method addToStart x = plist <- x::plist
  method addToEnd (x:string) = 
    let rec addrec x = function 
      | [] -> x::[]
      | h::l -> h::(addrec x l)
    in plist <- addrec x plist

  method setCurrent x = current <- x
  method getCurrent () = current

  method getCurrentSong () = 
    let rec getCSrec x = function
      | [] -> raise Not_found
      | h::_ when x = current -> x
      | _::l -> getCSrec (x+1) l
    in getCSrec 0 plist

end

class data = 
  object
    val mutable son = ()
    val mutable name = ""
    val mutable playing = false

    method setSound x = son <- x
    method getSound () = son
    method getName () = name
    method setName x = name <- x

    method setPlaying x = playing <- x
    method isPlaying () = playing

    val mutable channel = ()

    method setChannel x = channel <- x
    method getChannel () = channel

    val mutable pList = new playlist

    method getPlayList () = pList 
end

let d = new data

let getInit = 
  let i = init () in
    fun () -> i

let window =
  GMain.init ();
  let wnd = GWindow.window
    ~title:"PROJET"
    ~position:`CENTER
    ~resizable:false
    ~width:500 ~height:110 () in
  wnd#connect#destroy GMain.quit;
  wnd

(* ========== VBOX (PRINCIPAL) ========== *)

let vbox = GPack.vbox
  ~spacing:2
  ~border_width:2
  ~packing:window#add ()

let toolbar = GButton.toolbar
  ~orientation:`HORIZONTAL
  ~style:`ICONS
  ~packing:(vbox#pack ~expand:false) ()

(* ========== BOUTONS MULTIMEDIAS ========= *)

let bbox = GPack.button_box `HORIZONTAL
  ~layout:`EDGE
  ~border_width:2
  ~packing:(vbox#pack ~expand:false) ()

let playfunc btn () = 
  if d#isPlaying () = false then
    begin
      let x = getInit () in
      let s = d#getSound() in
      if s != () then
	begin
	  d#setChannel (play (s) (x));
	  d#setPlaying true;
	  window#set_title (String.concat  " " ("PROJET --"::(d#getName ())::[]))
	end
    end
  else
    if btn#active then
      unpause (d#getChannel ())
    else
      stop (d#getChannel ())


let play =
  let btn = GButton.toggle_button
    ~label: "PLAY \n  >"
    ~active: false
    ~packing: bbox#add() in
  btn#connect#toggled ~callback: (playfunc btn)

let stopfunc () =
  if d#isPlaying () then
    begin 
      stop (d#getChannel ());
      d#setPlaying false;
      window#set_title "PROJET"
    end

let stop =
  let btn = GButton.button
    ~packing: bbox#add()
    ~label: "STOP \n   []" in
  btn#connect#clicked ~callback: stopfunc
  
let next = GButton.button
~packing: bbox#add()
 ~label: "NEXT \n >>|"
(* fonction1#connect#clicked ~callback: fonction args*)

let previous = GButton.button
~packing: bbox#add()
~label: "PREVIOUS \n     |<<"
(* fonction1#connect#clicked ~callback: fonction args*)

(* bonjour *)
(* TG *)

let volume = 
  let btn = GRange.scale `HORIZONTAL
  ~packing: bbox#add()
  ~digits: 0
  ~update_policy: `CONTINUOUS
  in 
  let adj = GData.adjustment
    ~lower: 0.
    ~upper: 100.
    ~step_incr: 1.
    ~page_incr: 10.
    ~page_size: 0.
    ~value: 100.
  in btn#set_adjustment (adj ());
  btn#connect#value_changed (fun () -> volume (btn#adjustment#value)
  (d#getChannel ()))
  

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

let may_view btn () =
  match btn#filename with
    | Some n ->
      d#setSound (load n (getInit ()));
      d#setName (let l = (Str.split (Str.regexp "/") n) in let l = List.rev l in
							   match l with |h::t -> h | _ -> assert false)
    | None -> ()

let buttonopen =
  let btn = GFile.chooser_button
    ~action:`OPEN
    ~packing:item1#add ()
  in btn#connect#selection_changed (may_view btn);
  btn

let select_playlist =
  let wnd = GWindow.window
    ~height:500
    ~width:500
    ~resizable:true
    ~position:`CENTER
    ~show:false
    ~title:"Playlist" () in
  wnd


let vbox_playlist = GPack.vbox
  ~spacing:3
  ~border_width:3
  ~packing:select_playlist#add ()

let toolbar_playlist = GButton.toolbar
  ~orientation:`HORIZONTAL
  ~style:`ICONS
  ~packing:(vbox_playlist#pack ~expand:false) ()


let item1_playlist = GButton.tool_item ~packing:toolbar_playlist#insert ()
let sep1_playlist = GButton.separator_tool_item ~packing:toolbar_playlist#insert ()
let item2_playlist = GButton.tool_item
  ~packing:toolbar_playlist#insert ()
let sep2_playlist = GButton.separator_tool_item ~packing:toolbar_playlist#insert ()
let item3_playlist = GButton.tool_item ~packing:toolbar_playlist#insert ()


let text =
  let scroll = GBin.scrolled_window
    ~hpolicy:`ALWAYS
    ~vpolicy:`ALWAYS
    ~shadow_type:`ETCHED_IN
    ~packing:vbox_playlist#add () in
  let txt = GText.view ~packing:scroll#add () in
  txt#misc#modify_font_by_name "Monospace 12";
  txt



let add_playlist = GButton.button
    ~label: " ADD +"
    ~packing: item1_playlist#add()

let del_playlist = GButton.button
  ~label: "DEL -"
  ~packing: item2_playlist#add()

let close_playlist =
  let btn = GButton.button
  ~label: "Quit"
  ~packing: item3_playlist#add()
  in btn#connect#clicked ~callback: select_playlist#misc#hide

let btn_playlist =
  let btn = GButton.button
    ~label:"Playlist"
    ~packing: item2#add () in
  btn#connect#clicked ~callback: (fun () -> select_playlist#show () )
    

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
      Attention :\nvous perdrez toutes les modifications que vous y avez apportées </b>\n"
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
  (*edit_playlist#connect#clicked  cbox#misc#show;*)
  hide#connect#clicked ~callback:cbox#misc#hide;
  window#event#connect#delete confirm;
  window#show ();
  GMain.main ()
