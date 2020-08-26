BINARY_DIR=bin
LIBRARIES_DIR=libs
SOURCE_DIR=src

DEP = libs/instruction_set.h libs/parser.c

#Binarios
BINAME=ensamblador

CC=gcc
CFLAGS=-std=gnu11  -Wall -pedantic -Wextra -O3

all : ensablador

ensablador : $(SOURCE_DIR)/main.c $(DEP)
	$(CC) $(CFLAGS)  -o $(BINARY_DIR)/$(BINAME) $(SOURCE_DIR)/main.c $(DEP)

run :	
	 .\$(BINARY_DIR)\$(BINAME).exe .\res\instructions.asm

.PHONY: clean
clean :
	rm  -Rf $(BINARY_DIR)