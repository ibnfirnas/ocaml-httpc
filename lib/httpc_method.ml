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

let to_string = function
  | CONNECT -> "CONNECT"
  | DELETE  -> "DELETE"
  | GET     -> "GET"
  | HEAD    -> "HEAD"
  | OPTIONS -> "OPTIONS"
  | POST    -> "POST"
  | PUT     -> "PUT"
  | TRACE   -> "TRACE"

let of_string s =
  match String.uppercase s with
  | "CONNECT" -> `Ok CONNECT
  | "DELETE"  -> `Ok DELETE
  | "GET"     -> `Ok GET
  | "HEAD"    -> `Ok HEAD
  | "OPTIONS" -> `Ok OPTIONS
  | "POST"    -> `Ok POST
  | "PUT"     -> `Ok PUT
  | "TRACE"   -> `Ok TRACE
  | _         -> `Error Not_supported
