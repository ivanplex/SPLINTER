
(* Hold the typing of a variable, function, or expression *)
type typing =
	| Bool | Int | Void
	| List of typing

(* Used when typechecking: Keeps track of whether the value
was produced by a return statement or not *)
type checkingType =
	| Type of typing
	| ReturnType of typing

(* Used in a type environment to keep track of the types of
 variables (and functions?) *)
type typeBinding =
	| TypeBind of string * typing

type funcTypeBinding =
	(* function name, parameter typings, return type *)
	| FuncTypeBind of string * typing list * typing

(* List of type bindings, with a reference to a parent
 environment (the global environment).*)
type typeEnvironment =
	(* list of bindings in the env, reference to higher level env *)
	| TypeEnv of typeBinding list * funcTypeBinding list * typeEnvironment
	| Null

type variable =
	| IntVal of int32
	| BoolVal of bool
	| VoidVal
	| ListVal of int ref * variable array ref

type evaluatorVar =
	| ReturnedVal of variable
	| Value of variable

type binding =
	Binding of string * variable ref



(* The type for the abstract syntax tree.  *)
type ast =
	(* Holds two subtrees, which should be executed one after
	another *)
	| Seq of ast * ast
	| FuncDef of ast * ast * ast * ast (* name, return type declaration, params declaration, function body *)
	| TypeDec of typing
	(* Used as a placeholder *)
	| Null
	(* Used when there are two or more parameters in a function definition *)
	| FuncParams of ast * ast (* Should be ParamDecs or Nulls *)
	(* The parameters listed in a function's definition *)
	| ParamDec of ast * ast (* param type, param identifier *)
	| VarIdentifier of string
	| FuncIdentifier of string
	
	(* functionName, parameter list *)
	| FunctionCall of ast * ast list
	
	| ReturnStmt of ast
	| OutputStmt of ast
	
	
	| IntLit of int32
	| BoolLit of bool
	
	| Assignment of ast * ast (* VarIdentifier, expression *)
	
	(* type, name, expression *)
	| VarInitialisation of ast * ast * ast
	| ArrayLit of ast list
	| ArrayIndex of ast * ast (* array name VarIdentifier, index number *)
	| ArrayLength of ast
	
	(* left side * right side *)
	| Plus of ast * ast
	| Minus of ast * ast
	| Times of ast * ast
	| Div of ast * ast
	
	| CompareEqual of ast * ast
	| CompareLessThan of ast * ast (* Greater than is also held by this node type, by inversing the expression order in the parser *)
	| CompareLessEqual of ast * ast (* Greater than or Equal to is handled as above *)
	| CompareNotEqual of ast * ast
	
	| BooleanAnd of ast * ast
	| BooleanOr of ast * ast
	| BooleanNot of ast
	
	| BitwiseNot of ast
	| BitwiseAnd of ast * ast
	| BitwiseOr of ast * ast
	| BitwiseXor of ast * ast
	
	(* Condition, consequent, alternative *)
	| If of ast * ast * ast
	| While of ast * ast


type funcBinding = 
	FuncBinding of string * ast (* should be the FuncDef ast node *)

type environment =
	| Env of binding list * funcBinding list * environment
	| Null

(* val prettyPrint: ast -> string *)

val string_of_typing: typing -> string

val typeCheck: ast -> unit

val executeFunction: environment -> string -> variable list -> int32 list list -> variable * int32 list list

val string_of_var: variable -> string

val populateEnvironmentInitialState: environment -> ast -> environment

val checkStreamLengths: int32 list list -> unit

val string_of_stream: int32 list list -> string