BINARY_DIR=bin
LIBRARIES_DIR=libs
SOURCE_DIR=src

DEP = libs/instruction_set.h libs/parser.c

#Binarios
BINAME=ensamblador

CC=gcc
CFLAGS=-std=gnu11  -Wall -Werror -pedantic -Wextra -Wconversion  -O3 -g

all : ensablador

ensablador : $(SOURCE_DIR)/main.c $(DEP)
	mkdir -p $(BINARY_DIR)
	$(CC) $(CFLAGS)  -o $(BINARY_DIR)/$(BINAME) $(SOURCE_DIR)/main.c $(DEP)

run :	
	 ./$(BINARY_DIR)/$(BINAME) $$arg

.PHONY: clean
clean :
	rm  -Rf $(BINARY_DIR)