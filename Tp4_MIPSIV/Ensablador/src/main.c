#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include "../libs/instruction_set.h"

#define LINE_LENGTH 128

typedef struct _R_instruction
{
    unsigned char opcode [6] ;
    unsigned char rs [5];
    unsigned char rt [5];
    unsigned char rd [5];
    unsigned char sa [5];
    unsigned char function [6];

}R_instruction;


void read_asm(const char* filename)
{
    FILE* fp;
    char* line = malloc(LINE_LENGTH);

    fp=fopen(filename,"r");
    if(fp==NULL)
    {
        fprintf(stderr,"Error al abrir el archivo\n");
        return;
    }
    while(fgets(line, LINE_LENGTH,fp)) 
    {

    }
    fclose(fp);
}

int main (int argc, char *argv[])
{
  if(argc < 2)
  {
    fprintf(stderr,"-Error : No se especifico ningun archivo de entrada\nUso : %s input_filepath.asm \n-Option : -o outputname\n",argv[0]);
    return 1; 
  }
  else if(argc != 2 || argc != 4)
  {
    fprintf(stderr,"-Error : Numero de argumentos invalido\n-Uso : %s input_filepath.asm\n-Option : -o outputname\n",argv[0]);
    return 1; 
  }
  else if(argc == 4)
  {
    if(argv[2] != "-o")
    {
      fprintf(stderr,"-Error : Opcion invalida\n-Uso : %s input_filepath.asm\n-Option : -o outputname\n\n",argv[0]);
      return 1; 
    }
  }
    read_asm(argv[1]);
    printf("%u \n",sizeof(R_instruction));
    return 0;
}


