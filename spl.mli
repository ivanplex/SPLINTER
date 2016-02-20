type ast =
	| Seq of ast * ast
	| FuncDef of ast * ast * ast * ast (* name, return type declaration, params declaration, function body *)
	| TypeDec of string
	| FuncParams of ast * ast (* Should be ParamDecs or Nulls *)
	| Null
	| ParamDec of ast * ast (* param type, param identifier *)
	| VarIdentifier of string
	| FuncIdentifier of string


val prettyPrint: ast -> string