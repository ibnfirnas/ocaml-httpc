type http_vsn      = [ `Not_implemented ]
type status_code   = [ `Not_implemented ]
type reason_phrase = [ `Not_implemented ]
type headers       = [ `Not_implemented ]
type body          = [ `Not_implemented ]

type t =
  { http_vsn      : http_vsn
  ; status_code   : status_code
  ; reason_phrase : reason_phrase
  ; headers       : headers
  ; body          : body
  ; raw           : string
  }

val of_string : string -> t
