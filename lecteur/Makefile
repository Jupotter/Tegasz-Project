
PRG = tegasz
OBJ = main.o
INCDIR = ../fmod/inc
LIBDIR = ../fmod/lib

GCC = gcc
CFLAG = -O2 -Wall -W -Werror -pedantic -ansi

all : $(PRG)
	@echo All

$(PRG) : $(OBJ)
	@echo Linking
	$(GCC) $(CFLAG) -L$(LIBDIR) $(OBJ) -o $(PRG)

%.o : %.c
	@echo Compiling
	$(GCC) $(CFLAG) -I$(INCDIR) -c $<

