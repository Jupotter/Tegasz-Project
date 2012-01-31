#Begin Makefile

PRG = tegasz
OBJ = main.o FMOD_Err_Check.o FMOD_Wrap.o
INCDIR = ../fmod/inc
LIBDIR = ../fmod/lib
LIBDIR64 = ../fmod/lib64
LIB = ../fmod/lib/libfmodex.so
LIB64 = ../fmod/lib64/libfmodex64.so

GCC = gcc
CFLAG = -O2 -Wall -W -Werror -pedantic -ansi

all : $(PRG)

64 : $(PRG).64 

$(PRG).64 : $(OBJ)
	$(GCC) $(CFLAG) $(LIB64) -L$(LIBDIR64) $(OBJ) -o $(PRG)

$(PRG) : $(OBJ)
	$(GCC) $(CFLAG) $(LIB) -L$(LIBDIR) $(OBJ) -o $(PRG)

%.o : %.c
	$(GCC) $(CFLAG) -I$(INCDIR) -c $<

clean :
	rm $(PRG)
	rm *.o

#End Makefile
