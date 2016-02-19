(* https://ocaml.org/learn/tutorials/streams.html
 * Read file as a stream from file.spl 
 *
 *)

let line_stream_of_channel channel =
    Stream.from
      (fun _ ->
         try Some (input_line channel) with End_of_file -> None);;

let process_line line =
    print_endline line
  
let process_lines lines =
    Stream.iter process_line lines
  
let process_file filename =
    let in_channel = open_in filename in
	    try
	      process_lines (line_stream_of_channel in_channel);
	      close_in in_channel
	    with e ->
	      close_in in_channel;
	      raise e;;


process_file Sys.argv.(1);;		(* Process file with given filename using command line argument *)