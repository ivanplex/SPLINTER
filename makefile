OBJS = splparser.cmo spllexer.cmo streamparser.cmo streamlexer.cmo spl.cmo main.cmo

DEPEND += streamlexer.ml streamparser.ml spllexer.ml splparser.ml

all: $(DEPEND) $(OBJS) mysplinterpreter

include .depend

mysplinterpreter: $(OBJS) main.cmo
	@echo Linking $@
	ocamlc -o $@ $(OBJS)

%.cmi: %.mli
	ocamlc -c $<

%.cmo: %.ml
	ocamlc -c $<

streamparser.ml streamparser.mli: streamparser.mly
	@rm -f streamparser.ml streamparser.mli
	ocamlyacc streamparser.mly

splparser.ml splparser.mli: splparser.mly
	@rm -f splparser.ml splparser.mli
	ocamlyacc splparser.mly

# %.ml %.mli: %.mly
	# @rm -f $@
	# ocamlyacc @<
	
%.ml %.mli: %.mll
	@rm -f $@
	ocamllex $<

clean::
	rm -f streamlexer.ml spllexer.ml streamparser.ml streamparser.mli splparser.ml splparser.mli *.cmo *.cmi \
	   c TAGS *~ 

depend:: $(DEPEND) 
	ocamldep $(INCLUDE) *.mli *.ml > .depend