module P = Process

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
  | `Error P.Invalid_prog -> assert false
  | `Ok proc ->
    match P.wait proc with
    | (`Ok _) as ok                  -> ok
    (* TODO: Convert (some) curl exit codes to variants *)
    | `Error (P.Fail (code, stderr)) -> `Error (code, stderr)
    | `Error (P.Signal     _)        -> assert false
    | `Error (P.Stop       _)        -> assert false
