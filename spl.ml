
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
	| ListVal of int ref * variable array ref (* int value is length *)

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
	(* name, return type declaration, params declaration, function body *)
	| FuncDef of ast * ast * ast * ast
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
	| OutputStmt of ast
	
	| IntLit of int32
	| BoolLit of bool
	
	| Assignment of ast * ast (* VarIdentifier, expression *)
	
	(* type, name, expression *)
	| VarInitialisation of ast * ast * ast
	| ArrayLit of ast list
	| ArrayIndex of ast * ast (* array name VarIdentifier, index number *)
	
	(* left side * right side *)
	| Plus of ast * ast
	| Minus of ast * ast
	| Times of ast * ast
	| Div of ast * ast

type funcBinding = 
	FuncBinding of string * ast (* should be the FuncDef ast node *)

type environment =
	| Env of binding list * funcBinding list * environment
	| Null


exception InvalidTyping of string
exception UnboundVariable of string
exception InvalidTreeStructure of string * ast
exception NullEnvironment
exception IncorrectNumberOfParameters
exception InvalidStream of string
exception ListIndexOutOfBounds

let checkStreamLengths stream =
	let rec aux = function
		| head :: tail -> let nextLen = aux tail
			and len = List.length head
			in if len == nextLen || nextLen == -1
				then len
				else raise ( InvalidStream "streams must be of equal length" )
		| [] -> -1
	in ignore( aux stream )

let string_list_join l delimiter =
	let conc prev next = prev ^ delimiter ^ next
	in let result = List.fold_left conc "" l
	(* now trim the leading delimiter *)
	in let len = String.length result
	and dellen = String.length delimiter
	in String.sub result dellen (len - dellen)

let string_of_stream = function
	| [] -> ""
	| int32ll ->
		let int32l_to_string l =
			string_list_join (List.map Int32.to_string l) " "
		in ( string_list_join (List.map int32l_to_string int32ll) "\n" ) ^ "\n"


let rec string_of_var = function
	| IntVal num -> Int32.to_string num
	| BoolVal boolean -> string_of_bool boolean
	| VoidVal -> "void"
	| ListVal( length, arrRef ) -> let rec aux = function
			| [ value ] -> string_of_var value
			| value :: tail -> string_of_var value ^ ", " ^ aux tail
			| [] -> ""
		in "[ " ^ aux ( Array.to_list !arrRef ) ^ " ]"

let rec varLookup env name = let rec aux = function
		| Binding( varName, valRef ) :: _ when ( String.compare varName name ) == 0
			-> valRef
		| _ :: tail -> aux tail
		| [] -> raise (UnboundVariable name)
	in let varBindings, parentEnv = match env with
		| Env( varBindings, _, parentEnv ) -> varBindings, parentEnv
		| Null -> raise ( UnboundVariable name )
	in try aux varBindings
	with UnboundVariable _ -> varLookup parentEnv name

let rec funcLookup env name = let rec aux = function
		| FuncBinding( funcName, func ) :: _ when ( String.compare funcName name ) == 0
			-> func
		| _ :: tail -> aux tail
		| [] -> raise (UnboundVariable name)
	in let funcBindings, parentEnv = match env with
		| Env( _, funcBindings, parentEnv ) -> funcBindings, parentEnv
		| Null -> raise ( UnboundVariable name )
	in try aux funcBindings
	with UnboundVariable _ -> funcLookup parentEnv name

let addFuncToEnv env funcDef = let name = match funcDef with
		| FuncDef( FuncIdentifier name, _, _, _ ) -> name
		| node -> raise ( InvalidTreeStructure ( "Unexpected function structure in addFuncToEnv", node ) )
	in let vars, funcs, parent = match env with
		| Env( vars, funcs, parent ) -> vars, funcs, parent
		| Null -> raise NullEnvironment
	in Env( vars, FuncBinding( name, funcDef ) :: funcs, parent )

let addVarToEnv env name value = let vars, funcs, parent = match env with
		| Env( vars, funcs, parent ) -> vars, funcs, parent
		| Null -> raise NullEnvironment
	in Env( Binding( name, ref value ) :: vars, funcs, parent )

