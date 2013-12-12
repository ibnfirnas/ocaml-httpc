open Printf

let () =
  let url = Sys.argv.(1) in
  match Curl.get ~url with
  | `Ok out            -> printf  "~~~ OK ~~~\n%s\n" out
  | `Error (code, err) -> eprintf "~~~ ERROR (%d) ~~~\n%s\n" code err
