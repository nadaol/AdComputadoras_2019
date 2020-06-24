#include "../libs/instruction_set.h"


int main (int argc, char *argv[])
{
  if(argc < 2)
  {
    fprintf(stderr,"-Error : No se especifico ningun archivo de entrada\nUso : %s input_filepath.asm \n-Option : -o outputname\n",argv[0]);
    return 1; 
  }
  else if(argc != 2 && argc != 4)
  {
    fprintf(stderr,"-Error : Numero de argumentos (%d) invalido\n-Uso : %s input_filepath.asm\n-Option : -o outputname\n",argc,argv[0]);
    return 1; 
  }
  else if(argc == 4)
  {
    if(strcmp(argv[2],"-o") != 0)
    {
      fprintf(stderr,"-Error : Opcion invalida\n-Uso : %s input_filepath.asm\n-Option : -o outputname\n\n",argv[0]);
      return 1; 
    }
    parse_asm(argv[1],argv[3]);
  }
  else
  {
    parse_asm(argv[1],"out.coe");
  }
  return 0;
}


