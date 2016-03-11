(* Steam Lexer *)

{
	open Streamparser
}

rule main = parse
	| '[' [ '\n' '\r' '\t' ' ' ]* { LEFTENDMARKER }
	| [ '\n' '\r' '\t' ' ' ]* ']' { RIGHTENDMARKER }
	| [ '\t' ' ' '\n' '\r' ]* [ '\n' '\r' ]+ [ '\t' ' '  ]* { MAJORDIVIDER }
	| [ '\t' ' '  ]+ { MINORDIVIDER }
	| ( '-'? [ '0'-'9' ]+ ) as num { NUMBER( Int32.of_string num ) }
	| [ '\n' '\r' ]* eof { EOF }