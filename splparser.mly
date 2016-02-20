/* === SPL Parser === */

%{
	open Spl
%}

%token SEMICOLON COMMA
%token <string>TYPE
%token <string>FUNCID
%token <string>VARID
%token OPENPAREN CLOSEPAREN OPENBRACE CLOSEBRACE

%left SEMICOLON
%left COMMA

%start main
%type <Spl.ast> main
%%

main:
	funcDefs SEMICOLON { $1 };

funcDefs:
	| funcDef funcDefs { Seq( $1, $2 ) }
	| funcDef { $1 };

funcDef:
	| TYPE FUNCID OPENPAREN paramList CLOSEPAREN OPENBRACE CLOSEBRACE {
		FuncDef( FuncIdentifier( $2 ), TypeDec( $1 ), $4, Null ) 
	};
	| TYPE FUNCID OPENPAREN CLOSEPAREN OPENBRACE CLOSEBRACE {
		FuncDef( FuncIdentifier( $2 ), TypeDec( $1 ), Null, Null ) 
	}; /* (* 2nd definition to allow 0 parameters to a function *) */
	/* (* Will need something between the open and close braces eventually, and use that in place of the Null constructor *) */

paramList:
	| funcParam COMMA paramList { FuncParams( $1, $3 ) }
	| funcParam { $1 }

funcParam:
	| TYPE VARID { ParamDec( TypeDec( $1 ), VarIdentifier( $2 ) ) }