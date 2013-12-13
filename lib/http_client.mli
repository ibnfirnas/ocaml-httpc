module Request :
sig
  type t

  val make  : uri     : Uri.t
           -> meth    : Http_method.t
           -> payload : string
           -> t
end

val exec : request:Request.t -> [ `Ok of string | `Error of int * string ]
