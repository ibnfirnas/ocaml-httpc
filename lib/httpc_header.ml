open Printf

type name =
  | Accept
  | Accept_charset
  | Accept_encoding
  | Accept_language
  | Accept_ranges
  | Age
  | Allow
  | Authorization
  | Cache_control
  | Connection
  | Content_encoding
  | Content_language
  | Content_length
  | Content_location
  | Content_md5
  | Content_range
  | Content_type
  | Date
  | Etag
  | Expect
  | Expires
  | From
  | Host
  | If_match
  | If_modified_since
  | If_none_match
  | If_range
  | If_unmodified_since
  | Last_modified
  | Location
  | Max_forwards
  | Pragma
  | Proxy_authenticate
  | Proxy_authorization
  | Range
  | Referer
  | Retry_after
  | Server
  | Te
  | Trailer
  | Transfer_encoding
  | Upgrade
  | User_agent
  | Vary
  | Via
  | Warning
  | Www_authenticate
  | Other of string

type value = string

type t = name * value

let make ~name ~value =
  let name = String.lowercase name in
  match name with
  | "accept"              -> Accept               , value
  | "accept-charset"      -> Accept_charset       , value
  | "accept-encoding"     -> Accept_encoding      , value
  | "accept-language"     -> Accept_language      , value
  | "accept-ranges"       -> Accept_ranges        , value
  | "age"                 -> Age                  , value
  | "allow"               -> Allow                , value
  | "authorization"       -> Authorization        , value
  | "cache-control"       -> Cache_control        , value
  | "connection"          -> Connection           , value
  | "content-encoding"    -> Content_encoding     , value
  | "content-language"    -> Content_language     , value
  | "content-length"      -> Content_length       , value
  | "content-location"    -> Content_location     , value
  | "content-md5"         -> Content_md5          , value
  | "content-range"       -> Content_range        , value
  | "content-type"        -> Content_type         , value
  | "date"                -> Date                 , value
  | "etag"                -> Etag                 , value
  | "expect"              -> Expect               , value
  | "expires"             -> Expires              , value
  | "from"                -> From                 , value
  | "host"                -> Host                 , value
  | "if-match"            -> If_match             , value
  | "if-modified-since"   -> If_modified_since    , value
  | "if-none-match"       -> If_none_match        , value
  | "if-range"            -> If_range             , value
  | "if-unmodified-since" -> If_unmodified_since  , value
  | "last-modified"       -> Last_modified        , value
  | "location"            -> Location             , value
  | "max-forwards"        -> Max_forwards         , value
  | "pragma"              -> Pragma               , value
  | "proxy-authenticate"  -> Proxy_authenticate   , value
  | "proxy-authorization" -> Proxy_authorization  , value
  | "range"               -> Range                , value
  | "referer"             -> Referer              , value
  | "retry-after"         -> Retry_after          , value
  | "server"              -> Server               , value
  | "te"                  -> Te                   , value
  | "trailer"             -> Trailer              , value
  | "transfer-encoding"   -> Transfer_encoding    , value
  | "upgrade"             -> Upgrade              , value
  | "user-agent"          -> User_agent           , value
  | "vary"                -> Vary                 , value
  | "via"                 -> Via                  , value
  | "warning"             -> Warning              , value
  | "www-authenticate"    -> Www_authenticate     , value
  | _                     -> Other name           , value

let to_string (name, value) =
  let name =
    match name with
    | Accept              -> "accept"
    | Accept_charset      -> "accept-charset"
    | Accept_encoding     -> "accept-encoding"
    | Accept_language     -> "accept-language"
    | Accept_ranges       -> "accept-ranges"
    | Age                 -> "age"
    | Allow               -> "allow"
    | Authorization       -> "authorization"
    | Cache_control       -> "cache-control"
    | Connection          -> "connection"
    | Content_encoding    -> "content-encoding"
    | Content_language    -> "content-language"
    | Content_length      -> "content-length"
    | Content_location    -> "content-location"
    | Content_md5         -> "content-md5"
    | Content_range       -> "content-range"
    | Content_type        -> "content-type"
    | Date                -> "date"
    | Etag                -> "etag"
    | Expect              -> "expect"
    | Expires             -> "expires"
    | From                -> "from"
    | Host                -> "host"
    | If_match            -> "if-match"
    | If_modified_since   -> "if-modified-since"
    | If_none_match       -> "if-none-match"
    | If_range            -> "if-range"
    | If_unmodified_since -> "if-unmodified-since"
    | Last_modified       -> "last-modified"
    | Location            -> "location"
    | Max_forwards        -> "max-forwards"
    | Pragma              -> "pragma"
    | Proxy_authenticate  -> "proxy-authenticate"
    | Proxy_authorization -> "proxy-authorization"
    | Range               -> "range"
    | Referer             -> "referer"
    | Retry_after         -> "retry-after"
    | Server              -> "server"
    | Te                  -> "te"
    | Trailer             -> "trailer"
    | Transfer_encoding   -> "transfer-encoding"
    | Upgrade             -> "upgrade"
    | User_agent          -> "user-agent"
    | Vary                -> "vary"
    | Via                 -> "via"
    | Warning             -> "warning"
    | Www_authenticate    -> "www-authenticate"
    | Other name          -> name
  in
  sprintf "%s: %s\r\n" name value
