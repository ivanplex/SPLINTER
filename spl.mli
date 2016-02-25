
type typing =
	| Bool | Int | Void
	| List of typing

type checkingType =
	| Type of typing
	| ReturnType of typing

type typeBinding =
	| TypeBind of string * typing

type typeEnvironment =
	(* list of bindings in the env, reference to higher level env *)
	| TypeEnv of typeBinding list * typeEnvironment
	| Null

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
	
	| Assignment of ast * ast (* VarIdentifier, expression *)
	
	(* type, name, expression *)
	| VarInitialisation of ast * ast * ast

val prettyPrint: ast -> string

val string_of_typing: typing -> string

val typeCheck: typeEnvironment -> ast -> typeEnvironment * checkingType