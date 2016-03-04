type token =
  | SEMICOLON
  | COMMA
  | ASSIGN
  | INTDEC
  | BOOLDEC
  | VOIDDEC
  | LISTDEC
  | FUNCID of (string)
  | VARID of (string)
  | OPENPAREN
  | CLOSEPAREN
  | OPENBRACE
  | CLOSEBRACE
  | ENDOFPROGRAM
  | RETURN
  | INTLIT of (int32)
  | BOOLLIT of (bool)

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Spl.ast
