type parse_error =
  | Unknown of string

type t =
  | Http
  | Https

val to_string : t -> string

val of_string : string -> [ `Ok of t | `Error of parse_error ]
