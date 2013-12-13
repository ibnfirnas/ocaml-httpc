module Request :
sig
  type t

  val make  : uri     : Uri.t
           -> meth    : Http_method.t
           -> payload : string
           -> t
end

val exec : request:Request.t -> [ `Ok    of Http_response.t
                                | `Error of int * string
                                ]
