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

let exec ~request:{R.url; R.meth; R.payload} =
  let prog = "curl" in
  let args =
    [ "-k"
    ; "-i"
    ; "-X"
    ; Http_method.to_string meth
    ; url
    ; "-d"
    ; sprintf "%S" payload  (* TODO: Test nested quoting *)
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
