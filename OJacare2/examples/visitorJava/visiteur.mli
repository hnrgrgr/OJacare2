type top;;
type _jni_jFormule;;
type _jni_jVisiteur;;
type _jni_jVisiteurTS;;
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
class visiteurTS : unit -> jVisiteurTS;;
class virtual _stub_jFormule :
  unit ->
    object
      method _get_jni_jFormule : _jni_jFormule
      method virtual accepte : jVisiteur -> unit
    end;;
class virtual _stub_jVisiteur :
  unit ->
    object
      method _get_jni_jVisiteur : _jni_jVisiteur
      method virtual visite_var : string -> unit
      method virtual visite_ou : jFormule -> jFormule -> unit
      method virtual visite_et : jFormule -> jFormule -> unit
      method virtual visite_non : jFormule -> unit
      method virtual visite_cst : bool -> unit
    end;;
