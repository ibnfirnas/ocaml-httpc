type process_error =
  | Fail   of int * string
  | Signal of int
  | Stop   of int

type argument_error =
  | Invalid_prog

type result =
  (string, process_error) Result.t

type t

val create : prog:string -> args:string list -> (t, argument_error) Result.t

val wait : t -> result
