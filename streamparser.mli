type token =
  | LEFTENDMARKER
  | RIGHTENDMARKER
  | EOF
  | MAJORDIVIDER
  | MINORDIVIDER
  | NUMBER of (int32)

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> int32 list list
