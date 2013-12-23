type t

val make  : uri     : Httpc_uri.t
         -> meth    : Httpc_method.t
         -> payload : string
         -> t

val send : t -> [ `Ok of Httpc_response.t | `Error of int * string ]
