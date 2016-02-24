/* === SPL Parser === */

%{
	open Spl
%}

%token SEMICOLON COMMA
/* %token <typing>TYPE */
%token INTDEC BOOLDEC VOIDDEC LISTDEC
%token <string>FUNCID
%token <string>VARID
%token OPENPAREN CLOSEPAREN OPENBRACE CLOSEBRACE

%token RETURN
%token <int32>INTLIT
%token <bool>BOOLLIT

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
	| typeDec FUNCID funcDefParams funcDefBody {
		FuncDef( FuncIdentifier( $2 ), TypeDec( $1 ), $3, $4 )
	};

funcDefParams:
	| OPENPAREN paramList CLOSEPAREN { $2 }
	| OPENPAREN CLOSEPAREN { Null }

funcDefBody:
	| OPENBRACE exprList CLOSEBRACE { $2 }
	| OPENBRACE CLOSEBRACE { Null }

paramList:
	| funcParam COMMA paramList { FuncParams( $1, $3 ) }
	| funcParam { $1 }

funcParam:
	| typeDec VARID { ParamDec( TypeDec( $1 ), VarIdentifier( $2 ) ) }

exprList:
	| expr SEMICOLON exprList { Seq( $1, $3 ) }
	| expr { $1 }
	| expr SEMICOLON { $1 }

expr:
	| RETURN { ReturnStmt( Null ) }
	| RETURN literal { ReturnStmt( $2 ) }

literal:
	| INTLIT { IntLit $1 }
	| BOOLLIT { BoolLit $1 }

typeDec:
	| INTDEC { Int }
	| BOOLDEC { Bool }
	| VOIDDEC { Void }
	| typeDec LISTDEC { List( $1 ) }




