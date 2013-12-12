open Printf

module B = Buffer
module S = StringLabels
module U = UnixLabels

module Result =
struct
  type ('ok, 'error) t =
    | Ok    of 'ok
    | Error of 'error
end

module Process :
sig
  type process_error =
    | Fail   of int * string
    | Signal of int
    | Stop   of int

  type argument_error =
    | Invalid_prog

  type result =
    (string, process_error) Result.t

  type t

  val create : prog:string -> args:string list -> (t, argument_error) Result.t

  val wait : t -> result
end = struct
  type process_error =
    | Fail   of int * string
    | Signal of int
    | Stop   of int

  type argument_error =
    | Invalid_prog

  type result =
    (string, process_error) Result.t

  type t =
    { prog   : string
    ; args   : string list
    ; stdout : in_channel
    ; stdin  : out_channel
    ; stderr : in_channel
    }

  let read_ic ~ic =
    let buffer = B.create 32 in
    let rec read () =
      try
        B.add_channel buffer ic 1;
        read ()
      with End_of_file ->
        ()
    in
    read ();
    B.contents buffer

  let string_find s c =
    try Some (String.index s c) with Not_found -> None

  let wait {stdout; stdin; stderr; _} =
    let stdout_content = read_ic ~ic:stdout in
    let stderr_content = read_ic ~ic:stderr in
    match U.close_process_full (stdout, stdin, stderr) with
    | U.WEXITED   0 -> Result.Ok                stdout_content
    | U.WEXITED   n -> Result.Error (Fail   (n, stderr_content))
    | U.WSIGNALED n -> Result.Error (Signal  n)
    | U.WSTOPPED  n -> Result.Error (Stop    n)

  let create ~prog ~args =
    match string_find prog ' ' with
    | Some _ -> Result.Error Invalid_prog
    | None ->
      let cmd = S.concat (prog :: args) ~sep:" " in
      let env = U.environment () in
      let stdout, stdin, stderr = U.open_process_full cmd ~env in
      let t =
        { prog
        ; args
        ; stdout
        ; stdin
        ; stderr
        }
      in
      Result.Ok t
end

module Curl =
struct
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
      | R.Error (P.Fail (code, stderr)) -> R.Error (code, stderr)
      | R.Error (P.Signal     _)        -> assert false
      | R.Error (P.Stop       _)        -> assert false
end

let () =
  let module P = Process in
  let module R = Result in
  let url = Sys.argv.(1) in
  match Curl.get ~url with
  | R.Ok output            -> printf  "~~~ OK ~~~\n%s\n" output
  | R.Error (code, stderr) -> eprintf "~~~ ERROR (%d) ~~~\n%s\n" code stderr
