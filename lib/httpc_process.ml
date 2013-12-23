module B = Buffer
module S = StringLabels
module U = UnixLabels

type process_error =
  | Fail   of int * string
  | Signal of int
  | Stop   of int

type argument_error =
  | Invalid_prog

type ('ok, 'error) result =
  [ `Ok of 'ok | `Error of 'error ]

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
  try Some (S.index s c) with Not_found -> None

let wait {stdout; stdin; stderr; _} =
  let stdout_content = read_ic ~ic:stdout in
  let stderr_content = read_ic ~ic:stderr in
  match U.close_process_full (stdout, stdin, stderr) with
  | U.WEXITED   0 -> `Ok                stdout_content
  | U.WEXITED   n -> `Error (Fail   (n, stderr_content))
  | U.WSIGNALED n -> `Error (Signal  n)
  | U.WSTOPPED  n -> `Error (Stop    n)

let create ~prog ~args =
  match string_find prog ' ' with
  | Some _ -> `Error Invalid_prog
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
    `Ok t
