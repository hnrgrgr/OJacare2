(*	$Id: mlClass.ml,v 1.5 2004/07/19 11:22:50 henry Exp $	*)

open Cidl

open Camlp4.PreCast
let _loc = Loc.ghost

(** type top et exception *)
let make_top () =
    let jinst = "java'lang'Object" in
    <:str_item< type top =java_instance $lid:jinst$ >>
let make_exc () =
    <:str_item< exception Null_object of string >>

(** type JNI **********************************************) (* OK *)
let make_jni_type cl_list =
  let make cl = 
    let jinst = Ident.get_class_java_oj_name cl.cc_ident in
    let name = Ident.get_class_ml_jni_type_name cl.cc_ident in
    <:str_item< type $lid:name$ =java_instance $lid:jinst$ >> in
  P4helper.str_items (List.map make cl_list)

let make_jni_CB_type cl_list =
  let make cl =   
    let jinst = Ident.get_class_java_oj_cb_name cl.cc_ident in
    let name = Ident.get_class_ml_jni_cb_type_name cl.cc_ident in
    <:str_item< type $lid:name$ =java_instance $lid:jinst$ >> in
  P4helper.str_items (List.map make (List.filter (fun cl -> (cl.cc_callback||Method.have_callback cl.cc_public_methods) && not (Ident.is_interface cl.cc_ident)) cl_list))
let make_jni_ICB_type cl_list =
  let make cl =   
    let jinst = Ident.get_class_java_oj_icb_name cl.cc_ident in
    let name = Ident.get_class_ml_jni_icb_type_name cl.cc_ident in
    <:str_item< type $lid:name$ =java_instance $lid:jinst$ >> in
  P4helper.str_items (List.map make (List.filter (fun cl -> (cl.cc_callback||Method.have_callback cl.cc_public_methods) && not (Ident.is_interface cl.cc_ident)) cl_list))

let make_jni_type_sig cl_list =
  let make cl = 
    let name = Ident.get_class_ml_jni_type_name cl.cc_ident in
    <:sig_item< type $lid:name$ (* abstract *) >> in
  P4helper.sig_items (List.map make cl_list)
  

(** class type ********************************************) (* OK *)
let make_class_type ~callback cl_list = 
  if callback then [] else
    begin
  let make cl = 
    let name = Ident.get_class_ml_name cl.cc_ident in
    
    let jni_type_name = Ident.get_class_ml_jni_type_name cl.cc_ident
    and jni_accessor_name = Ident.get_class_ml_jni_accessor_method_name cl.cc_ident in
        
    let method_list = [] in
    
    (* m�thode *)
    let method_list = 
      List.rev_append (MlMethod.make_class_type ~callback:callback cl.cc_methods) method_list in 
    
    (* accesseur *)
    let method_list = <:class_sig_item< method $lid:jni_accessor_name$ : $lid:jni_type_name$ >> :: method_list in
    
    (* h�ritage *)
    let method_list = 
      (List.map (fun interface -> <:class_sig_item< inherit $lid:Ident.get_class_ml_name interface.cc_ident$ >>) cl.cc_implements) @ method_list in
    let method_list = 
     ( match cl.cc_extend with
	None -> <:class_sig_item< >>
      | Some super -> <:class_sig_item< inherit $lid:Ident.get_class_ml_name super.cc_ident$ >>) :: method_list
    in  
    name,callback,<:class_type< object $list:method_list$ end >>  
  in
  List.map make cl_list
      end

(** Allocation *******************************************) (* A enlever *)
let make_alloc cl_list =
  let make cl acc =
    if Ident.is_interface cl.cc_ident then
      acc
    else
      let jclazz = Ident.get_class_java_signature cl.cc_ident in
      <:str_item< value $lid:Ident.get_class_ml_allocator_name cl.cc_ident$ = 
     
      fun () -> ( Jni.alloc_object clazz : $lid:Ident.get_class_ml_jni_type_name cl.cc_ident$) >> :: acc
  in
  P4helper.str_items (List.fold_right make cl_list [])

let make_alloc_stub cl_list =
  let make cl =
    let jclazz = Ident.get_class_java_stub_signature cl.cc_ident in
    let err = "Class not found : "^
      Ident.get_class_java_qualified_stub_name cl.cc_ident ^"." in

    <:str_item< value $lid:Ident.get_class_ml_stub_allocator_name cl.cc_ident$ = 
      let clazz = try Jni.find_class $str:jclazz$ 
      with _ -> failwith $str:err$ in
        fun () -> ( Jni.alloc_object clazz : $lid:Ident.get_class_ml_jni_type_name cl.cc_ident$) >>
  in
  P4helper.str_items (List.map make  (List.filter (fun cl -> cl.cc_callback ) cl_list))

