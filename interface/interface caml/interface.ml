let window =
  GMain.init ();
  let wnd = GWindow.window
    ~title:"Mapplestore"
    ~position:`CENTER 
    ~resizable:false
    ~width:1000 ~height:700 () in
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

(*========== corps de l'interface ==========*)

let hbox= 
  GPack.hbox
    ~homogeneous:false
    ~spacing:4
    ~border_width:4
    ~packing:vbox#add ()


let view = GPack.vbox 
  ~packing:hbox#add ()

let image = GMisc.image
	    ~file: "principal.bmp"
	    ~packing: view#add()

let cbox = GPack.button_box `VERTICAL
~show:false
  ~layout:`EDGE
  ~border_width:20
  ~packing:(hbox#pack ~expand:false) ()

(*========== BARRE DU BAS ========== *)

(*quatre boutons : reduction du bruit, detoureement de la carte,
  echantillonage du relief, cration du fichier .obj et visualisation
  3D *)

let bbox = GPack.button_box `HORIZONTAL
  ~layout:`EDGE 
  ~border_width:2
  ~packing:(vbox#pack ~expand:false) () 


let traitement = GButton.button
~packing: bbox#add()
~label: "Réduction du bruit"
(*fonction1#connect#clicked ~callback: fonction argument *)

let detourage = GButton.button
~packing: bbox#add()
~label: "Détourer la carte"

let echantillonage = GButton.button
~packing: bbox#add()
~label: "Echantillonner le relief"
(* fonction1#connect#clicked ~callback: fonction args*)


let point_obj = GButton.button
~packing: bbox#add()
~label: "Création du fichier \" .obj\" "
(* fonction1#connect#clicked ~callback: fonction args*)



let visualisation = GButton.button
~packing: bbox#add()
~label: "Visualisation 3D"
(* fonction1#connect#clicked ~callback: fonction args*)





  (*========== COULEURS ==========*)

let couleur1 = GPack.button_box `HORIZONTAL
  ~layout:`EDGE
  ~border_width:2
  ~packing:(cbox#pack ~expand:false) ()

let test = GMisc.label
  ~text: "couleur1"
~packing: couleur1#add ()

(*let heightSpin1 =
  GEdit.spin_button

    ~width:105
    ~digits:0
    ~numeric:true
    ~packing:couleur1#pack ()*)

let hauteur1 =
  GEdit.entry
    ~text:""
    ~visibility:true
    ~editable:true
    ~width:40
    ~packing:couleur1#pack ()

let couleur2 = GPack.button_box `HORIZONTAL
  ~layout:`EDGE
  ~border_width:2
  ~packing:(cbox#pack ~expand:false) ()

let test2 = GMisc.label
  ~text: "couleur2"
~packing: couleur2#add ()

let hauteur2 =
  GEdit.entry
    ~text:""
    ~visibility:true
    ~editable:true
    ~width:40
    ~packing:couleur2#pack ()
  
let couleur3 = GPack.button_box `HORIZONTAL
  ~layout:`EDGE
  ~border_width:2
  ~packing:(cbox#pack ~expand:false) ()

let test3 = GMisc.label
  ~text: "couleur3"
~packing: couleur3#add ()

let hauteur3 =
  GEdit.entry
    ~text:""
    ~visibility:true
    ~editable:true
    ~width:40
    ~packing:couleur3#pack ()

let couleur4 = GPack.button_box `HORIZONTAL
  ~layout:`EDGE
  ~border_width:2
  ~packing:(cbox#pack ~expand:false) ()

let test4 = GMisc.label
  ~text: "couleur4"
~packing: couleur4#add ()

let hauteur4 =
  GEdit.entry
    ~text:""
    ~visibility:true
    ~editable:true
    ~width:40
    ~packing:couleur4#pack ()

let couleur5 = GPack.button_box `HORIZONTAL
  ~layout:`EDGE
  ~border_width:2
  ~packing:(cbox#pack ~expand:false) ()

let test5 = GMisc.label
  ~text: "couleur5"
~packing: couleur5#add ()

let hauteur5 =
  GEdit.entry
    ~text:""
    ~visibility:true
    ~editable:true
    ~width:40
    ~packing:couleur5#pack ()

let couleur6 = GPack.button_box `HORIZONTAL
  ~layout:`EDGE
  ~border_width:2
  ~packing:(cbox#pack ~expand:false) ()

let test6 = GMisc.label
  ~text: "couleur6"
~packing: couleur6#add ()

let hauteur6 =
  GEdit.entry
    ~text:""
    ~visibility:true
    ~editable:true
    ~width:40
    ~packing:couleur6#pack ()

let couleur7 = GPack.button_box `HORIZONTAL
  ~layout:`EDGE
  ~border_width:2
  ~packing:(cbox#pack ~expand:false) ()

let test7 = GMisc.label
  ~text: "couleur7"
~packing: couleur7#add ()

let hauteur7 =
  GEdit.entry
    ~text:""
    ~visibility:true
    ~editable:true
    ~width:40
    ~packing:couleur7#pack ()

let couleur8 = GPack.button_box `HORIZONTAL
  ~layout:`EDGE
  ~border_width:2
  ~packing:(cbox#pack ~expand:false) ()

let test8 = GMisc.label
  ~text: "couleur8"
~packing: couleur8#add ()

let hauteur8 =
  GEdit.entry
    ~text:""
    ~visibility:true
    ~editable:true
    ~width:40
    ~packing:couleur8#pack ()


 let btn = GButton.button 
~label:"Cacher" 
~packing:cbox#add ()




(*========== AFFICHAGE MAP ========== *)

let may_view btn () =
match btn#filename with
Some n ->
  ignore ( image#set_file n
  )
  | None -> ()


  (*========== TOOLBAR ==========*)

let item1 = GButton.tool_item ~packing:toolbar#insert () 
let sep1 = GButton.separator_tool_item ~packing:toolbar#insert () 
let item2 = GButton.tool_item ~packing:toolbar#insert ()
let item3 = GButton.tool_item ~packing:toolbar#insert ()
let item4 = GButton.tool_item ~packing:toolbar#insert ()
let sep2 = GButton.separator_tool_item ~packing:toolbar#insert () 
let item5 = GButton.tool_item ~packing:toolbar#insert ()
let item6 = GButton.tool_item ~packing:toolbar#insert ()


let buttonopen =
let btn = GFile.chooser_button
~action:`OPEN
~packing:item1#add ()

	  in btn#connect#selection_changed (may_view btn);
