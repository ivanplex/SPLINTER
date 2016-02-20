(* SPL Lexer *)

{
	open Splparser
	exception Eof
}

rule main = parse
	| [ ' ' '\t' '\n' '\r' ] { main lexbuf }
	| ';' { SEMICOLON }
	| ',' { COMMA }
	| ( ( "int" | "bool" | "void" ) " list"* ) as typing { TYPE( typing ) }
	| ( [ 'A'-'Z' ] [ 'A'-'Z' 'a'-'z' '0'-'9' '_' ]* ) as name { FUNCID( name ) }
	| ( [ 'a'-'z' ] [ 'A'-'Z' 'a'-'z' '0'-'9' '_' ]* ) as name { VARID( name ) }
	| '(' { OPENPAREN }
	| ')' { CLOSEPAREN }
	| '{' { OPENBRACE }
	| '}' { CLOSEBRACE }
	| eof { raise Eof }