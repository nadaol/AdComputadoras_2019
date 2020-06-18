#include "instruction_set.h"

///Array of supported instructions
instruction_set supported_ins [NSUPORTED_INST] =
{
///R-type supported Instructions (code = function)
{
    .name = "SLL",
    .format = R_FORMAT,
    .code = "000000"
},
{
    .name = "SRL",
    .format = R_FORMAT,
    .code = "000010"
},
{
    .name = "SRA",
    .format = R_FORMAT,
    .code = "000011"
},  
{
    .name = "SRLV",
    .format = R_FORMAT,
    .code = "000110"
},  
{
    .name = "SRAV",
    .format = R_FORMAT,
    .code = "000111"
},  
{
    .name = "ADD",
    .format = R_FORMAT,
    .code = "100000"
},  
{
    .name = "SLLV",
    .format = R_FORMAT,
    .code = "000100"
},  
{
    .name = "SUB",
    .format = R_FORMAT,
    .code = "100010"
},  
{
    .name = "AND",
    .format = R_FORMAT,
    .code = "100100"
},  
{
    .name = "OR",
    .format = R_FORMAT,
    .code = "100101"
},  
{
    .name = "XOR",
    .format = R_FORMAT,
    .code = "100110"
},  
{
    .name = "NOR",
    .format = R_FORMAT,
    .code = "100111"
}, 
{
    .name = "SLT",
    .format = R_FORMAT,
    .code = "101010"
},
///I-type supported Instructions (code = opcode)
{
    .name = "LB",
    .format = I_FORMAT,
    .code = "100000"
},
{
    .name = "LH",
    .format = I_FORMAT,
    .code = "100001"
},
{
    .name = "LW",
    .format = I_FORMAT,
    .code = "100011"
},
{
    .name = "LWU",
    .format = I_FORMAT,
    .code = "100111"
},
{
    .name = "LBU",
    .format = I_FORMAT,
    .code = "100100"
},
{
    .name = "LHU",
    .format = I_FORMAT,
    .code = "100101"
},
{
    .name = "SB",
    .format = I_FORMAT,
    .code = "101000"
},
{
    .name = "SH",
    .format = I_FORMAT,
    .code = "101001"
},
{
    .name = "SW",
    .format = I_FORMAT,
    .code = "101011"
},
{
    .name = "ADDI",
    .format = I_FORMAT,
    .code = "001000"
},
{
    .name = "AND",
    .format = I_FORMAT,
    .code = "001100"
},
{
    .name = "ORI",
    .format = I_FORMAT,
    .code = "001101"
},
{
    .name = "XORI",
    .format = I_FORMAT,
    .code = "001110"
},
{
    .name = "LWI",
    .format = I_FORMAT,
    .code = "001111"
},
{
    .name = "SLTI",
    .format = I_FORMAT,
    .code = "001010"
},
{
    .name = "BEQ",
    .format = I_FORMAT,
    .code = "000100"
},
{
    .name = "BNE",
    .format = I_FORMAT,
    .code = "000101"
},
{
    .name = "J",
    .format = I_FORMAT,
    .code = "000010"
},
{
    .name = "JAL",
    .format = I_FORMAT,
    .code = "000011"
},
///J-TYPE supported instructions (code = last 6 bits)
{
    .name = "JR",
    .format = J_FORMAT,
    .code = "001000"
},
{
    .name = "JALR",
    .format = J_FORMAT,
    .code = "001001"
},
};

///Buffer sizes for file reading
#define LINE_LENGTH 128
#define WORD_LENGTH 32


int get_inst_index(char* instruction_name)
{
    for(int i=0;i<NSUPORTED_INST;i++)
    {

        if(strcmp(supported_ins[i].name,instruction_name) == 0)
        {
            return i;
        }
    }
    return -1;
}

void write_inst(char* instruction , FILE* fp_out)
{
    char* instruction_name = malloc(WORD_LENGTH);
    if(instruction_name == NULL)
    {
        perror("Error al alocar memoria");
        exit(EXIT_FAILURE);
    }

    int inst_index = get_inst_index(instruction_name);
    printf("index %d\n",inst_index);
    switch (supported_ins[inst_index].format)
    {

    case R_FORMAT:
        {   
            R_instruction* inst = malloc(sizeof(R_instruction));
            strcpy(inst->opcode,"0");
            strcpy(inst->function,supported_ins[inst_index].code);
            sscanf(instruction,RFORMAT,inst->rd,inst->rt,inst->sa);
            printf("instruction : %s , rd : %s rd : %s sa : %s\n",instruction_name,inst->rd,inst->rt,inst->sa);
            fwrite(inst,sizeof(R_instruction),1,fp_out);
            break;
        }

    case I_FORMAT:
        /* code */
        break;

    case J_FORMAT:
        /* code */
        break;
    
    default:
        printf("Error not implemented format\n");
        exit(EXIT_FAILURE);
    }

    free(instruction_name);
}

void parse_asm(const char* in_file,const char* out_file)
{
    FILE* fp_in;
    FILE* fp_out;
    char* line = malloc(LINE_LENGTH);

    fp_in=fopen(in_file,"r");
    fp_out = fopen(out_file,"w+");
    if(fp_in ==NULL || fp_out == NULL)
    {
        fprintf(stderr,"Error al abrir el archivo\n");
        return;
    }

    while(fgets(line, LINE_LENGTH,fp_in)) 
    {
        write_inst(line,fp_out);
    }
    free(line);
    fclose(fp_in);
    fclose(fp_out);
}