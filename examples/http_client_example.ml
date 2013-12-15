open Printf

module L = ListLabels
module S = StringLabels

let protocol_of_string s =
  match Protocol.of_string s with
  | `Ok p -> p
  | `Error (Protocol.Unknown p) -> eprintf "Unsupported protocol: %S" p; exit 1

let method_of_string s =
  match Http_method.of_string s with
  | `Ok m -> m
  | `Error Http_method.Not_supported ->
    ( eprintf "Unsupported method: %S\n" s
    ; exit 1
    )

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
    let module P = Http_response in
    let request = Http_client.Request.make ~uri ~meth ~payload in
    match Http_client.exec ~request with
    | `Ok p -> begin
      ( printf "~~~ OK ~~~\n"
      ; printf "BEGIN RAW\n"
      ; printf "%s\n" (p.P.raw)
      ; printf "END RAW\n\n"
      ; printf "BEGIN PARSED\n"
      ; printf "  HTTP VSN: %s\n" (p.P.http_vsn)
      ; printf "  STATUS CODE: %d\n" (p.P.status_code)
      ; printf "  REASON PHRASE: %s\n" (p.P.reason_phrase)
      ; printf "  HEADERS:\n"
      ; L.iter p.P.headers ~f:(
          fun (n, v) ->
            ( printf "     NAME: %s\n" n
            ; printf "    VALUE: %s\n\n" v
            )
        )
      ; printf "  BODY: %s\n" p.P.body
      ; printf "END PARSED\n"
      )
      end
    | `Error (code, err) ->
      eprintf "~~~ ERROR (%d) ~~~\n%s\n" code err
