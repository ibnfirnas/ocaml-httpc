open Printf

module Request :
sig
  type t =
    { url     : string
    ; meth    : Http_method.t
    ; payload : string
    }

  val make  : uri     : Uri.t
           -> meth    : Http_method.t
           -> payload : string
           -> t
end = struct
  module S = StringLabels

  type t =
    { url     : string
    ; meth    : Http_method.t
    ; payload : string
    }

  let make ~uri ~meth ~payload =
    let url = Uri.to_string uri in
    { url
    ; meth
    ; payload
    }
end

module P = Process
module R = Request

(* TODO: Support timeouts *)

let exec ~request:{R.url; R.meth; R.payload} =
  let meth = Http_method.to_string meth in
  let payload = sprintf "%S" payload in  (* TODO: Test nested quoting *)
  let prog = "curl" in
  let args =
    (* -k Do not validate SSL certificate *)
    [ "--insecure"

    (* -i Include the HTTP-header in the output *)
    ; "--include"

    (* -X Specifies a custom request method to use *)
    ; "--request"; meth

    ; url

    (* -d Posts data exactly as specified, no extra processing *)
    ; "--data-binary"; payload
    ]
  in
  match P.create ~prog ~args with
  | `Error P.Invalid_prog -> assert false
  | `Ok proc ->
    match P.wait proc with
    | `Ok output                     -> `Ok (Http_response.of_string output)
    (* TODO: Convert (some) curl exit codes to variants *)
    | `Error (P.Fail (code, stderr)) -> `Error (code, stderr)
    | `Error (P.Signal     _)        -> assert false
    | `Error (P.Stop       _)        -> assert false
