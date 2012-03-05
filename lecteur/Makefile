#Begin Makefile

CAML = $(shell ocamlc -where)

PRG = tegasz
OBJ = FMOD_Err_Check.o FMOD_Wrap.o Caml_To_C.o
INCDIR = -I../fmod/inc -I$(CAML)
LIBDIR = ../fmod/lib
LIBDIR64 = ../fmod/lib64
LIB = ../fmod/lib/libfmodex.so
LIB64 = ../fmod/lib64/libfmodex64.so

GCC = gcc
CFLAG = -O2 -Wall -W -Werror -pedantic -ansi

all : $(PRG)

64 : $(PRG).64 

$(PRG).64 : $(OBJ)
	$(GCC) -shared -Wl,-soname,libCamlToC.so.1 $(CFLAG) $(LIB64) -L$(LIBDIR64) $(OBJ) -o libCamlToC.so.1

$(PRG) : $(OBJ)
	$(GCC) $(CFLAG) $(LIB) -L$(LIBDIR) $(OBJ) -o $(PRG)

%.o : %.c
	$(GCC) -fPIC $(CFLAG) $(INCDIR) -c $<

clean :
	rm *.o
	rm $(PRG)

#End Makefile
