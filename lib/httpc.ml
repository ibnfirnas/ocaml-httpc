open Printf

module Request :
sig
  type meth =
    | Delete
    | Get
    | Head
    | Options
    | Post
    | Put

  type t =
    { url     : string
    ; meth    : meth
    ; payload : string
    }

  val make  : protocol : Protocol.t
           -> hostname : string
           -> port     : int
           -> path     : string list
           -> meth     : meth
           -> payload  : string
           -> t
end = struct
  module S = StringLabels

  type meth =
    | Delete
    | Get
    | Head
    | Options
    | Post
    | Put

  type t =
    { url     : string
    ; meth    : meth
    ; payload : string
    }

  let make_url ~protocol ~hostname ~port ~path =
    (* TODO: Validation *)
    let protocol = Protocol.to_string protocol in
    let parts = (sprintf "%s://%s:%d" protocol hostname port) :: path in
    S.concat parts ~sep:"/"

  let make ~protocol ~hostname ~port ~path ~meth ~payload =
    let url = make_url ~protocol ~hostname ~port ~path in
    { url
    ; meth
    ; payload
    }
end

module P = Process
module R = Request

let exec ~request:{R.url; R.meth; R.payload} =
  let method_to_string = function
    | R.Delete  -> "DELETE"
    | R.Get     -> "GET"
    | R.Head    -> "HEAD"
    | R.Options -> "OPTIONS"
    | R.Post    -> "POST"
    | R.Put     -> "PUT"
  in
  let prog = "curl" in
  let args =
    [ "-k"
    ; "-i"
    ; "-X"
    ; method_to_string meth
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
