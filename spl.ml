
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



exception InvalidTyping of string
exception UnboundVariable of string
exception InvalidTreeStructure

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

let addBindingToTypeEnv binding env =
	let ( bindingList, parentEnv ) = match env with
		| TypeEnv( bindingList, parentEnv ) -> ( bindingList, parentEnv )
		| Null -> raise ( UnboundVariable "Given null type environment" )
	in TypeEnv( binding :: bindingList, parentEnv )

let getType = function
	| Type t -> t
	| ReturnType _ -> raise ( InvalidTyping "Expected type, not return type" )

let rec string_of_typing = function
	| Bool -> "bool"
	| Int -> "int"
	| Void -> "void"
	| List t -> ( string_of_typing t ) ^ " list"

let string_of_checktype = function
	| Type t -> string_of_typing t
	| ReturnType t -> "return: " ^ string_of_typing t

let rec typingsEqual ta tb = match ta, tb with
	| Bool, Bool
	| Int, Int
	| Void, Void -> true
	| List la, List lb -> typingsEqual la lb
	| _, _ -> false

let prettyPrint tree =
	let tabs i = String.make i '\t'
	(* i parameter refers to indentation/how many tabs *)
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
	in aux 0 tree

(*
	Process:
		Find global variable declarations outside of function definitions 
		Find and typecheck function definitions
*)

let typeCheck ast =
	let rec checkTypes env = function
		| Seq( childA, childB )
			-> let ( envA, typeA ) = checkTypes env childA
			in let ( envB, typeB ) = checkTypes envA childB
			in ( match typeA with
				| ReturnType _ -> ( envA, typeA )
				| _ -> ( envB, typeB ) )
		| FuncDef( name, declaredRtnType, params, fnBody )
			(* Once we can call functions, we'll have to actually do something with
			   the name, for now it's not relevant to type checking though *)
			-> let ( envWithParams, _ ) = checkTypes ( TypeEnv( [], env ) ) params
			in let ( _, observedType ) = checkTypes envWithParams fnBody
			in ( match ( declaredRtnType, observedType ) with
				| ( TypeDec ta, ReturnType tb ) -> if typingsEqual ta tb
					then ( env, Type ta )
					else raise ( InvalidTyping ( "function " ^ ( prettyPrint name ) ^ " returns type " ^ ( string_of_typing tb ) ^ " but is declared as type " ^ ( string_of_typing ta ) ) )
				(* Allow no return statement for void functions *)
				| ( TypeDec Void, Type Void ) -> ( env, Type Void )
				| ( TypeDec ta, _ ) -> raise ( InvalidTyping  ( "function "^( prettyPrint name )^" does not return a value, but is declared as type " ^ ( string_of_typing ta ) ) )
				| ( _, _ ) -> raise InvalidTreeStructure )
		| TypeDec( t ) -> ( env, ( Type t ) )
		
		| FuncParams( paramA, paramB )
			-> let ( envWithParamA, _ ) = checkTypes env paramA
			in let ( envWithBothParams, _ ) = checkTypes envWithParamA paramB
			in ( envWithBothParams, Type Void )
		
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
		
		| ReturnStmt( exp ) -> ( match checkTypes env exp with
			| ( env2, Type t ) -> ( env2, ReturnType t )
			| ( _, ReturnType _ ) -> raise ( InvalidTyping "Cannot return an already returned value" ) )
		
		| IntLit _ -> ( env, Type Int )
		| BoolLit _ -> ( env, Type Bool )
		
		| Null -> ( env, Type Void )
		
		| Assignment( varName, exp )
			-> let ( postNameEnv, varType ) = checkTypes env varName
			in let ( postTypeEnv, expType ) = checkTypes postNameEnv exp
			in if typingsEqual ( getType varType ) ( getType expType )
				then postTypeEnv, varType
				else raise ( InvalidTyping ( "Attempted to assign " ^ string_of_checktype expType ^ " value to " ^ string_of_checktype varType ^ " variable: " ^ prettyPrint varName ) )
		
		| VarInitialisation( declaredTypeAst, nameAst, expr )
			-> let varName = match nameAst with
				| VarIdentifier str -> str
				| _ -> raise InvalidTreeStructure
			in let ( envWithType, declaredType ) = checkTypes env declaredTypeAst
			in let extendedEnv = addBindingToTypeEnv ( TypeBind( varName, getType declaredType ) ) envWithType
			(* Code for assignments handles verifying that the expression is of the correct type *)
			in checkTypes extendedEnv ( Assignment( nameAst, expr ) )
		
		
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
		| IntLit _ | BoolLit _ | Assignment( _, _ )
			-> raise InvalidTreeStructure
			(* This function shouldn't be looking
			inside function definitions, and so
			shouldn't encounter these node types
			*)
	in let globalEnv = findGlobalVars ( TypeEnv( [], Null ) ) ast
	in ignore( checkTypes globalEnv ast ); ()