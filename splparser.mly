/*(* === SPL Parser === *)*/

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
%token PLUS MINUS TIMES DIV
%token COMPEQ COMPLT COMPGT COMPLE COMPGE COMPNE
%token BOOLAND BOOLOR BOOLNOT
%token LISTLENGTHOP
%token ENDOFPROGRAM
%token OPENSQUAREBRACKET CLOSESQUAREBRACKET
%token OUTPUT
%token IF ELSE

%token RETURN
%token <int32>INTLIT
%token <bool>BOOLLIT

%left BOOLOR
%left BOOLAND
%left COMPEQ COMPGE COMPGT COMPLE COMPLT COMPNE
%left PLUS MINUS
%left TIMES DIV
%nonassoc LISTLENGTHOP
%nonassoc BOOLNOT

%left COMMA
%left SEMICOLON

%start main
%type <Spl.ast> main
%%

main:
	topLevelList ENDOFPROGRAM { $1 }

topLevelList:
	| topLevelOperation topLevelList { Seq( $1, $2 ) }
	| topLevelOperation { $1 }

topLevelOperation:
	| funcDef SEMICOLON { $1 }
	| funcDef { $1 }
	| varInit SEMICOLON { $1 }

funcDef:
	| typeDec FUNCID funcDefParams funcDefBody {
		FuncDef( FuncIdentifier( $2 ), TypeDec( $1 ), $3, $4 )
	}

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

/*(* Expressions are valid within the body of the function *)*/
expr:
	| RETURN { ReturnStmt( Null ) }
	| RETURN expr { ReturnStmt( $2 ) }
	| OUTPUT expr { OutputStmt( $2 ) }
	| literal { $1 }
	| varInit { $1 }
	| varName { $1 }
	| varAssign { $1 }
	| expr PLUS expr { Plus( $1, $3 ) }
	| expr MINUS expr { Minus( $1, $3 ) }
	| expr TIMES expr { Times( $1, $3 ) }
	| expr DIV expr { Div( $1, $3 ) }
	| expr COMPEQ expr { CompareEqual( $1, $3 ) }
	| expr COMPLT expr { CompareLessThan( $1, $3 ) }
	| expr COMPGT expr { CompareLessThan( $3, $1 ) } /*(* Left/right side swapped to convert greater than to less than *)*/
	| expr COMPLE expr { CompareLessEqual( $1, $3 ) }
	| expr COMPGE expr { CompareLessEqual( $3, $1 ) } /*(* As above *)*/
	| expr COMPNE expr { CompareNotEqual( $1, $3 ) }
	| BOOLNOT expr { BooleanNot $2 }
	| expr BOOLAND expr { BooleanAnd( $1, $3 ) }
	| expr BOOLOR expr { BooleanOr( $1, $3 ) }
	| OPENPAREN expr CLOSEPAREN { $2 }
	| arrayIndex { $1 }
	| LISTLENGTHOP expr { ArrayLength $2 }
	| ifExpr { $1 }

literal:
	| INTLIT { IntLit $1 }
	| BOOLLIT { BoolLit $1 }
	| OPENSQUAREBRACKET arrayContents CLOSESQUAREBRACKET { ArrayLit( $2 ) }

arrayContents:
	| expr { [ $1 ] }
	| expr COMMA arrayContents { $1 :: $3 }

arrayIndex:
	| expr OPENSQUAREBRACKET expr CLOSESQUAREBRACKET { ArrayIndex( $1, $3 ) }

typeDec:
	| INTDEC { Int }
	| BOOLDEC { Bool }
	| VOIDDEC { Void }
	| typeDec LISTDEC { List( $1 ) }

varInit:
	| typeDec varName ASSIGN expr { VarInitialisation( TypeDec( $1 ), $2, $4 ) }

varAssign:
	| varName ASSIGN expr { Assignment( $1, $3 ) }
	| arrayIndex ASSIGN expr { Assignment( $1, $3 ) }

varName:
	VARID { VarIdentifier $1 }

ifExpr:
	| IF expr OPENBRACE exprList CLOSEBRACE { If( $2, $4, Null ) }
	| IF expr OPENBRACE exprList CLOSEBRACE ELSE OPENBRACE exprList CLOSEBRACE { If( $2, $4, $8 ) }
