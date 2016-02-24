
type typing =
	| Bool | Int | Void
	| List of typing

type checkingType =
	| Type of typing
	| ReturnType of typing

type ast =
	| Seq of ast * ast
	| FuncDef of ast * ast * ast * ast (* name, return type declaration, params declaration, function body *)
	| TypeDec of typing
	| FuncParams of ast * ast (* Should be ParamDecs or Nulls *)
	| Null
	| ParamDec of ast * ast (* param type, param identifier *)
	| VarIdentifier of string
	| FuncIdentifier of string
	
	| ReturnStmt of ast
	| IntLit of int32
	| BoolLit of bool

val prettyPrint: ast -> string

val typeCheck: ast -> checkingType