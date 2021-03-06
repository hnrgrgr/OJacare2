open Camlp4.PreCast

val make_top: unit -> Ast.str_item
val make_exc: unit -> Ast.str_item
val make_jni_type: Cidl.clazz list -> Ast.str_item
val make_jni_CB_type: Cidl.clazz list -> Ast.str_item
val make_jni_ICB_type: Cidl.clazz list -> Ast.str_item
val make_jni_type_sig: Cidl.clazz list -> Ast.sig_item
(** G�n�re l'ast correspondant � la d�claration du type JNI de la classe *)

val make_class_type: callback:bool -> Cidl.clazz list -> (string * bool * Ast.class_type) list
(** G�n�re le 'class type' de la classe : nom, abstract, ast *)

val make_wrapper: callback:bool -> Cidl.clazz list -> (string * bool * Ast.class_expr) list
val make_wrapper_sig:  Cidl.clazz list -> Ast.sig_item
(** G�n�re les cellules capsule et/ou souche *)

val make_downcast: Cidl.clazz list -> Ast.str_item
val make_downcast_sig: Cidl.clazz list -> Ast.sig_item
val make_instance_of: Cidl.clazz list -> Ast.str_item
val make_instance_of_sig: Cidl.clazz list -> Ast.sig_item
(** Engendre les fonctions de cast *)

val make_array: Cidl.clazz list -> Ast.str_item
val make_array_sig: Cidl.clazz list -> Ast.sig_item
(** Engendre les fonctions de conxtruction de tableaux *)

val make_unwrap_array: Cidl.clazz list -> Ast.str_item
val make_unwrap_array_sig: Cidl.clazz list -> Ast.sig_item
(** Engendre les fonctions de d�sencapsulation de tableaux *)
