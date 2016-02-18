let in_channel = open_in "file.spl" in
try
  while true do
    let line = input_line in_channel in
    print_endline line;
  done
with End_of_file ->
  close_in in_channel
