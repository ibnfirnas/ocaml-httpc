open Printf

module L = ListLabels
module S = StringLabels

let protocol_of_string s =
  match Httpc.Protocol.of_string s with
  | `Ok p -> p
  | `Error (Httpc.Protocol.Unknown p) -> eprintf "Unsupported protocol: %S" p; exit 1

let method_of_string s =
  match Httpc.Method.of_string s with
  | `Ok m -> m
  | `Error Httpc.Method.Not_supported ->
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
  match Httpc.Uri.make ~protocol ~domain ~port ~path with
  | `Error (`Domain c) ->
    eprintf "Illegal character in domain: %C\n" c;
    exit 1
  | `Error (`Path c) ->
    eprintf "Illegal character in path: %C\n" c;
    exit 1
  | `Ok uri ->
    let module P = Httpc.Response in
    let module Q = Httpc.Request in
    let module H = Httpc.Header in
    match Q.send (Q.make ~uri ~meth ~payload) with
    | `Ok p -> begin
      ( printf "~~~ OK ~~~\n"
      ; printf "BEGIN RAW\n"
      ; printf "%s\n" (p.P.raw)
      ; printf "END RAW\n\n"
      ; printf "BEGIN PARSED\n"
      ; printf "  HTTP VSN: %s\n" (p.P.http_vsn)
      ; printf "  STATUS CODE: %d\n" (p.P.status_code)
      ; printf "  REASON PHRASE: %s\n" (p.P.reason_phrase)
      ; printf "  BEGIN HEADERS\n"
      ; L.iter p.P.headers ~f:(fun h -> printf "    %s" (H.to_string h))
      ; printf "  END HEADERS\n"
      ; printf "  BODY: %s\n" p.P.body
      ; printf "END PARSED\n"
      )
      end
    | `Error (code, err) ->
      eprintf "~~~ ERROR (%d) ~~~\n%s\n" code err
