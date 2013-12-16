module L = ListLabels
module S = StringLabels
module Tbl = MoreLabels.Hashtbl

type t =
  { accept               : string option
  ; accept_charset       : string option
  ; accept_encoding      : string option
  ; accept_language      : string option
  ; accept_ranges        : string option
  ; age                  : string option
  ; allow                : string option
  ; authorization        : string option
  ; cache_control        : string option
  ; connection           : string option
  ; content_encoding     : string option
  ; content_language     : string option
  ; content_length       : string option
  ; content_location     : string option
  ; content_md5          : string option
  ; content_range        : string option
  ; content_type         : string option
  ; date                 : string option
  ; etag                 : string option
  ; expect               : string option
  ; expires              : string option
  ; from                 : string option
  ; host                 : string option
  ; if_match             : string option
  ; if_modified_since    : string option
  ; if_none_match        : string option
  ; if_range             : string option
  ; if_unmodified_since  : string option
  ; last_modified        : string option
  ; location             : string option
  ; max_forwards         : string option
  ; pragma               : string option
  ; proxy_authenticate   : string option
  ; proxy_authorization  : string option
  ; range                : string option
  ; referer              : string option
  ; retry_after          : string option
  ; server               : string option
  ; te                   : string option
  ; trailer              : string option
  ; transfer_encoding    : string option
  ; upgrade              : string option
  ; user_agent           : string option
  ; vary                 : string option
  ; via                  : string option
  ; warning              : string option
  ; www_authenticate     : string option
  ; other                : (string * string) list
  }

let empty =
  { accept               = None
  ; accept_charset       = None
  ; accept_encoding      = None
  ; accept_language      = None
  ; accept_ranges        = None
  ; age                  = None
  ; allow                = None
  ; authorization        = None
  ; cache_control        = None
  ; connection           = None
  ; content_encoding     = None
  ; content_language     = None
  ; content_length       = None
  ; content_location     = None
  ; content_md5          = None
  ; content_range        = None
  ; content_type         = None
  ; date                 = None
  ; etag                 = None
  ; expect               = None
  ; expires              = None
  ; from                 = None
  ; host                 = None
  ; if_match             = None
  ; if_modified_since    = None
  ; if_none_match        = None
  ; if_range             = None
  ; if_unmodified_since  = None
  ; last_modified        = None
  ; location             = None
  ; max_forwards         = None
  ; pragma               = None
  ; proxy_authenticate   = None
  ; proxy_authorization  = None
  ; range                = None
  ; referer              = None
  ; retry_after          = None
  ; server               = None
  ; te                   = None
  ; trailer              = None
  ; transfer_encoding    = None
  ; upgrade              = None
  ; user_agent           = None
  ; vary                 = None
  ; via                  = None
  ; warning              = None
  ; www_authenticate     = None
  ; other                = []
  }

let key_of_string s =
  S.lowercase s

let setter_tbl =
  let tbl = Tbl.create 50 in
  let setters =
    [ "accept"              , (fun t v -> {t with accept              = Some v})
    ; "accept-charset"      , (fun t v -> {t with accept_charset      = Some v})
    ; "accept-encoding"     , (fun t v -> {t with accept_encoding     = Some v})
    ; "accept-language"     , (fun t v -> {t with accept_language     = Some v})
    ; "accept-ranges"       , (fun t v -> {t with accept_ranges       = Some v})
    ; "age"                 , (fun t v -> {t with age                 = Some v})
    ; "allow"               , (fun t v -> {t with allow               = Some v})
    ; "authorization"       , (fun t v -> {t with authorization       = Some v})
    ; "cache-control"       , (fun t v -> {t with cache_control       = Some v})
    ; "connection"          , (fun t v -> {t with connection          = Some v})
    ; "content-encoding"    , (fun t v -> {t with content_encoding    = Some v})
    ; "content-language"    , (fun t v -> {t with content_language    = Some v})
    ; "content-length"      , (fun t v -> {t with content_length      = Some v})
    ; "content-location"    , (fun t v -> {t with content_location    = Some v})
    ; "content-md5"         , (fun t v -> {t with content_md5         = Some v})
    ; "content-range"       , (fun t v -> {t with content_range       = Some v})
    ; "content-type"        , (fun t v -> {t with content_type        = Some v})
    ; "date"                , (fun t v -> {t with date                = Some v})
    ; "etag"                , (fun t v -> {t with etag                = Some v})
    ; "expect"              , (fun t v -> {t with expect              = Some v})
    ; "expires"             , (fun t v -> {t with expires             = Some v})
    ; "from"                , (fun t v -> {t with from                = Some v})
    ; "host"                , (fun t v -> {t with host                = Some v})
    ; "if-match"            , (fun t v -> {t with if_match            = Some v})
    ; "if-modified-since"   , (fun t v -> {t with if_modified_since   = Some v})
    ; "if-none-match"       , (fun t v -> {t with if_none_match       = Some v})
    ; "if-range"            , (fun t v -> {t with if_range            = Some v})
    ; "if-unmodified-since" , (fun t v -> {t with if_unmodified_since = Some v})
    ; "last-modified"       , (fun t v -> {t with last_modified       = Some v})
    ; "location"            , (fun t v -> {t with location            = Some v})
    ; "max-forwards"        , (fun t v -> {t with max_forwards        = Some v})
    ; "pragma"              , (fun t v -> {t with pragma              = Some v})
    ; "proxy-authenticate"  , (fun t v -> {t with proxy_authenticate  = Some v})
    ; "proxy-authorization" , (fun t v -> {t with proxy_authorization = Some v})
    ; "range"               , (fun t v -> {t with range               = Some v})
    ; "referer"             , (fun t v -> {t with referer             = Some v})
    ; "retry-after"         , (fun t v -> {t with retry_after         = Some v})
    ; "server"              , (fun t v -> {t with server              = Some v})
    ; "te"                  , (fun t v -> {t with te                  = Some v})
    ; "trailer"             , (fun t v -> {t with trailer             = Some v})
    ; "transfer-encoding"   , (fun t v -> {t with transfer_encoding   = Some v})
    ; "upgrade"             , (fun t v -> {t with upgrade             = Some v})
    ; "user-agent"          , (fun t v -> {t with user_agent          = Some v})
    ; "vary"                , (fun t v -> {t with vary                = Some v})
    ; "via"                 , (fun t v -> {t with via                 = Some v})
    ; "warning"             , (fun t v -> {t with warning             = Some v})
    ; "www-authenticate"    , (fun t v -> {t with www_authenticate    = Some v})
    ]
  in
  L.iter setters ~f:(fun (k, v) -> Tbl.add tbl ~key:(key_of_string k) ~data:v);
  tbl

let set t ~name ~value =
  let name = key_of_string name in
  try
    let setter = Tbl.find setter_tbl name in
    setter t value
  with Not_found ->
    {t with other = (name, value) :: t.other}
