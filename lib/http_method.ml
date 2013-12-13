module S = StringLabels

type parse_error =
  | Not_supported

type t =
  | DELETE
  | GET
  | HEAD
  | OPTIONS
  | POST
  | PUT

let to_string = function
  | DELETE  -> "DELETE"
  | GET     -> "GET"
  | HEAD    -> "HEAD"
  | OPTIONS -> "OPTIONS"
  | POST    -> "POST"
  | PUT     -> "PUT"

let of_string s =
  match S.uppercase s with
  | "DELETE"  -> `Ok DELETE
  | "GET"     -> `Ok GET
  | "HEAD"    -> `Ok HEAD
  | "OPTIONS" -> `Ok OPTIONS
  | "POST"    -> `Ok POST
  | "PUT"     -> `Ok PUT
  | _         -> `Error Not_supported
