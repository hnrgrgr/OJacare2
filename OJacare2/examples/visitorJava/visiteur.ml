type top = java'lang'Object java_instance;;
exception Null_object of string;;
type _jni_jFormule = fr'upmc'infop6'mlo'Formule java_instance;;
type _jni_jVisiteur = fr'upmc'infop6'mlo'Visiteur java_instance;;
type _jni_jVisiteurTS = fr'upmc'infop6'mlo'VisiteurTS java_instance;;

class type jFormule =
  object
    method _get_jni_jFormule : _jni_jFormule
    method accepte : jVisiteur -> unit
  end
and jVisiteur =
  object
    method _get_jni_jVisiteur : _jni_jVisiteur
    method visite_cst : bool -> unit
    method visite_non : jFormule -> unit
    method visite_et : jFormule -> jFormule -> unit
    method visite_ou : jFormule -> jFormule -> unit
    method visite_var : string -> unit
  end
and jVisiteurTS =
  object
    inherit jVisiteur
    method _get_jni_jVisiteurTS : _jni_jVisiteurTS
    method get_res : unit -> string
  end;;
class _capsule_jFormule (jni_ref : _jni_jFormule) =
  let _ =
    if Java.is_null jni_ref
    then raise (Null_object "fr/upmc/infop6/mlo/Formule")
    else ()
  in
    object (self)
      method accepte =
        fun (_p0 : jVisiteur) ->
          let _p0 = _p0#_get_jni_jVisiteur
          in
            Java.call
              "fr.upmc.infop6.mlo.Formule.accepte(fr.upmc.infop6.mlo.Visiteur):void"
              jni_ref _p0
      method _get_jni_jFormule = jni_ref
    end
and _capsule_jVisiteur (jni_ref : _jni_jVisiteur) =
  let _ =
    if Java.is_null jni_ref
    then raise (Null_object "fr/upmc/infop6/mlo/Visiteur")
    else ()
  in
    object (self)
      method visite_var =
        fun _p0 ->
          let _p0 = JavaString.of_string _p0
          in
            Java.call
              "fr.upmc.infop6.mlo.Visiteur.visite_var(java.lang.String):void"
              jni_ref _p0
      method visite_ou =
        fun (_p0 : jFormule) (_p1 : jFormule) ->
          let _p1 = _p1#_get_jni_jFormule in
          let _p0 = _p0#_get_jni_jFormule
          in
            Java.call
              "fr.upmc.infop6.mlo.Visiteur.visite_ou(fr.upmc.infop6.mlo.Formule,fr.upmc.infop6.mlo.Formule):void"
              jni_ref _p0 _p1
      method visite_et =
        fun (_p0 : jFormule) (_p1 : jFormule) ->
          let _p1 = _p1#_get_jni_jFormule in
          let _p0 = _p0#_get_jni_jFormule
          in
            Java.call
              "fr.upmc.infop6.mlo.Visiteur.visite_et(fr.upmc.infop6.mlo.Formule,fr.upmc.infop6.mlo.Formule):void"
              jni_ref _p0 _p1
      method visite_non =
        fun (_p0 : jFormule) ->
          let _p0 = _p0#_get_jni_jFormule
          in
            Java.call
              "fr.upmc.infop6.mlo.Visiteur.visite_non(fr.upmc.infop6.mlo.Formule):void"
              jni_ref _p0
      method visite_cst =
        fun _p0 ->
          let _p0 = _p0
          in
            Java.call "fr.upmc.infop6.mlo.Visiteur.visite_cst(boolean):void"
              jni_ref _p0
      method _get_jni_jVisiteur = jni_ref
    end
and _capsule_jVisiteurTS (jni_ref : _jni_jVisiteurTS) =
  let _ =
    if Java.is_null jni_ref
    then raise (Null_object "fr/upmc/infop6/mlo/VisiteurTS")
    else ()
  in
    object (self)
      method get_res =
        fun () ->
          JavaString.to_string
            (Java.call
               "fr.upmc.infop6.mlo.VisiteurTS.get_res():java.lang.String"
               jni_ref)
      method visite_var =
        fun _p0 ->
          let _p0 = JavaString.of_string _p0
          in
            Java.call
              "fr.upmc.infop6.mlo.Visiteur.visite_var(java.lang.String):void"
              jni_ref _p0
      method visite_ou =
        fun (_p0 : jFormule) (_p1 : jFormule) ->
          let _p1 = _p1#_get_jni_jFormule in
          let _p0 = _p0#_get_jni_jFormule
          in
            Java.call
              "fr.upmc.infop6.mlo.Visiteur.visite_ou(fr.upmc.infop6.mlo.Formule,fr.upmc.infop6.mlo.Formule):void"
              jni_ref _p0 _p1
      method visite_et =
        fun (_p0 : jFormule) (_p1 : jFormule) ->
          let _p1 = _p1#_get_jni_jFormule in
          let _p0 = _p0#_get_jni_jFormule
          in
            Java.call
              "fr.upmc.infop6.mlo.Visiteur.visite_et(fr.upmc.infop6.mlo.Formule,fr.upmc.infop6.mlo.Formule):void"
              jni_ref _p0 _p1
      method visite_non =
        fun (_p0 : jFormule) ->
          let _p0 = _p0#_get_jni_jFormule
          in
            Java.call
              "fr.upmc.infop6.mlo.Visiteur.visite_non(fr.upmc.infop6.mlo.Formule):void"
              jni_ref _p0
      method visite_cst =
        fun _p0 ->
          let _p0 = _p0
          in
            Java.call "fr.upmc.infop6.mlo.Visiteur.visite_cst(boolean):void"
              jni_ref _p0
      method _get_jni_jVisiteurTS = jni_ref
      method _get_jni_jVisiteur = (jni_ref :> _jni_jVisiteur)
    end
