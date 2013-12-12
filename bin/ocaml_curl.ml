open Printf

let () =
  let url = Sys.argv.(1) in
  match Curl.get ~url with
  | Result.Ok out            -> printf  "~~~ OK ~~~\n%s\n" out
  | Result.Error (code, err) -> eprintf "~~~ ERROR (%d) ~~~\n%s\n" code err
