@echo off
echo compiling SPL


:: produces spllexer.ml
echo spllexer.mll
ocamllex spllexer.mll

:: produces splparser.ml & splparser.mli
echo splparser.mly
ocamlyacc splparser.mly

:: produces spl.cmi
echo spl.mli
ocamlc -c spl.mli

:: produces splparser.cmi (?)
echo splparser.mli
ocamlc -c splparser.mli

:: produces splparser.cmo (?)
echo splparser.ml
ocamlc -c splparser.ml

:: produces spllexer.cmo & spllexer.cmi
echo spllexer.ml
ocamlc -c spllexer.ml

:: produces spl.cmo
echo spl.ml
ocamlc -c spl.ml

:: produces main.cmo & main.cmi
echo main.ml
ocamlc -c main.ml

echo linking executable

:: produces splinterpreter.exe
ocamlc -o splinterpreter.exe  splparser.cmo spllexer.cmo spl.cmo main.cmo

echo removing temporary files
del spllexer.ml
del splparser.ml
del splparser.mli
del spl.cmi
del splparser.cmi
del splparser.cmo
del spllexer.cmi
del spllexer.cmo
del spl.cmo
del main.cmo
del main.cmi