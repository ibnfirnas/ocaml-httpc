open Printf

module S = StringLabels

let protocol_of_string s =
  match Protocol.of_string s with
  | `Ok p -> p
  | `Error (Protocol.Unknown p) -> eprintf "Unsupported protocol: %S" p; exit 1

let method_of_string s =
  match S.lowercase s with
  | "delete"  -> Http_client.Request.Delete
  | "get"     -> Http_client.Request.Get
  | "head"    -> Http_client.Request.Head
  | "options" -> Http_client.Request.Options
  | "post"    -> Http_client.Request.Post
  | "put"     -> Http_client.Request.Put
  | m         -> eprintf "Unsupported method: %S\n" m; exit 1

let () =
  let protocol = Sys.argv.(1) |> protocol_of_string in
  let domain   = Sys.argv.(2) in
  let port     = Sys.argv.(3) |> int_of_string in
  let path     = Sys.argv.(4) |> Str.split (Str.regexp "/") in
  let meth     = Sys.argv.(5) |> method_of_string in
  let payload  = Sys.argv.(6) in
  match Uri.make ~protocol ~domain ~port ~path with
  | `Error (`Domain c) ->
    eprintf "Illegal character in domain: %C\n" c;
    exit 1
  | `Error (`Path c) ->
    eprintf "Illegal character in path: %C\n" c;
    exit 1
  | `Ok uri ->
    let request = Http_client.Request.make ~uri ~meth ~payload in
    match Http_client.exec ~request with
    | `Ok out            -> printf  "~~~ OK ~~~\n%s\n" out
    | `Error (code, err) -> eprintf "~~~ ERROR (%d) ~~~\n%s\n" code err
