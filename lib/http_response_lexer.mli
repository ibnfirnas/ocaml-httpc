type token = STATUS_LINE of (string * int * string)
           | HEADER      of (string * string)
           | BODY_PART   of char
           | CRLF
           | EOF

val parse_response : Lexing.lexbuf -> token
