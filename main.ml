(* SPL main.ml *)

open Spl

let _ =
	try
		let lexbuf = Lexing.from_channel stdin
		in let result = Splparser.main Spllexer.main lexbuf
		in ignore( typeCheck result);
		   print_string ( ( prettyPrint result ) ^ "\n" );
		   flush stdout
	with Parsing.Parse_error -> print_string "Syntax error\n"; flush stdout