btn


let edit = GButton.button
 ~label: "Editer"
~packing: item2#add ()

 

 

let help_button =
  let dlg = GWindow.message_dialog
    
~message:"<b><big> AIDE  </big>\n\n\
    bonjour et bienvenue dans \" mapplestore \" le logiciel de cartographie en trois dimensions. Pour profiter de toutes les possibilites de ce logiciel, effectuez les fonctions les unes apres les autres afin de visualiser la carte en trois dimensions  </b>"
    ~parent:window
    ~destroy_with_parent:true
    ~use_markup:true
    ~message_type:`QUESTION
    ~position:`CENTER_ON_PARENT
    ~buttons:GWindow.Buttons.ok()
 in
  let btn = GButton.button 
~label: "Aide"
(*~stock:`HELP*) 
~packing:item3#add () 
  in
   GMisc.image ~stock:`HELP ~packing:btn#set_image ();
  btn#connect#clicked (fun () -> ignore (dlg#run ()); dlg#misc#hide ());
  btn

let about_button =
  let dlg = GWindow.about_dialog
    ~authors:["Quentin LepraÃ«l, Benjamin Richard,
 Maxime TemplÃ©, Mathieu Mailhos"]
    ~copyright:"Copyright Â© 2010-2011 "
    ~license:"Public License."
    ~version:"42"
    ~website:"http///www.mapplestore.com"
    ~website_label:"Visit our website"
    ~position:`CENTER_ON_PARENT
    ~parent:window
    ~destroy_with_parent:true () in
  let btn = GButton.button 
~label: "A propos"
(*~stock:`ABOUT*) 
~packing:item4#add () in
   GMisc.image 
     ~stock:`ABOUT 
     ~packing:btn#set_image ();
  btn#connect#clicked (fun () -> ignore (dlg#run ()); dlg#misc#hide ());
  btn

 let test = GMisc.label
   ~text: "                                                                                                                                                             "
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
  btn#connect#clicked ~callback:cbox#misc#hide;
  edit#connect#clicked  cbox#misc#show;

  window#event#connect#delete confirm;
  window#show ();
  GMain.main ()
