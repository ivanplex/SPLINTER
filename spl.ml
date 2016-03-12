
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

(* List of type bindings, with a reference to a parent
 environment (the global environment).*)
type typeEnvironment =
	(* list of bindings in the env, reference to higher level env *)
	| TypeEnv of typeBinding list * typeEnvironment
	| Null

type variable =
	| IntVal of int32
	| BoolVal of bool
	| VoidVal
	| ListVal of variable

type evaluatorVar =
	| ReturnedVal of variable
	| Value of variable

type binding =
	Binding of string * variable ref

type environment =
	| Env of binding list * environment
	| Null


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
	
	| ReturnStmt of ast
	| IntLit of int32
	| BoolLit of bool
	
	| Assignment of ast * ast (* VarIdentifier, expression *)
	
	(* type, name, expression *)
	| VarInitialisation of ast * ast * ast
	| ArrayLit of ast list



exception InvalidTyping of string
exception UnboundVariable of string
exception InvalidTreeStructure

(* lookup the type of a variable in the type environment *)
(* Will throw an UnboundVariable exception if the variable does
not exist in the given environment *)
let typeLookup env name =
	let rec envAssoc l name = match l with
		| TypeBind( varName, varType ) :: tail
			-> if String.compare varName name == 0 then varType else envAssoc tail name
		| [] -> raise ( UnboundVariable name )
	in let rec aux env name =
		match env with
			| TypeEnv( bindingList, parentEnv ) -> ( try
					envAssoc bindingList name
				with UnboundVariable _ -> aux parentEnv name )
			| Null -> raise ( UnboundVariable name )
	in aux env name

(* Returns a new type environment with the given binding
added to it *)
let addBindingToTypeEnv binding env =
	let ( bindingList, parentEnv ) = match env with
		| TypeEnv( bindingList, parentEnv ) -> ( bindingList, parentEnv )
		| Null -> raise ( UnboundVariable "Given null type environment" )
	in TypeEnv( binding :: bindingList, parentEnv )

(* Retrieves the typing from a checkingType *)
(* should only be used when a returned value is specifically not wanted *)
let getType = function
	| Type t -> t
	| ReturnType _ -> raise ( InvalidTyping "Expected type, not return type" )

(* Convert the given typing to a string*)
let rec string_of_typing = function
	| Bool -> "bool"
	| Int -> "int"
	| Void -> "void"
	| List t -> ( string_of_typing t ) ^ " list"

let string_of_checktype = function
	| Type t -> string_of_typing t
	| ReturnType t -> "return: " ^ string_of_typing t

