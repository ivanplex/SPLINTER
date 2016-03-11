/*(* Stream Parser *)*/

/*(*%{
	open Spl
%}*)*/

%token LEFTENDMARKER RIGHTENDMARKER
%token EOF
%token MAJORDIVIDER MINORDIVIDER
%token <int32>NUMBER

%nonassoc MAJORDIVIDER MINORDIVIDER

%start main
%type <int32 list list> main
%%

main:
	| streams EOF { $1 }
	| { [] }
	| LEFTENDMARKER streams RIGHTENDMARKER { $2 }
	| LEFTENDMARKER RIGHTENDMARKER { [] }

streams:
	| inputSet MAJORDIVIDER streams { $1 :: $3 }
	| inputSet { [ $1 ] }
	/*| { [] }*/

inputSet:
	| NUMBER MINORDIVIDER inputSet { $1 :: $3 }
	| NUMBER { [ $1 ] }
	/*| { [] }*/