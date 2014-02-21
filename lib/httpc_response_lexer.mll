{
  type token = STATUS_LINE of (string * int * string)
             | HEADER      of (string * string)
             | BODY_PART   of char
             | CRLF
             | EOF
}


let digit         = ['0'-'9']
let num           = digit+
let alpha_upper   = ['A'-'Z']
let alpha_lower   = ['a'-'z']
let alpha         = alpha_upper
                  | alpha_lower
let slash_fwd     = '/'
let dash          = '-'
let colon         = ':'
let dot           = '.'
let sp            = ' '
let cr            = '\r'
let lf            = '\n'
let crlf          = cr lf
let text          = [^ '\r' '\n']+
let http_version  = "HTTP" slash_fwd digit dot digit
let status_code   = digit digit digit
let reason_phrase = text
let header_name   = ( alpha | dash )+
let header_value  = text

rule parse_response = parse
  | eof
    {EOF}

  | (http_version as v ) sp (status_code as c) sp (reason_phrase as r) crlf
    {STATUS_LINE (v, int_of_string c, r)}

  | (header_name as name) colon sp (header_value as value) crlf
    {HEADER (name, value)}

  | crlf
    {CRLF}

  | (_ as b)
    {BODY_PART b}
