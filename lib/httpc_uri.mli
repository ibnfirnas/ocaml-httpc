(*****************************************************************************)
(*                                                                           *)
(* http://www.w3.org/TR/uri-clarification/                                   *)
(*                                                                           *)
(* http://www.iana.org/assignments/uri-schemes/uri-schemes.xhtml             *)
(*                                                                           *)
(*****************************************************************************)

module Scheme_http :
sig
  type t
end

type t =
  | Http of Scheme_http.t

val to_string : t -> string

val make  : protocol : Httpc_protocol.t
         -> domain   : string
         -> port     : int
         -> path     : string list
         -> [ `Ok of t | `Error of [ `Domain of char | `Path of char ] ]
