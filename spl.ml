
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


exception InvalidTyping


let rec typeCheck = function
	| Seq( childA, childB )
		-> let typeA = typeCheck childA
		in let typeB = typeCheck childB
		in ( match typeA with
			| ReturnType _ -> typeA
			| _ -> typeB )
	| FuncDef( name, declaredRtnType, params, fnBody )
		(* Once we can call variables and functions, we'll have to actually do something with
		   the name and params, for now they're not relevant to type checking though *)
		-> let observedType = typeCheck fnBody
		in ( match ( declaredRtnType, observedType ) with
			| ( TypeDec ta, ReturnType tb ) -> if ta == tb
				then Type ta
				else raise InvalidTyping
			(* Allow no return statement for void functions *)
			| ( TypeDec Void, Type Void ) -> Type Void
			| ( _, _ ) -> raise InvalidTyping )
	| TypeDec( t ) -> Type t
	
	(* This will need to return parameter typings once I'm doing more with
	   variable names and types, for now, its type is irrelevant *)
	| FuncParams( paramA, paramB )
		(* TODO: Still accepting void params for some reason *)
		-> ignore( typeCheck paramA ); ignore( typeCheck paramB ); Type Void
	| ParamDec( typeTree, paramName ) -> ( match typeCheck typeTree with
		| Type Void -> raise InvalidTyping (* Can't have void parameters *)
		| t -> t ) (* accept anything else *)
	| VarIdentifier _ -> Type Void
	
	(* Again, this will need to actually return a type once function calls are
	   implemented, but for now, it's useless *)
	| FuncIdentifier _ -> Type Void
	
	| ReturnStmt( exp ) -> ( match typeCheck( exp ) with
		| Type t -> ReturnType t
		| ReturnType _ -> raise InvalidTyping )
	
	| IntLit _ -> Type Int
	| BoolLit _ -> Type Bool
	
	| Null -> Type Void
	(* TODO: Finish this *)

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
