open Printf

module S = StringLabels

let protocol_of_string s =
  match Protocol.of_string s with
  | `Ok p -> p
  | `Error (Protocol.Unknown p) -> eprintf "Unsupported protocol: %S" p; exit 1

let method_of_string s =
  match S.lowercase s with
  | "delete"  -> Httpc.Request.Delete
  | "get"     -> Httpc.Request.Get
  | "head"    -> Httpc.Request.Head
  | "options" -> Httpc.Request.Options
  | "post"    -> Httpc.Request.Post
  | "put"     -> Httpc.Request.Put
  | m         -> eprintf "Unsupported method: %S\n" m; exit 1

let () =
  let protocol = Sys.argv.(1) |> protocol_of_string in
  let domain   = Sys.argv.(2) in
  let port     = Sys.argv.(3) |> int_of_string in
  let path     = Sys.argv.(4) |> Str.split (Str.regexp "/") in
  let meth     = Sys.argv.(5) |> method_of_string in
  let payload  = Sys.argv.(6) in
  let request =
    Httpc.Request.make ~protocol ~domain ~port ~path ~meth ~payload
  in
  match Httpc.exec ~request with
  | `Ok out            -> printf  "~~~ OK ~~~\n%s\n" out
  | `Error (code, err) -> eprintf "~~~ ERROR (%d) ~~~\n%s\n" code err
