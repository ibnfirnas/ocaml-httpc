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

val empty : t

val set : t -> name:string -> value:string -> t
