#Begin Makefile

PRG = tegasz
OBJ = main.o FMOD_Err_Check.o
INCDIR = ../fmod/inc
LIBDIR = ../fmod/lib
LIB = ../fmod/lib/libfmodex.so

GCC = gcc
CFLAG = -O2 -Wall -W -Werror -pedantic -ansi

all : $(PRG)

$(PRG) : $(OBJ)
	$(GCC) $(CFLAG) $(LIB) -L$(LIBDIR) $(OBJ) -o $(PRG)

%.o : %.c
	$(GCC) $(CFLAG) -I$(INCDIR) -c $<

clean :
	rm $(PRG)
	rm *.o

#End Makefile
