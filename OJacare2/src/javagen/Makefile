#	$Id: Makefile,v 1.3 2004/03/19 20:42:56 henry Exp $	

TOP= ../..
include $(TOP)/Makefile.config

MLINCDIRS = ../common ../check
MODULES = javaType javaArgs javaInit javaMethod javaClass idl_javagen

CMO_OBJS = $(addsuffix .cmo, $(MODULES))
CMX_OBJS = $(addsuffix .cmx, $(MODULES))

INCLUDES = $(addprefix -I , $(MLINCDIRS))

all: byte opt
byte: $(CMO_OBJS)
opt: $(CMX_OBJS)

# R�gles g�n�rales
.SUFFIXES: .ml .mli .cmo .cmi .cmx
.mli.cmi:
	$(OCAMLC) -c $(INCLUDES) $<
.ml.cmo:
	$(OCAMLC) -c $(INCLUDES) $<
.ml.cmx:
	$(OCAMLOPT) -c $(INCLUDES) $< 
clean::
	rm -f *.cm[iox] *.[so] *~ *.annot
realclean::
	echo -n > .depend

# D�pendances
depend:
	$(OCAMLDEP) $(INCLUDES) *.mli *.ml > .depend

include .depend
