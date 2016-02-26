/* === SPL Parser === */

%{
	open Spl
%}

%token SEMICOLON COMMA
%token ASSIGN
/*(* %token <typing>TYPE *)*/
%token INTDEC BOOLDEC VOIDDEC LISTDEC
%token <string>FUNCID
%token <string>VARID
%token OPENPAREN CLOSEPAREN OPENBRACE CLOSEBRACE
%token ENDOFPROGRAM

%token RETURN
%token <int32>INTLIT
%token <bool>BOOLLIT

%left COMMA
%left SEMICOLON

%start main
%type <Spl.ast> main
%%

main:
	funcDefs ENDOFPROGRAM { $1 };

/*(* TODO: rename funcDefs to something more accurate *)*/
funcDefs:
	| topLevelOperation funcDefs { Seq( $1, $2 ) }
	| topLevelOperation { $1 };

topLevelOperation:
	| funcDef SEMICOLON { $1 }
	| varInit SEMICOLON { $1 };

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
	| typeDec varName { ParamDec( TypeDec( $1 ), $2 ) }

exprList:
	| expr SEMICOLON exprList { Seq( $1, $3 ) }
	| expr { $1 }
	| expr SEMICOLON { $1 }

expr:
	| RETURN { ReturnStmt( Null ) }
	| RETURN expr { ReturnStmt( $2 ) }
	| literal { $1 }
	| varInit { $1 }
	| varName { $1 }
	| varAssign { $1 }

literal:
	| INTLIT { IntLit $1 }
	| BOOLLIT { BoolLit $1 }

typeDec:
	| INTDEC { Int }
	| BOOLDEC { Bool }
	| VOIDDEC { Void }
	| typeDec LISTDEC { List( $1 ) }

varInit:
	| typeDec varName ASSIGN expr { VarInitialisation( TypeDec( $1 ), $2, $4 ) }

varAssign:
	| varName ASSIGN expr { Assignment( $1, $3 ) }

varName:
	VARID { VarIdentifier $1 }


