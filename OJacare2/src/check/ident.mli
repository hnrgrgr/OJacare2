
(* le type des identifiants de classe de l'IDL *)
type clazz
type mmethod

val make_class_ident: string list -> Idl.def -> clazz
val make_init_method_id: clazz -> Idl.init -> mmethod
val make_field_method_id: static:bool -> clazz -> Idl.field -> mmethod option * mmethod
val make_method_id: static:bool -> clazz -> Idl.mmethod -> mmethod

val is_interface: clazz -> bool
val is_callback: clazz -> bool

val get_class_java_package: clazz -> string list
val get_class_java_name: clazz -> string
val get_class_ml_name: clazz -> string
val get_class_ml_stub_name: clazz -> string
val get_class_ml_name_location: clazz -> Loc.t
val get_class_ml_interface_init_name: clazz -> string

val get_method_java_name: mmethod -> string
val get_method_ml_name: mmethod -> string
val get_method_ml_name_location: mmethod -> Loc.t
val get_method_ml_id : mmethod -> int

val compare_clazz: clazz -> clazz -> int
val compare_method: mmethod -> mmethod -> int

(* commmun camlgen javagen*)
val get_class_java_oj_name: clazz -> string
val get_class_java_oj_cb_name: clazz -> string
val get_class_java_oj_icb_name: clazz -> string
val get_class_java_jinst_name: clazz -> string
val get_class_java_qualified_name: clazz -> string
val get_class_java_icb_qualified_name: clazz -> string
val get_class_java_cb_qualified_name: clazz -> string
val get_class_java_stub_name: clazz -> string
val get_class_java_qualified_stub_name: clazz -> string
val get_class_java_callback_package: clazz -> string list
val get_class_java_callback_package_name: clazz -> string
val get_method_ml_stub_name: mmethod -> string

(* spécifique camlgen *)
val get_class_java_signature: clazz -> string
val get_class_java_stub_signature: clazz -> string
val get_class_ml_jni_type_name: clazz -> string
val get_class_ml_jni_cb_type_name: clazz -> string
val get_class_ml_jni_icb_type_name: clazz -> string
val get_class_ml_wrapper_name: clazz -> string
val get_class_ml_stub_wrapper_name: clazz -> string

val get_class_ml_jni_accessor_method_name: clazz -> string
val get_class_ml_allocator_name: clazz -> string
val get_class_ml_stub_allocator_name: clazz -> string

val get_method_ml_init_name: mmethod -> string
val get_method_ml_init_stub_name: mmethod -> string

val get_class_ml_array_alloc_name: clazz -> string
val get_class_ml_array_descr: clazz -> string
val get_class_ml_array_unwrap_name : clazz -> string
