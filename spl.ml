
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
	
	(* scope, type, name, expression *)
	| VarInitialisation of ast * ast * ast * ast



exception InvalidTyping of string
exception UnboundVariable
exception InvalidTreeStructure

let typeLookup env name =
	let rec envAssoc l name = match l with
		| TypeBind( varName, varType ) :: tail
			-> if varName == name then varType else envAssoc tail name
		| [] -> raise UnboundVariable
	in let rec aux env name =
		match env with
			| TypeEnv( bindingList, parentEnv ) -> try
					envAssoc bindingList name
				with UnboundVariable -> aux parentEnv name
			| Null -> raise UnboundVariable
	in aux env name



let rec string_of_typing = function
	| Bool -> "bool"
	| Int -> "int"
	| Void -> "void"
	| List t -> ( string_of_typing t ) ^ " list"

let prettyPrint tree =
	let tabs i = String.make i '\t'
	(* i parameter refers to indentation/how many tabs *)
	in let rec aux i = function
		| Seq( t1, t2 ) -> ( aux i t1 ) ^ "\n" ^ ( aux i t2 )
		| FuncDef( name, rtnType, params, body ) ->
			( aux ( i + 1 ) rtnType ) ^ " " ^ ( aux ( i + 1 ) name ) ^ "( " ^ ( aux ( i + 1 ) params ) ^ " ) {\n" ^ ( aux ( i + 1 ) body ) ^ "\n}"
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
				| ReturnType _ -> ( envA, unboundB, typeA )
				| _ -> ( envB, unboundB, typeB ) )
		| FuncDef( name, declaredRtnType, params, fnBody )
			(* Once we can call variables and functions, we'll have to actually do something with
			   the name and params, for now they're not relevant to type checking though *)
			-> let ( envWithParams, unboundWithParams, _ ) = checkTypes TypeEnv( [] env ) unboundVars params
			in let ( _, unboundWithBody, observedType ) = checkTypes envWithParams unboundWithParams fnBody
			in ( match ( declaredRtnType, observedType ) with
				| ( TypeDec ta, ReturnType tb ) -> if ta == tb
					then ( env, unboundWithBody, Type ta )
					else raise ( InvalidTyping ( "function " ^ ( prettyPrint name ) ^ " returns type" ^ ( string_of_typing tb ) ^ " but is declared as type " ^ ( string_of_typing ta ) ) )
				(* Allow no return statement for void functions *)
				| ( TypeDec Void, Type Void ) -> ( env, unboundWithBody, Type Void )
				| ( _, _ ) -> raise ( InvalidTyping  ( "function "^( prettyPrint name )^" does not return a value, but is declared as type " ^ ( string_of_typing ta ) ) ) )
		| TypeDec( t ) -> ( env, unboundVars, ( Type t ) )
		
		(* This will need to return parameter typings once I'm doing more with
		   variable names and types, for now, its type is irrelevant *)
		| FuncParams( paramA, paramB )
			(* TODO: Still accepting void params for some reason *)
			-> let ( envWithParamA, unboundWithParamA, _ ) = checkTypes env unboundVars paramA
			in let ( envWithBothParams, unboundWithBothParams, _ ) = checkTypes envWithParamA unboundWithParamA paramB
			in ( envWithBothParams, unboundWithBothParams, Type Void )
		
		| ParamDec( typeAst, paramName )
			-> let ( _, _, paramType ) = checkTypes env unboundVars typeAst
			in let nameAsString = match paramName with
				| VarIdentifier str -> str
				| _ -> raise InvalidTreeStructure
			in ( match paramType with
				| Type Void -> raise ( InvalidTyping "parameters cannot be void" )
				| t -> ( TypeBind( nameAsString, t ) :: env, unboundVars, t ) ) (* accept anything else *)
		| VarIdentifier name -> ( env, ( typeLookup env name ) )
		
		(* Again, this will need to actually return a type once function calls are
		   implemented, but for now, it's useless *)
		| FuncIdentifier _ -> Type Void
		
		| ReturnStmt( exp ) -> ( match checkTypes( exp ) with
			| Type t -> ReturnType t
			| ReturnType _ -> raise ( InvalidTyping "Cannot return an already returned value" ) )
		
		| IntLit _ -> Type Int
		| BoolLit _ -> Type Bool
		
		| Null -> Type Void
		
		| Assignment( scope, variableType, varName, exp )
			-> (* TODO: finish this shit off *)
	in let rec findGlobalVars globalEnv = function
		| Seq( childA, childB ) -> findGlobalVars ( findGlobalVars globalEnv childA ) childB
		
		| VarInitialisation( typeAst, nameAst, expression )
			-> let varName = match nameAst with
				| VarIdentifier str -> str
				| _ -> raise InvalidTreeStructure
			in let ( _, varType ) = checkTypes typeAst
			in TypeBind( varName, varType ) :: globalEnv
		
		| FuncDef( _, _, _, _ ) | Null -> globalEnv
		
		| TypeDec _ | FuncParams( _, _ ) | ParamDec( _, _ )
		| VarIdentifier _ | FuncIdentifier _ | ReturnStmt _
		| IntLit _ | BoolLit _ | Assignment( _, _, )
			-> raise InvalidTreeStructure
			(* This function shouldn't be looking
			inside function definitions, and so
			shouldn't encounter these node types
			*)
	in let globalEnv = findGlobalVars TypeEnv( [], Null ) ast
	in ignore( checkTypes globalEnv ast ); ()
	(* TODO: work out what to finally do with these aux functions *)