#Begin Makefile

CAML = $(shell ocamlc -where)


OBJ = FMOD_Err_Check.o FMOD_Wrap.o Caml_To_C.o
ML = interface.ml

PRG = projet
CMLTOC = libCamlToC.so
INCDIR = -I../fmod/inc -I$(CAML)
LIBDIR = ../fmod/lib
LIBDIR64 = ../fmod/lib64
LIB = ../fmod/lib/libfmodex.so
LIB64 = ../fmod/lib64/libfmodex64.so

GCC = gcc
CFLAG = -O2 -Wall -W -Werror -pedantic -ansi

all : $(PRG)

$(PRG) : $(CMLTOC) $(ML)
	ocamlc -w s -I +lablgtk2 lablgtk.cma str.cma  $(ML) -dllib ./libCamlToC.so -o $(PRG)

$(CMLTOC) : $(OBJ)
	$(GCC) -shared -Wl,-soname,libCamlToC.so $(CFLAG) $(LIB64) -L$(LIBDIR64) $(OBJ) -o libCamlToC.so

%.o : %.c
	$(GCC) -fPIC $(CFLAG) $(INCDIR) -c $<

install : $(PRG)
	cp ./projet /usr/bin/
	cp ./libCamlToC.so /usr/lib

clean :
	rm *.o
	rm *.so
	rm *.cm*
	rm $(PRG)

#End Makefile
