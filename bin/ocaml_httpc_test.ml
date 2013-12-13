open Printf

module S = StringLabels

let protocol_of_string s =
  match S.lowercase s with
  | "https" -> Httpc.Request.Https
  | "http"  -> Httpc.Request.Http
  | _       -> assert false

let method_of_string s =
  match S.lowercase s with
  | "delete"  -> Httpc.Request.Delete
  | "get"     -> Httpc.Request.Get
  | "head"    -> Httpc.Request.Head
  | "options" -> Httpc.Request.Options
  | "post"    -> Httpc.Request.Post
  | "put"     -> Httpc.Request.Put
  | _         -> assert false

let () =
  let protocol = Sys.argv.(1) |> protocol_of_string in
  let hostname = Sys.argv.(2) in
  let port     = Sys.argv.(3) |> int_of_string in
  let path     = Sys.argv.(4) |> Str.split (Str.regexp "/") in
  let meth     = Sys.argv.(5) |> method_of_string in
  let payload  = Sys.argv.(6) in
  let request =
    Httpc.Request.make ~protocol ~hostname ~port ~path ~meth ~payload
  in
  match Httpc.exec ~request with
  | `Ok out            -> printf  "~~~ OK ~~~\n%s\n" out
  | `Error (code, err) -> eprintf "~~~ ERROR (%d) ~~~\n%s\n" code err
