(* SPL main.ml *)

open Spl

exception InvalidArguments of string
exception SyntaxError

let parseStream streamLexbuf = try 
		Streamparser.main Streamlexer.main streamLexbuf
	with Parsing.Parse_error
		-> ( print_string "Syntax error in parsing stream data\n"; flush stdout; raise SyntaxError )
	| Failure( message )
		-> ( print_string ( "failure in parsing stream data\n" ^ message ^ "\n" ); flush stdout; raise SyntaxError )

let parseProgram splLexbuf = try
		Splparser.main Spllexer.main splLexbuf
	with Parsing.Parse_error
		-> ( print_string "Syntax error in parsing program\n"; flush stdout; raise SyntaxError )
	| Failure( message )
		-> ( print_string ( "failure in parsing program\n" ^ message ^ "\n" ); flush stdout; raise SyntaxError )

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
		in checkStreamLengths outputStreamWithInit;
		print_string ( string_of_stream outputStreamWithInit );
		flush stdout
	with Parsing.Parse_error -> print_string "Syntax error\n"; flush stdout