(** capsule / souche *************************************) (* B : ok, TODO char *)
let make_wrapper ~callback cl_list =
  let clazz = "clazz"
  and java_obj = "jni_ref"   
  and java_proxy = "jni_ref_proxy" 
  and init_ref = "init_jni_ref" in
  let make cl =

    let abstract = callback in

    let jclazz = Ident.get_class_java_signature cl.cc_ident (* si 'callback' aussi, car les appel font du ping-pong *) 
    and class_name = 
      if callback then Ident.get_class_ml_stub_wrapper_name cl.cc_ident
      else Ident.get_class_ml_wrapper_name cl.cc_ident in

    (* construction de la liste des m�thodes *)
    let class_decl = [] in
    let jni_ref = if callback then  <:expr< ! $lid:java_obj$ >> else <:expr< $lid:java_obj$ >> in
    let class_decl =
      List.fold_right (fun cl class_decl -> 
	<:class_str_item< method $lid:Ident.get_class_ml_jni_accessor_method_name cl.cc_ident$ = ( $jni_ref$ :> $lid:Ident.get_class_ml_jni_type_name cl.cc_ident$ ) >> 
			  :: class_decl)  cl.cc_all_inherited class_decl 
    in
    (* m�thode accesseur Jni *) (* ok *)
    
    let class_decl =   
      if not callback then
	<:class_str_item< method $lid:Ident.get_class_ml_jni_accessor_method_name cl.cc_ident$ = $lid:java_obj$ >> :: class_decl 
      else 
    	<:class_str_item< method $lid:Ident.get_class_ml_jni_accessor_method_name cl.cc_ident$ = ( $jni_ref$ :> $lid:Ident.get_class_ml_jni_type_name cl.cc_ident$ ) >> :: class_decl 
    in
    
    (* m�thodes IDL *) (* ok *)
    let method_ids, methods = 
     (* if callback then *) MlMethod.make_dyn clazz java_obj ~callback:callback cl.cc_public_methods
     (* else MlMethod.make_dyn clazz java_obj ~callback:callback cl.cc_methods *)
    in
    let class_decl = List.rev_append methods class_decl in
    
    let proxy_decl = [] in
    let proxy_decl = List.rev_append(MlMethod.make_callback (List.filter (fun m -> ( Method.have_callback cl.cc_public_methods && Method.is_callback m) || Ident.is_callback cl.cc_ident )   cl.cc_public_methods)) proxy_decl in

    (* initializer :  proxy si 'callback' *)
    let class_decl = 
      if callback then(	
	let proxy_name =
	  if Ident.is_interface cl.cc_ident
	  then Ident.get_class_java_qualified_name cl.cc_ident
	  else Ident.get_class_java_icb_qualified_name cl.cc_ident
	in
	let java_cb_name = Ident.get_class_java_cb_qualified_name cl.cc_ident in
	let proxy = <:expr< object $list:proxy_decl$ end  >> in
	let initialize_decl =  <:expr<  
	  if Java.is_null ! $lid:java_obj$
	  then raise (Null_object $str:java_cb_name$) else ()  >> :: [] in
	let initialize_decl = if Ident.is_interface cl.cc_ident then initialize_decl else 
	    <:expr<  
	  if Java.is_null ! $lid:java_proxy$
	  then raise (Null_object $str:proxy_name$) else ()  >> :: initialize_decl in
	let initialize_decl =   if Ident.is_interface cl.cc_ident then initialize_decl else
	  let e1 = <:expr< ! $lid:java_proxy$ >> in
	  let e2 = <:expr< init_jni_ref $e1$ >> in

	  <:expr< $lid:java_obj$.val := $e2$ >> :: initialize_decl in
	let initialize_decl = 
	  if Ident.is_interface cl.cc_ident 
	  then <:expr< $lid:java_obj$.val := Java.proxy $str:proxy_name$ $proxy$ >> :: initialize_decl 
	  else  <:expr< $lid:java_proxy$.val := Java.proxy $str:proxy_name$ $proxy$ >> :: initialize_decl 
	in
	<:class_str_item< initializer do {$list:initialize_decl$} >> :: class_decl)
      else
	class_decl
    in

    (* corps de l'objet *)
    let class_body =
      <:class_expr< object (self) $list:class_decl$ end  >> in
    
    (* test si l'objet est nul ... *)
    let class_body =      
      if callback then
	if not (Ident.is_interface cl.cc_ident ) then  
	  <:class_expr< 
	    let $lid:java_proxy$ = ref Java.null 		        
	    in $class_body$ >>
	else
	  class_body
      else
      <:class_expr< 
	let _ = 
	  if Java.is_null $lid:java_obj$
	  then raise (Null_object $str:jclazz$) else () in $class_body$ >>  
    in
    let class_body =      
      if callback then  
	<:class_expr<
	  let $lid:java_obj$ = ref Java.null
	  in $class_body$ >>
      else class_body
    in

 


   
    (* fonction de cr�ation, � partir d'une r�f�rence Jni 
       ou fonction d'initialisation pour les souches *)
   let class_body = 
      if callback  then 
	if (Ident.is_interface cl.cc_ident) 
	then <:class_expr<  $class_body$  >>
	else <:class_expr< fun $lid:init_ref$ -> $class_body$  >>
      else
      <:class_expr< fun ($lid:java_obj$ : $lid:Ident.get_class_ml_jni_type_name cl.cc_ident$) -> $class_body$  >> in 
 
    (* D�claration des id. de m�thode et de champs (captur� dans l'env de la fonction de cr�ation) *)
   let class_body = MlGen.make_class_local_decl method_ids class_body in
    
    (* Retour de 'make' : nom, abstract, body*)
    class_name,abstract,class_body 
  
  in
  List.map make (List.filter (fun cl -> (not callback) || cl.cc_callback || (Method.have_callback cl.cc_public_methods) ) cl_list)




(** engendre les signatures des capsules en pr�vision de la gestion des "import", 
   mais ne doit pas �tre utlis� par un programmeur externe *)
let make_wrapper_sig cl_list =
  let make cl =  
    let jclazz = Ident.get_class_java_signature cl.cc_ident
    and class_name = Ident.get_class_ml_wrapper_name cl.cc_ident in
    <:sig_item< class $lid:class_name$ : [$lid:Ident.get_class_ml_jni_type_name cl.cc_ident$] -> $lid:Ident.get_class_ml_name cl.cc_ident$ >>
  in
  P4helper.sig_items (List.map make cl_list)


let make_jniupcast cl_list =
  let java_obj = "java_obj" in
  let make cl =
    let tname = Ident.get_class_ml_jni_type_name cl.cc_ident in
    let body = 
      <:expr< (Obj.magic : $lid:tname$ -> Jni.obj) $lid:java_obj$ >> in
    let body = <:expr< fun ($lid:java_obj$ : $lid:tname$) -> $body$ >> in
    let name = "__jni_obj_of"^tname in
    [ <:str_item< value $lid:name$ = $body$ >> ] 
  in
  P4helper.str_items (List.concat (List.map make cl_list))

let make_jniupcast_sig cl_list =
  let make cl =
    let tname = Ident.get_class_ml_jni_type_name cl.cc_ident in
    let name = "__jni_obj_of"^tname in
    [ <:sig_item< value $lid:name$ : $lid:tname$ -> Jni.obj >> ] 
  in
  P4helper.sig_items (List.concat (List.map make cl_list))

let make_jnidowncast cl_list =
  let java_obj = "java_obj" 
  and clazz ="clazz" in
  let make cl =
    let name = Ident.get_class_ml_name cl.cc_ident 
    and tname = Ident.get_class_ml_jni_type_name cl.cc_ident 
    and java_name = Ident.get_class_java_signature cl.cc_ident in 
    let err = "``cast error'' : "^name^" ("^(java_name)^")" in
    let body = 
      <:expr< if not (Jni.is_instance_of $lid:java_obj$ $lid:clazz$)
      then failwith $str:err$ 
      else (Obj.magic $lid:java_obj$ : $lid:tname$) >> in
    let body = <:expr< fun ($lid:java_obj$ : Jni.obj) -> $body$ >> in
    let err = "Class not found : "^
      Ident.get_class_java_qualified_name cl.cc_ident ^"." in
    let body = <:expr< let $lid:clazz$ = 
      try Jni.find_class $str:java_name$ with
     _ -> failwith $str:err$ in $body$ >> in
    let name = "_"^tname^"_of_jni_obj" in
    [ <:str_item< value $lid:name$ = $body$ >> ]
  in
  P4helper.str_items (List.concat (List.map make cl_list))

let make_jnidowncast_sig cl_list =
  let make cl =
    let tname = Ident.get_class_ml_jni_type_name cl.cc_ident in
    let name = "_"^tname^"_of_jni_obj" in
    [ <:sig_item< value $lid:name$ : Jni.obj -> $lid:tname$ >> ] 
  in
  P4helper.sig_items (List.concat (List.map make cl_list))

let make_downcast cl_list =
  let java_obj = "java_obj" 
  and obj ="o"
  and clazz ="clazz" in
  let make cl =
    let name = Ident.get_class_ml_name cl.cc_ident 
    and tname = Ident.get_class_ml_jni_type_name cl.cc_ident 
    and wname = Ident.get_class_ml_wrapper_name cl.cc_ident 
    and sname = Ident.get_class_ml_name cl.cc_ident 
    and java_name = Ident.get_class_java_qualified_name cl.cc_ident in
    (let body = 
      <:expr< (new $lid:wname$ (Java.cast $str:java_name$ $lid:obj$) : $lid:sname$) >> in
    let body = <:expr< fun ($lid:obj$ : top) -> $body$ >> in
    let fname = name^"_of_top" in
    <:str_item< value $lid:fname$ = $body$ >>)
    :: [] (*
      (List.map
	 (fun s -> 
	   let sname = Ident.get_class_ml_name s.cc_ident in
	   let body = 
	     <:expr< (new $lid:wname$ ($lid:"_"^tname^"_of_jni_obj" $ $lid:obj$#_get_jniobj) : $lid:name$) >> in
	   let body = <:expr< fun ($lid:obj$ : $lid:sname$) -> $body$ >> in
	   let fname = name ^ "_of_" ^ sname in
	   <:str_item< value $lid:fname$ = $body$ >>)
	 cl.cc_all_inherited) *)
  in
  P4helper.str_items (List.concat (List.map make cl_list))

let make_downcast_sig cl_list =
  let make cl =
    let name = Ident.get_class_ml_name cl.cc_ident in
    (let fname = name^"_of_top" in
    <:sig_item< value $lid:fname$ : top -> $lid:name$ >>) 
    :: [] (*
      (List.map 
	 (fun s -> 
	   let sname = Ident.get_class_ml_name s.cc_ident in
	   let fname = name ^ "_of_" ^ sname in
	   <:sig_item< value $lid:fname$ : $lid:sname$ -> $lid:name$ >>) 
	 cl.cc_all_inherited) *)
  in
  P4helper.sig_items (List.concat (List.map make cl_list))


let make_instance_of cl_list =
  let java_obj = "java_obj" 
  and obj ="o"
  and clazz ="clazz" in
  let make cl =
    let ml_name = Ident.get_class_ml_name cl.cc_ident
    and java_name = Ident.get_class_java_qualified_name cl.cc_ident in
    let body = 
      <:expr< Java.instanceof $str:java_name$ $lid:obj$ >> in
    let body = <:expr< fun ($lid:obj$ : top) -> $body$ >> in
    let name = "_instance_of_"^ml_name in
    [ <:str_item< value $lid:name$ = $body$ >> ]
  in
  P4helper.str_items (List.concat (List.map make cl_list))

let make_instance_of_sig cl_list =
  let make cl =
    let ml_name = Ident.get_class_ml_name cl.cc_ident in
    let name = "_instance_of_"^ml_name in
    [ <:sig_item< value $lid:name$ : top -> bool >> ]
  in
  P4helper.sig_items (List.concat (List.map make cl_list))

let make_array cl_list =
  let make cl acc =
    let ml_name = Ident.get_class_ml_name cl.cc_ident in
    let name_new = Ident.get_class_ml_array_alloc_name cl.cc_ident
    and name_create = Ident.get_class_ml_array_init_name cl.cc_ident in
    let jniobj = <:expr< $lid:"jniobj"$ >> in
    let obj = <:expr< $lid:"obj"$ >> in
    let body_new = <:expr< 
      fun size -> 
	let java_obj = Jni.new_object_array size (Jni.find_class $str: Ident.get_class_java_signature cl.cc_ident $) in 
	new JniArray._Array 
	  Jni.get_object_array_element
	  Jni.set_object_array_element
	  (fun jniobj ->  new $lid: Ident.get_class_ml_wrapper_name cl.cc_ident $ $jniobj$) 
	  (fun obj -> $obj$ # $lid: Ident.get_class_ml_jni_accessor_method_name cl.cc_ident $)
	  java_obj >> 
    and body_create = <:expr< 
      fun size -> fun f ->
	let a = $lid:name_new$ size in
	do { for i = 0 to pred size do { a#set i (f i) }; a } >> in
     <:str_item< value $lid:name_new$ = $body_new$ >> :: <:str_item< value $lid:name_create$ = $body_create$ >> :: acc
  in
  P4helper.str_items (List.fold_right make cl_list [])

let make_array_sig cl_list =
  let make cl =
    let ml_name = Ident.get_class_ml_name cl.cc_ident in
    let name = Ident.get_class_ml_array_init_name cl.cc_ident in
    <:sig_item< value $lid:name$ : int -> (int -> $lid: Ident.get_class_ml_name cl.cc_ident$) ->
      JniArray.jArray $lid: Ident.get_class_ml_name cl.cc_ident$  >>
  in
  P4helper.sig_items (List.map make cl_list)
