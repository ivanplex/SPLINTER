(* SPL main.ml *)

open Spl

exception InvalidArguments of string

let _ = try
		(* Open the channel from which the program will be read *)
		let lexbuf = if Array.length Sys.argv > 1 
			then Lexing.from_channel (open_in Sys.argv.(1))
			else raise (InvalidArguments "The interpreter requires the filename of an spl program as an argument")
		(* Lex/parse the program *)
		in let result = Splparser.main Spllexer.main lexbuf
		(* Typecheck the program *)
		in typeCheck result;
		   print_string ( ( prettyPrint result ) ^ "\n" );
		   flush stdout
	with Parsing.Parse_error -> print_string "Syntax error\n"; flush stdout