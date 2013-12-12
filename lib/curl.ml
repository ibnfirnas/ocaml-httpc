module P = Process
module R = Result

let get ~url =
  let prog = "curl" in
  let args =
    [ "-k"
    ; "-i"
    ; "-X"
    ; "GET"
    ; url
    ]
  in
  match P.create ~prog ~args with
  | R.Error P.Invalid_prog -> assert false
  | R.Ok proc ->
    match P.wait proc with
    | (R.Ok _) as ok                  -> ok
    (* TODO: Convert (some) curl exit codes to variants *)
    | R.Error (P.Fail (code, stderr)) -> R.Error (code, stderr)
    | R.Error (P.Signal     _)        -> assert false
    | R.Error (P.Stop       _)        -> assert false
