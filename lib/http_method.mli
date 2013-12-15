type parse_error =
  | Not_supported

type t =
  | CONNECT
  | DELETE
  | GET
  | HEAD
  | OPTIONS
  | POST
  | PUT
  | TRACE

val to_string : t -> string

val of_string : string -> [ `Ok of t | `Error of parse_error ]
