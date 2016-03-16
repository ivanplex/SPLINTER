(* SPL Lexer *)

{
	open Splparser
	(* exception Eof *)
}

rule main = parse
	(* comments *)
	| "//" [^ '\n' '\r' ]* ( [ '\n' '\r' ] | eof )+ { main lexbuf }
	| "/*" ( [^ '*' ] | '*' [^ '/' ] )* "*/"
	(* ignore whitespace *)
	| [ ' ' '\t' '\n' '\r' ] { main lexbuf }
	| '=' { ASSIGN }
	| "+=" { ASSIGNADD }
	| "-=" { ASSIGNSUB }
	| "*=" { ASSIGNMUL }
	| "/=" { ASSIGNDIV }
	(*| "++" { INCREMENT }
	| "--" { DECREMENT } *)
	
	| ';' { SEMICOLON }
	| ',' { COMMA }
	| '~' { ENDOFPROGRAM }
	| '+'      { PLUS }
    | '-'      { MINUS }
    | '*'      { TIMES }
    | '/'      { DIV }
	| "==" { COMPEQ }
	| '<' { COMPLT }
	| '>' { COMPGT }
	| "<=" { COMPLE }
	| ">=" { COMPGE }
	| "!=" | "<>" { COMPNE }
	| '[' { OPENSQUAREBRACKET }
	| ']' { CLOSESQUAREBRACKET }
	| '#' { LISTLENGTHOP }
	| "&&" { BOOLAND }
	| "||" { BOOLOR }
	| '!' { BOOLNOT }
	
	(*| '~' { BITWISENOT }*)
	| '&' { BITWISEAND }
	| '|' { BITWISEOR }
	| '^' { BITWISEXOR }
	
	(* End the program either on the end of file, or a '~' character.
	Entering a '~' is easier when writing the program directly into
	the console *)
	| '~' | eof { ENDOFPROGRAM }
	
	| "return" { RETURN } 
	| "output" { OUTPUT }
	
	| "if" { IF }
	| "else" { ELSE }
	| "while" { WHILE }
	| "for" { FOR }
	
	(* | ( ( ( "int" | "bool" | "void" ) " list"* ) as typing ) " list" { TYPE( List( typing ) } *)
	| "int" { INTDEC }
	| "bool" { BOOLDEC }
	| "void" { VOIDDEC }
	| "list" { LISTDEC }
	
	
	| '(' { OPENPAREN }
	| ')' { CLOSEPAREN }
	| '{' { OPENBRACE }
	| '}' { CLOSEBRACE }
	
	| (*'-'?*) [ '0'-'9' ]+ as lit { INTLIT( Int32.of_string lit ) }
	(* | ( "true" | "false" ) as lit { BOOLLIT( bool_of_string lit ) } *)
	| "true"  { BOOLLIT( true  ) }
	| "false" { BOOLLIT( false ) }
	
	(* These need to be at the end so reserved words are handled first *)
	(* Function identifiers start with an upper case letter *)
	| ( [ 'A'-'Z' ] [ 'A'-'Z' 'a'-'z' '0'-'9' '_' ]* ) as name { FUNCID( name ) }
	(* Variable identifiers start with a lower case letter *)
	| ( [ 'a'-'z' ] [ 'A'-'Z' 'a'-'z' '0'-'9' '_' ]* ) as name { VARID( name ) }
	
	(* | eof { raise Eof }  *)
