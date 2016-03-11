#!/bin/bash
echo "compiling SPL"


#produces spllexer.ml
echo "spllexer.mll"
ocamllex spllexer.mll

#produces splparser.ml & splparser.mli
echo "splparser.mly"
ocamlyacc splparser.mly

#produces spl.cmi
echo "spl.mli"
ocamlc -c spl.mli

#produces splparser.cmi
echo "splparser.mli"
ocamlc -c splparser.mli

#produces splparser.cmo
echo "splparser.ml"
ocamlc -c splparser.ml

#produces spllexer.cmo & spllexer.cmi
echo "spllexer.ml"
ocamlc -c spllexer.ml

#produces spl.cmo
echo "spl.ml"
ocamlc -c spl.ml

#produces main.cmo & main.cmi
echo "main.ml"
ocamlc -c main.ml

echo "linking executable"

#produces splinterpreter.exe
ocamlc -o splinterpreter splparser.cmo spllexer.cmo spl.cmo main.cmo

echo "removing temporary files"
rm spllexer.ml
rm splparser.ml
rm splparser.mli
rm spl.cmi
rm splparser.cmi
rm splparser.cmo
rm spllexer.cmi
rm spllexer.cmo
rm spl.cmo
rm main.cmo
rm main.cmi
