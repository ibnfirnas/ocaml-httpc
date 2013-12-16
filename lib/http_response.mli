type t =
  { http_vsn      : string
  ; status_code   : int
  ; reason_phrase : string
  ; headers       : Http_headers.t
  ; body          : string
  ; raw           : string
  }

val of_string : string -> t
