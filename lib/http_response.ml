type t =
  { http_vsn      : string
  ; status_code   : int
  ; reason_phrase : string
  ; headers       : (string * string) list
  ; body          : string
  ; raw           : string
  }

let parse response_text =
  let module HRL = Http_response_lexer in
  let lexbuf = Lexing.from_string response_text in
  let body = Buffer.create 32 in
  let rec parse ~status ~headers =
    match HRL.parse_response lexbuf with
    | HRL.STATUS_LINE s -> parse ~status:(Some s) ~headers
    | HRL.HEADER      h -> parse ~status          ~headers:(h :: headers)
    | HRL.CRLF          -> parse ~status          ~headers
    | HRL.BODY_PART   b ->
      begin
        Buffer.add_char body b;
        parse ~status ~headers
      end
    | HRL.EOF ->
      status , headers , (Buffer.contents body)
  in
  parse ~status:None ~headers:[]

let of_string s =
  match parse s with
  | None            ,       _,    _ -> assert false
  | (Some (v, c, r)), headers, body ->
    { http_vsn      = v
    ; status_code   = c
    ; reason_phrase = r
    ; headers
    ; body
    ; raw           = s
    }
