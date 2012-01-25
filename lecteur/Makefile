
PRG = tegasz
OBJ = main.o
CC = gcc
CFLAGS = -O2 -Wall -W -Werror -pedantic -ansi


all : $(PRG)

$(PRG) : $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o $(PRG)
	
%.o : %.c
	$(CC) $(CFLAGS) -c $<
