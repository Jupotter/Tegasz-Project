external play: 'a -> 'b -> unit = "call_play";; (*LAUUL*)
external load: string -> 'b -> 'a = "call_load";;
external stop: 'a -> unit = "call_stop";;
external unpause: 'a -> unit = "call_pause";;
external init: unit -> 'a = "call_init";;
external volume: float -> 'a -> unit = "set_volume";;
external paused: 'a -> int = "is_paused";;
external timer: 'a -> int = "timer";;
external album: 'a -> string = "getAlbum";;
external tottime: 'a -> int = "getTotalTime";;


class data = 
  object
    val mutable son = ()
    val mutable name = ""
    val mutable playing = false
    val mutable playlist_current = None

    method setSound x = son <- x
    method getSound () = son
    method getName () = name
    method setName x = name <- x

    method setPlaying x = playing <- x
    method isPlaying () = playing

    method getPListCurrent () = playlist_current
    method setPListCurrent (x:Gtk.tree_iter option)  = playlist_current <- x

    val mutable channel = ()

    method setChannel x = channel <- x
    method getChannel () = channel
end

let d = new data

let cols = new GTree.column_list
let col_name = cols#add Gobject.Data.string     (* string column *)
let col_age = cols#add Gobject.Data.int 	(* int column *)

let liste = []

let playlist = 
  let pl = GTree.list_store cols in
  d#setPListCurrent (pl#get_iter_first);
  pl

let getInit = 
  let i = init () in
    fun () -> i

let playlist_add s = 
  let row = playlist#append () in
  playlist#set ~row ~column:col_name s;
  playlist#set ~row ~column:col_age  0;
  if d#getPListCurrent () = None then
    d#setPListCurrent (Some(row));
  row


(* ========= Main Window ======== *)

let window =
  GMain.init ();
  let wnd = GWindow.window
    ~title:"PROJET"
    ~position:`CENTER
    ~resizable:false
    ~width:500 ~height:120 () in
  wnd#connect#destroy GMain.quit;
  wnd

(* ================ COVER INTERFACE =============== *)

let show_cover =
  let wnd  = GWindow.window
    ~height:400
    ~width:400
    ~resizable:true
    ~position: `NONE
    ~show:false
    ~deletable: false
    ~decorated: true
    ~title:"Cover" () in
  wnd

let vbox_cover = GPack.vbox
  ~spacing:3
  ~border_width:3
  ~packing:show_cover#add ()


