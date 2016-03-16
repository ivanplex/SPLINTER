(* SPL main.ml *)

open Spl

exception InvalidArguments of string
exception SyntaxError

let parseStream streamLexbuf = try 
		Streamparser.main Streamlexer.main streamLexbuf
	with Parsing.Parse_error
		-> ( prerr_string "Syntax error in parsing stream data\n"; flush stderr; raise SyntaxError )
	| Failure( message )
		-> ( prerr_string ( "failure in parsing stream data\n" ^ message ^ "\n" ); flush stderr; raise SyntaxError )

let parseProgram splLexbuf = try
		Splparser.main Spllexer.main splLexbuf
	with Parsing.Parse_error
		-> ( prerr_string "Syntax error in parsing program\n"; flush stderr; raise SyntaxError )
	| Failure( message )
		-> ( prerr_string ( "failure in parsing program\n" ^ message ^ "\n" ); flush stderr; raise SyntaxError )

let rec int32listToVariableList = function
	| value :: tail -> IntVal value :: int32listToVariableList tail
	| [] -> []

let rec loopThroughInput globalEnv inputStream outputStream = match inputStream with
	| inputList :: tail
		-> let streamData = Array.of_list ( int32listToVariableList inputList )
		in let _, newOutputStream = executeFunction globalEnv "Loop" [ ListVal( ref( Array.length streamData ), ref streamData ) ] outputStream
		in loopThroughInput globalEnv tail newOutputStream
	| [] -> outputStream

let _ = try
		(* Open the channel from which the program will be read *)
		let splLexbuf = if Array.length Sys.argv > 1 
			then Lexing.from_channel (open_in Sys.argv.(1))
			else raise (InvalidArguments "The interpreter requires the filename of an spl program as an argument")
		(* Lex/parse the program *)
		in let result = parseProgram splLexbuf
		(* Typecheck the program *)
		in typeCheck result;
		(* print_string ( ( prettyPrint result ) ^ "\n" ); *)
		let globalEnv = populateEnvironmentInitialState (Env( [], [], Null )) result
		in (* print_string "Done initialising global env\n"; *)
		let streamLexbuf = Lexing.from_channel stdin
		in let stream = parseStream streamLexbuf
		in let _, outputStreamWithInit = executeFunction globalEnv "Init" [] []
		in let outputStreamWithLoop = loopThroughInput globalEnv stream outputStreamWithInit
		in let _, outputStreamWithFinal = executeFunction globalEnv "Final" [] outputStreamWithLoop
		in checkStreamLengths outputStreamWithFinal;
		print_string ( string_of_stream ( List.rev outputStreamWithFinal ) );
		flush stdout
	with Parsing.Parse_error -> prerr_string "Syntax error\n"; flush stderr