(* Check whether two given typings represent the same type *)
let rec typingsEqual ta tb = match ta, tb with
	| Bool, Bool
	| Int, Int
	| Void, Void -> true
	(* If they're lists, verify that they are the same type of list*)
	| List la, List lb -> typingsEqual la lb
	(* If we get here, they definitely do not match *)
	| _, _ -> false

(* convert an ast type to a string *)
let prettyPrint tree =
	let tabs i = String.make i '\t'
	(* i parameter refers to indentation/how many tabs at the start of a line*)
	(* add one to i on recursive calls to indent lines within that call by 1 tab` *)
	in let rec aux i = function
		| Seq( t1, t2 ) -> ( aux i t1 ) ^ "\n" ^ ( aux i t2 )
		| FuncDef( name, rtnType, params, body ) ->
			( aux ( i + 1 ) rtnType ) ^ " " ^ ( aux ( i + 1 ) name ) ^ "( " ^ ( aux ( i + 1 ) params ) ^ " ) {\n" ^ ( aux ( i + 1 ) body ) ^ "\n};"
		(* | TypeDec( t ) -> t *)
		| TypeDec( Int ) -> "int"
		| TypeDec( Bool ) -> "bool"
		| TypeDec( Void ) -> "void"
		| TypeDec( List t ) -> ( aux i ( TypeDec t ) ) ^ " list"
		| FuncParams( head, tail ) -> ( aux i head ) ^ ", " ^ ( aux i tail )
		| ParamDec( typing, id ) -> ( aux i typing ) ^ " " ^ ( aux i id )
		| VarIdentifier( id ) -> id
		| FuncIdentifier( id ) -> id
		| Null -> ""
		
		| ReturnStmt( tree ) -> tabs i ^ "return " ^ ( aux i tree ) ^ ";"
		| IntLit( value ) -> Int32.to_string value
		| BoolLit( value ) -> string_of_bool value
		
		| Assignment( id, expr ) -> tabs i ^ ( aux i id ) ^ " = " ^ ( aux i expr ) ^ ";"
		| VarInitialisation( typing, id, expr ) -> tabs i ^ ( aux i typing ) ^ " " ^ ( aux 0 ( Assignment( id, expr ) ) )
		| ArrayLit( elementList ) -> let rec arrayAux = ( function
				| [ element ] -> aux i element
				| element :: tail -> ( aux i element ) ^ "," ^ ( arrayAux tail )
				| [] -> "" )
			in "[" ^ ( arrayAux elementList ) ^ "]"
	in aux 0 tree

(*
	Process:
		Find global variable declarations outside of function definitions 
		Find and typecheck function definitions
*)

let typeCheck ast =
	let rec checkTypes env = function
		| Seq( childA, childB )
			(* First check both sides a correctly typed *)
			-> let ( envA, typeA ) = checkTypes env childA
			in let ( envB, typeB ) = checkTypes envA childB
			in ( match typeA with
				(* If the left side (A) returns a value, the types of B don't matter, else the type of B matters *)
				(* TODO: if both sides return a value, check they're the same type *)
				| ReturnType _ -> ( envA, typeA )
				(* If A doesn't return, B would be executed next, so return the type/environment of B *)
				| _ -> ( envB, typeB ) )
		| FuncDef( name, declaredRtnType, params, fnBody )
			(* Once we can call functions, we'll have to actually do something with
			   the name, for now it's not relevant to type checking though *)
			
			(* Add the parameters to a new local environment *)
			-> let ( envWithParams, _ ) = checkTypes ( TypeEnv( [], env ) ) params
			(* Typecheck the body of the function *)
			in let ( _, observedType ) = checkTypes envWithParams fnBody
			in ( match ( declaredRtnType, observedType ) with
				(* TODO: refactor these few lines to use when keyword *)
				| ( TypeDec ta, ReturnType tb ) -> if typingsEqual ta tb
					(* The function matches its delared typing: we're happy *)
					then ( env, Type ta )
					(* The function declares itself to be one thing, but it's actually something else *)
					else raise ( InvalidTyping ( "function " ^ ( prettyPrint name ) ^ " returns type " ^ ( string_of_typing tb ) ^ " but is declared as type " ^ ( string_of_typing ta ) ) )
				(* Allow no return statement for void functions *)
				| ( TypeDec Void, Type _ ) -> ( env, Type Void )
				(* The function has a type other than void, but doesn't return a value *)
				| ( TypeDec ta, _ ) -> raise ( InvalidTyping  ( "function "^( prettyPrint name )^" does not return a value, but is declared as type " ^ ( string_of_typing ta ) ) )
				| ( _, _ ) -> raise InvalidTreeStructure )
		| TypeDec( t ) -> ( env, ( Type t ) )
		
		(* List of function parameters. We don't need to check or return values here, but
		 it's important to add the parameters to the type environment *)
		| FuncParams( paramA, paramB )
			-> let ( envWithParamA, _ ) = checkTypes env paramA
			in let ( envWithBothParams, _ ) = checkTypes envWithParamA paramB
			in ( envWithBothParams, Type Void )
		
		(* Declaration of a function parameter. *)
		(* Add the parameter to the environment, and verify that the parameter is not void *)
		| ParamDec( typeAst, paramName )
			-> let ( _, paramType ) = checkTypes env typeAst
			in let nameAsString = match paramName with
				| VarIdentifier str -> str
				| _ -> raise InvalidTreeStructure
			in ( match getType paramType with
				| Void -> raise ( InvalidTyping "parameters cannot be void" )
				| t -> ( addBindingToTypeEnv ( TypeBind( nameAsString, t ) ) env, Type t ) ) (* accept anything else *)
		| VarIdentifier name -> ( env, Type( typeLookup env name ) )
		
		(* Again, this will need to actually return a type once function calls are
		   implemented, but for now, it's useless *)
		| FuncIdentifier _ -> ( env, Type Void )
		
		(* Returning a value: wrap the type of the expression it's returning in a ReturnType *)
		| ReturnStmt( exp ) -> ( match checkTypes env exp with
			| ( env2, Type t ) -> ( env2, ReturnType t )
			| ( _, ReturnType _ ) -> raise ( InvalidTyping "Cannot return an already returned value" ) )
		
		| IntLit _ -> ( env, Type Int )
		| BoolLit _ -> ( env, Type Bool )
		
		| Null -> ( env, Type Void )
		
		(* Assign the value of some expression to a variable *)
		(* Check that 1: the variable already exists, 2: The expression matches the type of the variable *)
		| Assignment( varName, exp )
			-> let ( postNameEnv, varType ) = checkTypes env varName
			in let ( postTypeEnv, expType ) = checkTypes postNameEnv exp
			in if typingsEqual ( getType varType ) ( getType expType )
				then postTypeEnv, varType
				else raise ( InvalidTyping ( "Attempted to assign " ^ string_of_checktype expType ^ " value to " ^ string_of_checktype varType ^ " variable: " ^ prettyPrint varName ) )
		
		(* Bind a new variable to its type in the current environment *)
		(* Check that its initial value matches the type it has been declared as *)
		| VarInitialisation( declaredTypeAst, nameAst, expr )
			-> let varName = match nameAst with
				| VarIdentifier str -> str
				| _ -> raise InvalidTreeStructure
			in let ( envWithType, declaredType ) = checkTypes env declaredTypeAst
			in let extendedEnv = addBindingToTypeEnv ( TypeBind( varName, getType declaredType ) ) envWithType
			(* Code for assignments handles verifying that the expression is of the correct type *)
			in checkTypes extendedEnv ( Assignment( nameAst, expr ) )
		(* verify all elements are of the same type, return Type( List ( that_type ) ) *)
		| ArrayLit( elementList ) -> let rec checkArrayElements = ( function
				| elem :: tail -> let ( _, eType ) = checkTypes env elem
					and tType = checkArrayElements tail
					in ( match ( getType eType, tType ) with
						| ( eType, tType ) when typingsEqual eType tType -> tType
						| ( eType, Void ) -> eType
						| ( _, _ ) -> raise (InvalidTyping ("Inconsistent typing within array")) )
				| [] -> Void )
			in env, Type( List( checkArrayElements elementList ) )
		
		
	in let rec findGlobalVars globalEnv = function
		| Seq( childA, childB ) -> findGlobalVars ( findGlobalVars globalEnv childA ) childB
		
		| VarInitialisation( typeAst, nameAst, expression )
			-> let varName = match nameAst with
				| VarIdentifier str -> str
				| _ -> raise InvalidTreeStructure
			in let ( _, varType ) = checkTypes globalEnv typeAst
			in addBindingToTypeEnv ( TypeBind( varName, getType varType ) ) globalEnv
		
		| FuncDef( _, _, _, _ ) | Null -> globalEnv
		
		| TypeDec _ | FuncParams( _, _ ) | ParamDec( _, _ )
		| VarIdentifier _ | FuncIdentifier _ | ReturnStmt _
		| IntLit _ | BoolLit _ | Assignment( _, _ ) | ArrayLit( _ )
			-> raise InvalidTreeStructure
			(* This function shouldn't be looking
			inside function definitions, and so
			shouldn't encounter these node types
			*)
	in let globalEnv = findGlobalVars ( TypeEnv( [], Null ) ) ast
	in ignore( checkTypes globalEnv ast ); ()
