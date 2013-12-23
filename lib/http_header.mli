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


val make : name:string -> value:string -> t

val to_string : t -> string
