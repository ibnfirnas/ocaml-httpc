module Request :
sig
  type protocol =
    | Http
    | Https

  type meth =
    | Get

  type t

  val make  : protocol : protocol
           -> hostname : string
           -> port     : int
           -> path     : string list
           -> meth     : meth
           -> t
end

val exec : request:Request.t -> [ `Ok of string | `Error of int * string ]
