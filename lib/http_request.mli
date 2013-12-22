type t

val make  : uri     : Uri.t
         -> meth    : Http_method.t
         -> payload : string
         -> t

val send : t -> [ `Ok of Http_response.t | `Error of int * string ]
