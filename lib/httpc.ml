open Printf

module Request :
sig
  type protocol =
    | Http
    | Https

  type meth =
    | Get

  type t =
    { url     : string
    ; meth    : meth
    }

  val make  : protocol : protocol
           -> hostname : string
           -> port     : int
           -> path     : string list
           -> meth     : meth
           -> t
end = struct
  module S = StringLabels

  type protocol =
    | Http
    | Https

  type meth =
    | Get

  type t =
    { url     : string
    ; meth    : meth
    }

  let protocol_to_string = function
    | Http  -> "http"
    | Https -> "https"

  let make_url ~protocol ~hostname ~port ~path =
    (* TODO: Validation *)
    let protocol = protocol_to_string protocol in
    let parts = (sprintf "%s://%s:%d" protocol hostname port) :: path in
    S.concat parts ~sep:"/"

  let make ~protocol ~hostname ~port ~path ~meth =
    let url = make_url ~protocol ~hostname ~port ~path in
    { url
    ; meth
    }
end

module P = Process
module R = Request

let exec ~request:{R.url; R.meth} =
  let method_to_string = function
    | R.Get    -> "GET"
  in
  let prog = "curl" in
  let args =
    [ "-k"
    ; "-i"
    ; "-X"
    ; method_to_string meth
    ; url
    ]
  in
  match P.create ~prog ~args with
  | `Error P.Invalid_prog -> assert false
  | `Ok proc ->
    match P.wait proc with
    | (`Ok _) as ok                  -> ok
    (* TODO: Convert (some) curl exit codes to variants *)
    | `Error (P.Fail (code, stderr)) -> `Error (code, stderr)
    | `Error (P.Signal     _)        -> assert false
    | `Error (P.Stop       _)        -> assert false
