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
    (* (SSL) This option explicitly allows curl to perform "insecure" SSL
     * connections and transfers. All SSL connections are attempted to be made
     * secure by using the CA certificate bundle installed by default. This
     * makes all connections considered "insecure" fail unless -k, --insecure is
     * used.
     *
     * SHORT: -k
     * *)
    [ "--insecure"

    (* (HTTP) Include the HTTP-header in the output. The HTTP-header includes
     * things like server-name, date of the document, HTTP-version and more...
     *
     * SHORT: -i
     * *)
    ; "--include"

    (* When used, it disables all internal HTTP decoding of content or transfer
     * encodings and instead makes them passed on unaltered, raw. (Added in
     * 7.16.2)
     *
     * NO SHORT
     * *)
    ; "--raw"

    (* (HTTP) Specifies a custom request method to use when communicating with
     * the HTTP server. The specified request will be used instead of the method
     * otherwise used (which defaults to GET).
     *
     * If this option is used several times, the last one will be used.
     *
     * SHORT: -X
     * *)
    ; "--request"; meth

    (* Endpoint *)
    ; url

    (* (HTTP) This posts data exactly as specified with no extra processing
     * whatsoever.
     *
     * If you start the data with the letter @, the rest should be a filename.
     * TODO: Maybe check that given data does NOT start with "@"?
     *
     * Data is posted in a similar manner as --data-ascii does, except that
     * newlines are preserved and conversions are never done.
     *
     * If this option is used several times, the ones following the first will
     * append data as described in -d, --data.
     *
     * SHORT: -d
     * *)
    ; "--data-binary"; payload
    ]
  in
  match P.create ~prog ~args with
  | `Error P.Invalid_prog -> assert false
  | `Ok proc ->
    match P.wait proc with
    | `Ok output                     -> `Ok (Http_response.of_string output)

    (* TODO: Convert (some) curl exit codes to variants *)

    (* Unsupported protocol. *)
    | `Error (P.Fail (1   , _))      -> assert false

    | `Error (P.Fail (code, stderr)) -> `Error (code, stderr)
    | `Error (P.Signal     _)        -> assert false
    | `Error (P.Stop       _)        -> assert false
