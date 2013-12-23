type parse_error =
  | Unknown of string

type t =
  | Http
  | Https

let to_string = function
  | Http  -> "http"
  | Https -> "https"

let of_string s =
  match String.lowercase s with
  | "https" -> `Ok Https
  | "http"  -> `Ok Http
  | p       -> `Error (Unknown p)