let rec getGlobalEnv = function
	| Env( _, _, parent ) as env -> ( try getGlobalEnv parent
		with NullEnvironment -> env )
	| Null -> raise NullEnvironment

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
		| OutputStmt( tree ) -> tabs i ^ "output " ^ ( aux i tree ) ^ ";"
		
		| IntLit( value ) -> Int32.to_string value
		| BoolLit( value ) -> string_of_bool value
		
		| Assignment( id, expr ) -> tabs i ^ ( aux i id ) ^ " = " ^ ( aux i expr ) ^ ";"
		| VarInitialisation( typing, id, expr ) -> tabs i ^ ( aux i typing ) ^ " " ^ ( aux 0 ( Assignment( id, expr ) ) )
		| ArrayLit( elementList ) -> let rec arrayAux = ( function
				| [ element ] -> aux i element
				| element :: tail -> ( aux i element ) ^ "," ^ ( arrayAux tail )
				| [] -> "" )
			in "[" ^ ( arrayAux elementList ) ^ "]"
		| Plus( left, right ) -> aux i left ^ " + " ^ aux i right
		| Minus( left, right ) -> aux i left ^ " - " ^ aux i right
		| Times( left, right ) -> aux i left ^ " * " ^ aux i right
		| Div( left, right ) -> aux i left ^ " / " ^ aux i right
		| ArrayIndex( arr, idx ) -> aux i arr ^ "[" ^ aux i idx ^ "]"
		
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
				| ( typeNode, _ ) -> raise ( InvalidTreeStructure ( "Unexpected values type-checking FuncDef node", typeNode ) ) )
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
				| node -> raise ( InvalidTreeStructure ( "Non-VarIdentifier ast node as name in VarIdentifier", node)  )
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
		| OutputStmt( exp ) -> ( match checkTypes env exp with
			| env2, Type( List( Int ) ) -> env2, Type( List( Int ) )
			| _, Type _ -> raise ( InvalidTyping "Can only output a list of ints" )
			| _, ReturnType _ -> raise ( InvalidTyping "Cannot output a returned value" ) )
		
		
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
				| node -> raise ( InvalidTreeStructure ( "Non-VarIdentifier name ast node in VarInitialisation", node ) )
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
		| ArrayIndex( arr, idx ) -> let envWithArr, arrType = checkTypes env arr
			in let envWithIdx, idxType = checkTypes envWithArr idx
			in ( match arrType, idxType with
				| Type( List t ), Type( Int ) -> envWithIdx, Type t
				| Type( _ ), Type( Int ) -> raise ( InvalidTyping "Cannot index a non-list" )
				| _, Type( _ ) -> raise ( InvalidTyping "Cannot use a non-int to index an array" )
				| ReturnType _, _ | _, ReturnType _ -> raise ( InvalidTyping "Cannot perform array indexing using a returned value" ) )
		(* Type check all of the integer operations the same way *)
		| Plus( leftSide, rightSide ) | Minus( leftSide, rightSide )
		| Times( leftSide, rightSide ) | Div( leftSide, rightSide )
				-> let envWithLeftSide, leftType = checkTypes env leftSide
				in let envWithBothSides, rightType = checkTypes envWithLeftSide rightSide
				in ( match leftType, rightType with
					| Type Int, Type Int -> envWithBothSides, Type Int
					| Type _, Type _ -> raise ( InvalidTyping "Attempted to add non-integer value" )
					| ReturnType _, _ | _, ReturnType _ -> raise ( InvalidTyping "Cannot add a returned value" ) )
		
	in let rec findGlobalVars globalEnv = function
		| Seq( childA, childB ) -> findGlobalVars ( findGlobalVars globalEnv childA ) childB
		
		| VarInitialisation( typeAst, nameAst, expression )
			-> let varName = match nameAst with
				| VarIdentifier str -> str
				| node -> raise ( InvalidTreeStructure ( "Non-VarIdentifier ast node as name in VarInitialisation", node ) )
			in let ( _, varType ) = checkTypes globalEnv typeAst
			in addBindingToTypeEnv ( TypeBind( varName, getType varType ) ) globalEnv
		
		| FuncDef( _, _, _, _ ) | Null -> globalEnv
		
		| node
			-> raise ( InvalidTreeStructure ( "Unexpected ast node when finding global variables for type checking", node ) )
			(* This function shouldn't be looking 
			inside function definitions, and so
			shouldn't encounter these node types *)
	in let globalEnv = findGlobalVars ( TypeEnv( [], Null ) ) ast
	in ignore( checkTypes globalEnv ast ); ()

let extendArray len arrRef reqLen = 
	if Array.length !arrRef >= reqLen
	then ( if reqLen > !len
		then ( len := reqLen )
		else () )
	else ( let newArr = Array.make reqLen VoidVal
	in for i = 0 to !len - 1 do
		newArr.(i) <- !arrRef.(i)
	done; 
	arrRef := newArr;
	len := reqLen )

let rec eval env ast outputStreamAcc = match ast with
	| Seq( leftSide, rightSide ) -> ( match eval env leftSide outputStreamAcc with
			| envWithLeftSide, ( ReturnedVal _ as t ), outputStream -> envWithLeftSide, t, outputStream
			| envWithLeftSide, Value _, outputStream -> eval envWithLeftSide rightSide outputStream )
	| FuncDef( funcId, declaredType, params, body ) as def
		-> addFuncToEnv env def, Value VoidVal, outputStreamAcc
	| VarIdentifier name -> env, Value !( varLookup env name ), outputStreamAcc
	| ReturnStmt exp -> let envWithValue, value, outputStream = eval env exp outputStreamAcc
		in let rtnVal = match value with
			| Value variable -> ReturnedVal variable
			| ReturnedVal _ -> raise ( InvalidTyping "Cannot return an already returned value" )
		in envWithValue, rtnVal, outputStream
	| OutputStmt exp -> let envWithValue, value, outputStreamWithValue = eval env exp outputStreamAcc
		in let appendedOutputStream = match value with
			| Value( ListVal( length, values ) ) -> let varToInt32 = function
					| IntVal value -> value
					| _ -> raise ( InvalidTyping "Can only output a list of ints to the output stream" )
				in let output = List.map varToInt32 ( Array.to_list !values )
				in output :: outputStreamWithValue
			| _ -> raise ( InvalidTyping "Can only output a list of ints to the output stream" )
		in envWithValue, value, appendedOutputStream
	| IntLit value -> env, Value ( IntVal value ), outputStreamAcc
	| BoolLit value -> env, Value ( BoolVal value ), outputStreamAcc
	| ArrayLit exprsList -> let rec evalElements env tail outputStreamAcc = match tail with
			| expr :: tail -> let envWithElement, value, outputStreamWithElement = match eval env expr outputStreamAcc with
					| env, Value v, outputStream -> env, v, outputStream
					| _, ReturnedVal _, _ -> raise ( InvalidTyping "Cannot return inside a list" )
				in let envWithTail, valueTail, outputStreamWithTail = evalElements envWithElement tail outputStreamAcc
				in envWithTail, ( value :: valueTail ), outputStreamWithTail
			| [] -> env, [], outputStreamAcc
		in let envWithElements, elementList, outputStreamWithElements = evalElements env exprsList outputStreamAcc
		in envWithElements, Value ( ListVal( ref ( List.length elementList ), ref ( Array.of_list elementList ) ) ), outputStreamWithElements
	| ArrayIndex( arr, idx ) -> let envWithArr, arrayVar, outputStreamWithArr = eval env arr outputStreamAcc
		in let envWithIdx, idxVar, outputStreamWithIdx = eval envWithArr idx outputStreamWithArr
		in let listLen, listArr = match arrayVar with
			| Value( ListVal( length, arr ) ) -> !length, !arr
			| _ -> raise ( InvalidTyping "Cannot index a non-array variable" )
		in let idxInt = match idxVar with
			| Value( IntVal i ) -> Int32.to_int i
			| _ -> raise ( InvalidTyping "Cannot index an array with a non-int" )
		in if listLen >= idxInt then envWithIdx, Value( listArr.( idxInt ) ), outputStreamWithIdx
		else raise ListIndexOutOfBounds
	| Assignment( VarIdentifier( name ), expr )
		-> let envWithExpr, value, outputStreamWithExpr = match eval env expr outputStreamAcc with
			| exp, Value v, output -> exp, v, output
			| _, ReturnedVal _, _ -> raise ( InvalidTyping "Cannot return when performing an assignment" )
		in ( varLookup env name ) := value;
		envWithExpr, Value value, outputStreamWithExpr
	| Assignment( ArrayIndex( arr, idx ), exp ) 
		-> let envWithArr, arrayVar, outputStreamWithArr = eval env arr outputStreamAcc
		in let envWithIdx, idxVar, outputStreamWithIdx = eval envWithArr idx outputStreamWithArr
		in let envWithExp, valueVar, outputStreamWithExpr = eval envWithIdx exp outputStreamWithIdx
		in let listLen, listArr = match arrayVar with
			| Value( ListVal( len, arr ) ) -> len, arr
			| _ -> raise ( InvalidTyping "Cannot index a non-array variable" )
		in let idxInt = match idxVar with
			| Value( IntVal i ) -> Int32.to_int i
			| _ -> raise ( InvalidTyping "Cannot index an array with a non-int" )
		in let value = match valueVar with
			| Value x -> x
			| ReturnedVal _ -> raise ( InvalidTyping "Cannot assign a returned value" )
		in extendArray listLen listArr ( idxInt + 1 );
		!listArr.( idxInt ) <- value;
		envWithExp, valueVar, outputStreamWithExpr
		
	| Assignment( _, _ ) as node -> raise ( InvalidTreeStructure ( "Invalid expression in left hand side of assignment ", node ) )
	| VarInitialisation( _, VarIdentifier( name ), expr )
		-> let envWithValue, value, outputStreamWithValue = match eval env expr outputStreamAcc with
			| env, Value v, output -> env, v, output
			| _, ReturnedVal _, _ -> raise ( InvalidTyping "Cannot return when initialising a variable" )
		in addVarToEnv envWithValue name value, Value( value ), outputStreamWithValue
	| VarInitialisation( _, _, _ ) as node -> raise ( InvalidTreeStructure ( "VarInitialisation with non-VarIdentifier as name ast", node ) )
	
	| FuncParams( _, _ ) | ParamDec( _, _ ) 
	| TypeDec _ | Null | FuncIdentifier _
		-> env, Value VoidVal, outputStreamAcc
	
	(* TODO: (maybe) generalise some of the below cases. They're almost entirely the same *)
	| Plus( left, right ) -> let envWithLeft, leftValue, outputStreamWithLeft = eval env left outputStreamAcc
		in let envWithRight, rightValue, outputStreamWithRight = eval envWithLeft right outputStreamWithLeft
		in ( match leftValue, rightValue with
			| Value( IntVal leftInt ), Value( IntVal rightInt ) -> envWithRight, Value( IntVal( Int32.add leftInt rightInt ) ), outputStreamWithRight
			| _ -> raise ( InvalidTyping "Unexpected typing when evaluating plus" ) )
	| Minus( left, right ) -> let envWithLeft, leftValue, outputStreamWithLeft = eval env left outputStreamAcc
		in let envWithRight, rightValue, outputStreamWithRight = eval envWithLeft right outputStreamWithLeft
		in ( match leftValue, rightValue with
			| Value( IntVal leftInt ), Value( IntVal rightInt ) -> envWithRight, Value( IntVal( Int32.sub leftInt rightInt ) ), outputStreamWithRight
			| _ -> raise ( InvalidTyping "Unexpected typing when evaluating minus" ) )
	| Times( left, right ) -> let envWithLeft, leftValue, outputStreamWithLeft = eval env left outputStreamAcc
		in let envWithRight, rightValue, outputStreamWithRight = eval envWithLeft right outputStreamWithLeft
		in ( match leftValue, rightValue with
			| Value( IntVal leftInt ), Value( IntVal rightInt ) -> envWithRight, Value( IntVal( Int32.mul leftInt rightInt ) ), outputStreamWithRight
			| _ -> raise ( InvalidTyping "Unexpected typing when evaluating times" ) )
	| Div( left, right ) -> let envWithLeft, leftValue, outputStreamWithLeft = eval env left outputStreamAcc
		in let envWithRight, rightValue, outputStreamWithRight = eval envWithLeft right outputStreamWithLeft
		in ( match leftValue, rightValue with
			| Value( IntVal leftInt ), Value( IntVal rightInt ) -> envWithRight, Value( IntVal( Int32.div leftInt rightInt ) ), outputStreamWithRight
			| _ -> raise ( InvalidTyping "Unexpected typing when evaluating div" ) )
 

let flattenParamDecs params = let rec aux acc = function
		| ParamDec( _, _ ) as param -> param :: acc
		| FuncParams( leftBranch, rightBranch )
			-> let accWithLeft = aux acc leftBranch
			in aux accWithLeft rightBranch
		| Null -> acc
		| node -> raise ( InvalidTreeStructure ( "Unexpected ast node when flattening param declarations", node ) )
	in aux [] params

let populateEnvironmentInitialState env ast =
	let populatedEnv, _, _ = eval env ast []
	in populatedEnv

let executeFunction env funcName paramList outputStreamAcc =
	let paramDeclarations, functionBody = match funcLookup env funcName with
		| FuncDef( _, _, paramDeclarations, functionBody ) -> paramDeclarations, functionBody
		| node -> raise ( InvalidTreeStructure ( "Received non-FuncDef ast from funcLookup", node ) )
	in let rec addParameterBindings env paramDeclarations paramList =
		match paramDeclarations, paramList with
			| ( ParamDec( _, VarIdentifier name ) :: decsTail, value :: valuesTail )
				-> addParameterBindings ( addVarToEnv env name value ) decsTail valuesTail
			| ( node :: _, _ :: _ ) -> raise ( InvalidTreeStructure ( "Invalid parameter structure when assigning parameter values", node ) )
			| ( [], [] ) -> env
			| ( _ :: _, [] ) | ( [], _ :: _ ) -> raise IncorrectNumberOfParameters
	in let localEnv = addParameterBindings (Env( [], [], getGlobalEnv env )) ( flattenParamDecs paramDeclarations ) paramList
	in match eval localEnv functionBody outputStreamAcc with
		| _, Value v, outputStream -> VoidVal, outputStream
		| _, ReturnedVal v, outputStream -> v, outputStream
