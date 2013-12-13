module Request :
sig
  type protocol =
    | Http
    | Https

  type meth =
    | Delete
    | Get
    | Head
    | Options
    | Post
    | Put

  type t

  val make  : protocol : protocol
           -> hostname : string
           -> port     : int
           -> path     : string list
           -> meth     : meth
           -> payload  : string
           -> t
end

val exec : request:Request.t -> [ `Ok of string | `Error of int * string ]
