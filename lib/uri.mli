module Scheme_http :
sig
  type t
end

type t =
  | Http of Scheme_http.t

val to_string : t -> string

val make  : protocol : Protocol.t
         -> domain   : string
         -> port     : int
         -> path     : string list
         -> [ `Ok of t | `Error of [ `Domain of char | `Path of char ] ]