and virtual _souche_jFormule = let jni_ref = ref Java.null
  in
    object (self)
      initializer
        (jni_ref :=
           Java.proxy "fr.upmc.infop6.mlo.Formule"
             (object
                method accepte =
                  fun (_p0 : _jni_jVisiteur) ->
                    let _p0 : jVisiteur = new _capsule_jVisiteur _p0
                    in self#accepte _p0
              end);
         if Java.is_null !jni_ref
         then raise (Null_object "callback.fr.upmc.infop6.mlo.CB_Formule")
         else ())
      method virtual accepte : jVisiteur -> unit
      method _get_jni_jFormule = (!jni_ref :> _jni_jFormule)
    end
and virtual _souche_jVisiteur = let jni_ref = ref Java.null
  in
    object (self)
      initializer
        (jni_ref :=
           Java.proxy "fr.upmc.infop6.mlo.Visiteur"
             (object
                method visite_var =
                  fun _p0 ->
                    let _p0 = JavaString.to_string _p0 in self#visite_var _p0
                method visite_ou =
                  fun (_p0 : _jni_jFormule) (_p1 : _jni_jFormule) ->
                    let _p1 : jFormule = new _capsule_jFormule _p1 in
                    let _p0 : jFormule = new _capsule_jFormule _p0
                    in self#visite_ou _p0 _p1
                method visite_et =
                  fun (_p0 : _jni_jFormule) (_p1 : _jni_jFormule) ->
                    let _p1 : jFormule = new _capsule_jFormule _p1 in
                    let _p0 : jFormule = new _capsule_jFormule _p0
                    in self#visite_et _p0 _p1
                method visite_non =
                  fun (_p0 : _jni_jFormule) ->
                    let _p0 : jFormule = new _capsule_jFormule _p0
                    in self#visite_non _p0
                method visite_cst =
                  fun _p0 -> let _p0 = _p0 in self#visite_cst _p0
              end);
         if Java.is_null !jni_ref
         then raise (Null_object "callback.fr.upmc.infop6.mlo.CB_Visiteur")
         else ())
      method virtual visite_var : string -> unit
      method virtual visite_ou : jFormule -> jFormule -> unit
      method virtual visite_et : jFormule -> jFormule -> unit
      method virtual visite_non : jFormule -> unit
      method virtual visite_cst : bool -> unit
      method _get_jni_jVisiteur = (!jni_ref :> _jni_jVisiteur)
    end

let jFormule_of_top (o : top) : jFormule =
  new _capsule_jFormule (Java.cast "fr.upmc.infop6.mlo.Formule" o);;
let jVisiteur_of_top (o : top) : jVisiteur =
  new _capsule_jVisiteur (Java.cast "fr.upmc.infop6.mlo.Visiteur" o);;
let jVisiteurTS_of_top (o : top) : jVisiteurTS =
  new _capsule_jVisiteurTS (Java.cast "fr.upmc.infop6.mlo.VisiteurTS" o);;
let _instance_of_jFormule (o : top) =
  Java.instanceof "fr.upmc.infop6.mlo.Formule" o;;
let _instance_of_jVisiteur (o : top) =
  Java.instanceof "fr.upmc.infop6.mlo.Visiteur" o;;
let _instance_of_jVisiteurTS (o : top) =
  Java.instanceof "fr.upmc.infop6.mlo.VisiteurTS" o;;
let _new_jFormule_array size =
  let java_obj =
    Java.make_array "fr.upmc.infop6.mlo.Formule[]" (Int32.of_int size)
  in
    OjArray.wrap_reference_array java_obj (fun obj -> obj#_get_jni_jFormule)
      (fun r -> new _capsule_jFormule r);;
let _new_jVisiteur_array size =
  let java_obj =
    Java.make_array "fr.upmc.infop6.mlo.Visiteur[]" (Int32.of_int size)
  in
    OjArray.wrap_reference_array java_obj (fun obj -> obj#_get_jni_jVisiteur)
      (fun r -> new _capsule_jVisiteur r);;
let _new_jVisiteurTS_array size =
  let java_obj =
    Java.make_array "fr.upmc.infop6.mlo.VisiteurTS[]" (Int32.of_int size)
  in
    OjArray.wrap_reference_array java_obj
      (fun obj -> obj#_get_jni_jVisiteurTS)
      (fun r -> new _capsule_jVisiteurTS r);;
class visiteurTS () =
  let java_obj = Java.make "fr.upmc.infop6.mlo.VisiteurTS()" ()
  in object (self) inherit _capsule_jVisiteurTS java_obj end;;
class virtual _stub_jFormule () =
  object (self) inherit _souche_jFormule end;;
class virtual _stub_jVisiteur () =
  object (self) inherit _souche_jVisiteur end;;
