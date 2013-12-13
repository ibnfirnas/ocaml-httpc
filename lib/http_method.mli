type parse_error =
  | Not_supported

type t =
  | DELETE
  | GET
  | HEAD
  | OPTIONS
  | POST
  | PUT

val to_string : t -> string

val of_string : string -> [ `Ok of t | `Error of parse_error ]
