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
  type error =
    | Invalid_exe
    | Fail   of int * string
    | Signal of int
    | Stop   of int

  type result =
    (string, error) Result.t

  val run : exe:string -> args:string list -> result
end = struct
  type error =
    | Invalid_exe
    | Fail   of int * string
    | Signal of int
    | Stop   of int

  type result =
    (string, error) Result.t

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

  let run ~exe ~args =
    match string_find exe ' ' with
    | Some _ -> Result.Error Invalid_exe
    | None ->
      let cmd = S.concat (exe :: args) ~sep:" " in
      let env = U.environment () in
      let stdout, stdin, stderr = U.open_process_full cmd ~env in
      let stdout_content = read_ic ~ic:stdout in
      let stderr_content = read_ic ~ic:stderr in
      match U.close_process_full (stdout, stdin, stderr) with
      | U.WEXITED   0 -> Result.Ok                stdout_content
      | U.WEXITED   n -> Result.Error (Fail   (n, stderr_content))
      | U.WSIGNALED n -> Result.Error (Signal  n)
      | U.WSTOPPED  n -> Result.Error (Stop    n)
end

module Curl =
struct
  let get ~url =
    let exe = "curl" in
    let args =
      [ "-k"
      ; "-i"
      ; "-X"
      ; "GET"
      ; url
      ]
    in
    Process.run ~exe ~args
end

let () =
  let module P = Process in
  let module R = Result in
  let url = Sys.argv.(1) in
  match Curl.get ~url with
  | R.Ok                  output  -> printf  "~~~~~ OK ~~~~~\n%s\n"     output
  | R.Error (P.Fail   (_, error)) -> eprintf "~~~~~ ERROR ~~~~~\n%s\n"  error
  | R.Error (P.Signal     signal) -> eprintf "~~~~~ SIGNAL ~~~~~\n%d\n" signal
  | R.Error (P.Stop       signal) -> eprintf "~~~~~ STOP ~~~~~\n%d\n"   signal
  | R.Error  P.Invalid_exe        -> assert false
