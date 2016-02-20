type ast =
	| Seq of ast * ast
	| FuncDef of ast * ast * ast * ast (* name, return type declaration, params declaration, function body *)
	| TypeDec of string
	| FuncParams of ast * ast (* Should be ParamDecs or Nulls *)
	| Null
	| ParamDec of ast * ast (* param type, param identifier *)
	| VarIdentifier of string
	| FuncIdentifier of string

let rec prettyPrint = function
	| Seq( t1, t2 ) -> ( prettyPrint t1 ) ^ "\n" ^ ( prettyPrint t2 )
	| FuncDef( name, rtnType, params, body ) -> ( prettyPrint rtnType ) ^ " " ^ ( prettyPrint name ) ^ "( " ^ ( prettyPrint params ) ^ " ) {\n" ^ ( prettyPrint body ) ^ "\n}"
	| TypeDec( t ) -> t
	| FuncParams( head, tail ) -> ( prettyPrint head ) ^ ", " ^ ( prettyPrint tail )
	| ParamDec( typing, id ) -> ( prettyPrint typing ) ^ " " ^ ( prettyPrint id )
	| VarIdentifier( id ) -> id
	| FuncIdentifier( id ) -> id
	| Null -> ""