let toolbar_cover= GButton.toolbar
  ~orientation:`HORIZONTAL
  ~style:`ICONS
  ~packing:(vbox_cover#pack ~expand:false) ()

let view = GPack.vbox 
  ~packing:vbox_cover#add ()
(*
let image (s: string) =
  GMisc.image
    ~file: s
    ~packing: view#add()
  *)

let image = GMisc.image
            ~file: "UNKNOWN.jpg"
            ~packing: view#add()

(* ================== VBOX (PRINCIPAL) ================ *)

let vbox = GPack.vbox
  ~spacing:2
  ~border_width:2
  ~packing:window#add ()

let toolbar = GButton.toolbar
  ~orientation:`HORIZONTAL
  ~style:`ICONS
  ~packing:(vbox#pack ~expand:false) ()

(* ================= BOUTONS MULTIMEDIAS ================ *)

let bbox = GPack.button_box `HORIZONTAL
  ~layout:`EDGE
  ~border_width:2
  ~packing:(vbox#pack ~expand:false) ()

let playfunc btn () =
  if btn#active then
    if d#isPlaying () = false then
      begin
	let x = getInit () in
	let row = match d#getPListCurrent () with None -> assert false
          | Some n -> n in
	(*if row != () then*)
        begin
          let name = playlist#get ~row ~column:col_name in
          d#setSound (load name (getInit ()));
          d#setName (let l = (Str.split (Str.regexp "/") name) in
		     let l = List.rev l in
		     match l with |h::t -> h | _ -> assert false);
          let s = d#getSound() in
          if s != () then
            begin
              d#setChannel (play (s) (x));
              d#setPlaying true;
              let alb = album(s) in
		(*  image(alb);
	      print_string alb;*)
	      flush stdout;
	      let img_alb =
		String.concat "" (alb::".jpg"::[]) in
	      image#set_file (img_alb);
	      (*print_string(img_alb);*)
	      flush stdout;
              window#set_title (String.concat  " " ("PROJET --"::(d#getName ())::[]))
            end
        end
      end
    else
      unpause (d#getChannel ())
  else
    stop (d#getChannel ())


let play =
  let btn = GButton.toggle_button
    ~label: "PLAY \n  >"
    ~active: false
    ~packing: bbox#add() in
  btn#connect#toggled ~callback: (playfunc btn);
  btn

let stopfunc () =
  if d#isPlaying () then
    begin 
      stop (d#getChannel ());
      d#setPlaying false;
      window#set_title "PROJET";
      play#set_active false
    end

let playlist_next () =
  let iter = d#getPListCurrent () in
  begin
  match iter with
  |None -> ()
  |Some(row) ->
      begin
        if playlist#iter_next row then
          begin
            stopfunc ();
            play#set_active true;
          end
        else
          stopfunc ();
      end
  end

let playlist_prev () = 
  let iter = d#getPListCurrent () in
  match iter with 
  |None -> ()
  |Some(row) ->
      begin
        let path = playlist#get_path row in
        if GTree.Path.prev path then
        let iter = playlist#get_iter path in
        d#setPListCurrent (Some(iter));
        stopfunc ();
        play#set_active true;
        else
          stopfunc ();
      end

let playlist_del selection =
  let del path =
    let row = playlist#get_iter path in
    playlist#remove row; ()
  in List.iter del selection#get_selected_rows

let stop =
  let btn = GButton.button
    ~packing: bbox#add()
    ~label: "STOP \n   []" in
  btn#connect#clicked ~callback: stopfunc
  
let next =
  let btn = GButton.button
  ~packing: bbox#add()
  ~label: "NEXT \n >>|" in
  btn#connect#clicked ~callback: playlist_next
(* fonction1#connect#clicked ~callback: fonction args*)

let previous = 
  let btn = GButton.button
~packing: bbox#add()
~label: "PREVIOUS \n     |<<" in
  btn#connect#clicked ~callback: playlist_prev
(* fonction1#connect#clicked ~callback: fonction args*)

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


 let hide = GButton.button
   ~label:"Cacher"
   ~packing:cbox#add ()


(*========== TOOLBAR PLAYLIST ==========*)

let item1 = GButton.tool_item ~packing:toolbar#insert ()
let sep1 = GButton.separator_tool_item ~packing:toolbar#insert ()
let item2 = GButton.tool_item ~packing:toolbar#insert ()
let item3 = GButton.tool_item ~packing:toolbar#insert ()
let sep2 = GButton.separator_tool_item ~packing:toolbar#insert ()
let item4 = GButton.tool_item ~packing:toolbar#insert ()

let item5 = GButton.tool_item ~packing:toolbar#insert ()
let sep3 = GButton.separator_tool_item ~packing:toolbar#insert ()
let item6 = GButton.tool_item ~packing:toolbar#insert ()

let may_view btn () =
  match btn#filename with
    | Some n ->
        let row = playlist_add n in
        d#setPListCurrent (Some(row));
        stopfunc ();
        play#set_active true
          (*d#setSound (load n (getInit ()));
          d#setName (let l = (Str.split (Str.regexp "/") n) in let l = List.rev l in
							   match l with |h::t -> h | _ -> assert false)*)
    | None -> ()

let buttonopen =
  let btn = GFile.chooser_button
    ~action:`OPEN
    ~packing:item1#add ()
  in btn#connect#selection_changed (may_view btn);
  btn

(*=================== COVER =====================*)

let close_cover =
  let btn = GButton.button
  ~label: "Quit"
  ~packing: toolbar_cover#add()
  in btn#connect#clicked ~callback: show_cover#misc#hide



let btn_cover =
  let btn = GButton.button
    ~label:"Cover"
    ~packing: item3#add () in
    btn#connect#clicked ~callback: (fun () -> show_cover#show ();
				      show_cover#move 640 500)


(*===================  PLAYLIST  =====================*)

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
let item2_playlist = GButton.tool_item ~packing:toolbar_playlist#insert ()
let sep2_playlist = GButton.separator_tool_item ~packing:toolbar_playlist#insert ()
let item3_playlist = GButton.tool_item ~packing:toolbar_playlist#insert ()


let create_view ~model ~packing () =
  let view = GTree.view ~model ~packing () in
  (* Column #1: nom *)
  let col = GTree.view_column ~title:"Nom" 
      ~renderer:(GTree.cell_renderer_text [], ["text", col_name]) () in
  (* Column #1: nom *)
  ignore (view#append_column col);
    (* Column #2: emplacemement *)
  let col = GTree.view_column ~title:"Emplacement"
      ~renderer:(GTree.cell_renderer_text [], ["text", col_age]) () in
  ignore (view#append_column col);
  ignore (view#selection#set_mode `SINGLE);
  view


let playlist_view =
  let model = playlist in
  create_view ~model ~packing:vbox_playlist#add ()

let may_view_playlist btn () =
  match btn#filename with
    | Some n -> playlist_add n; ()
    | None -> ()

let add_playlist =
  let btn = GFile.chooser_button
    ~action: `OPEN
    ~packing: item1_playlist#add() in
  btn#connect#selection_changed ~callback: (may_view_playlist btn);
  btn


(*let remove_playlist () =
  playlist#get_selecte_rows
    playlist#remove*)

let del_playlist = 
let btn = GButton.button 
  ~label: "DEL -"
  ~packing: item2_playlist#add() in
  btn#connect#clicked ~callback: (fun () -> 
    playlist_del playlist_view#selection; ())

let close_playlist =
  let btn = GButton.button
  ~label: "Quit"
  ~packing: item3_playlist#add() in
  btn#connect#clicked ~callback: select_playlist#misc#hide

let btn_playlist =
  let btn = GButton.button
    ~label:"Playlist"
    ~packing: item2#add () in
  btn#connect#clicked ~callback: (fun () -> select_playlist#show ())
    

(*======================  TIMER  ==========================*)
let bbox_timer = GPack.button_box `HORIZONTAL
  ~layout:`EDGE
  ~border_width:2
  ~packing:(vbox#pack ~expand:true) ()

let progress_bar =  GRange.progress_bar
  ~orientation:`LEFT_TO_RIGHT
  ~packing: bbox_timer#add()

let update_bar () = 
  let curt  = timer (d#getChannel ()) in
  let tott  = tottime (d#getSound ()) in
  let pcent = (curt * 100) / tott     in
  let adj = GData.adjustment
    ~lower: 0.
    ~upper: 100.
    ~step_incr: 1.
    ~page_incr: 10.
    ~page_size: 0.
    ~value: (float_of_int pcent)
  in progress_bar#set_adjustment (adj ())

let clear_bar () = 
  let adj = GData.adjustment
    ~lower: 0.
    ~upper: 100.
    ~step_incr: 1.
    ~page_incr: 10.
    ~page_size: 0.
    ~value: 0. 
  in progress_bar#set_adjustment (adj ())


(* ======================  USELESS BUTTONS  ============================= *)

let help_button =
  let dlg = GWindow.message_dialog
    ~message:"<b><big> Please, follow the instructions </big>\n\n\
  In order to listen just one file, clic on the first button on the left. Then, select the file you want, and it will automatically played.\n
If you want to make a playlist, clic on the button Playlist. Then, in the window, clic on the first button to add the file you want. You can add every audio file you wish. You can also delete the file you want selecting it and then you clic on DEL. Then, clic on the button Quit, the playlist is now saved, you can listen it by clicking on Play.\n
If the cover is not found, the picture \"cover not found\" is displayed. Else, PROJET finds the cover inside of the floder and display it.\n
 </b>"
    ~parent:window
    ~destroy_with_parent:true
    ~use_markup:true
    ~message_type:`QUESTION
    ~position:`CENTER_ON_PARENT
    ~buttons:GWindow.Buttons.ok() in
  let btn = GButton.button
    ~label: "HELP"
    ~packing:item4#add ()
  in
  GMisc.image ~stock:`HELP ~packing:btn#set_image ();
  btn#connect#clicked (fun () -> ignore (dlg#run ()); dlg#misc#hide ());
  btn

let about_button =
  let dlg = GWindow.about_dialog
    ~authors:["Julien Garagnon, Julien Szkudlarek,
 Maxime Temple"]
    ~copyright:"Copyright (c) 2012 "
    ~license:"Public License."
    ~version:"1.00"
    ~website:"http///www.tegasz.com"
    ~website_label:"Visit our website"
    ~position:`CENTER_ON_PARENT
    ~parent:window
    ~destroy_with_parent:true () in
  let btn = GButton.button
~label: "About"
~packing:item5#add () in
   GMisc.image
     ~stock:`ABOUT
     ~packing:btn#set_image ();
  btn#connect#clicked (fun () -> ignore (dlg#run ()); dlg#misc#hide ());
  btn

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

let loop () = 
  let stop = paused (d#getChannel ()) in
  if ((play#active)&&(stop != 0) ) then
    begin
      playlist_next ();
      clear_bar ()
    end;
    if (play#active) then
      begin
        update_bar ()
      end;
  true

let _ =
  hide#connect#clicked ~callback:cbox#misc#hide;
  window#event#connect#delete confirm;

(*~callback: show_cover#misc#hide; *)
  
     
  window#show ();
  GMain.Idle.add loop;
  GMain.main ()
