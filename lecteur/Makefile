#Begin Makefile

CAML = $(shell ocamlc -where)


OBJ = FMOD_Err_Check.o FMOD_Wrap.o Caml_To_C.o
ML = interface.ml

PRG = tegasz
CMLTOC = CamlToC.so
INCDIR = -I../fmod/inc -I$(CAML)
LIBDIR = ../fmod/lib
LIBDIR64 = ../fmod/lib64
LIB = ../fmod/lib/libfmodex.so
LIB64 = ../fmod/lib64/libfmodex64.so

GCC = gcc
CFLAG = -O2 -Wall -W -Werror -pedantic -ansi

all : $(PRG)

$(PRG) : $(CMLTOC)
	ocamlc -w s -I +lablgtk2 lablgtk.cma  $(ML) -dllib $(CMLTOC) -o $(PRG)

$(CMLTOC) : $(OBJ)
	$(GCC) -shared -Wl,-soname,CamlToC.so $(CFLAG) $(LIB64) -L$(LIBDIR64) $(OBJ) -o CamlToC.so

%.o : %.c
	$(GCC) -fPIC $(CFLAG) $(INCDIR) -c $<

clean :
	rm *.so
	rm *.cm*
	rm $(PRG)

#End Makefile
