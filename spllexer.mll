(* SPL Lexer *)

{
	open Splparser
	exception Eof
}

rule main = parse
	| [ ' ' '\t' '\n' '\r' ] { main lexbuf }
	| '=' { ASSIGN }
	| ';' { SEMICOLON }
	| ',' { COMMA }
	
	| "return" { RETURN } 
	
	(* | ( ( ( "int" | "bool" | "void" ) " list"* ) as typing ) " list" { TYPE( List( typing ) } *)
	| "int" { INTDEC }
	| "bool" { BOOLDEC }
	| "void" { VOIDDEC }
	| "list" { LISTDEC }
	
	
	| '(' { OPENPAREN }
	| ')' { CLOSEPAREN }
	| '{' { OPENBRACE }
	| '}' { CLOSEBRACE }
	
	| [ '0'-'9' ]+ as lit { INTLIT( Int32.of_string lit ) }
	| ( "true" | "false" ) as lit { BOOLLIT( bool_of_string lit ) }
	
	(* These need to be at the end so reserved words are handled first *)
	| ( [ 'A'-'Z' ] [ 'A'-'Z' 'a'-'z' '0'-'9' '_' ]* ) as name { FUNCID( name ) }
	| ( [ 'a'-'z' ] [ 'A'-'Z' 'a'-'z' '0'-'9' '_' ]* ) as name { VARID( name ) }
	
	| eof { raise Eof }