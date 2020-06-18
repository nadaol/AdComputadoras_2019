#include "instruction_set.h"

///Array of supported instructions
instruction_set supported_ins [NSUPORTED_INST] =
{
///R-type supported Instructions (code = function)
{
    .name = "SLL",
    .format = RDRTSA_FORMAT,
    .code = 0x00000000
},
{
    .name = "SRL",
    .format = RDRTSA_FORMAT,
    .code = 0x00000002
},
{
    .name = "SRA",
    .format = RDRTSA_FORMAT,
    .code = 0x00000003
},  
{
    .name = "SRLV",
    .format = RDRTRS_FORMAT,
    .code = 0x00000006
},  
{
    .name = "SRAV",
    .format = RDRTRS_FORMAT,
    .code = 0x00000007
},  
{
    .name = "ADD",
    .format = RDRSRT_FORMAT,
    .code = 0x00000020
},  
{
    .name = "SLLV",
    .format = RDRTRS_FORMAT,
    .code = 0x000000004
},  
{
    .name = "SUB",
    .format = RDRSRT_FORMAT,
    .code = 0x00000022
},  
{
    .name = "AND",
    .format = RDRSRT_FORMAT,
    .code = 0x00000024
},  
{
    .name = "OR",
    .format = RDRSRT_FORMAT,
    .code = 0x00000025
},  
{
    .name = "XOR",
    .format = RDRSRT_FORMAT,
    .code = 0x00000026
},  
{
    .name = "NOR",
    .format = RDRSRT_FORMAT,
    .code = 0x00000027
}, 
{
    .name = "SLT",
    .format = RDRSRT_FORMAT,
    .code = 0x0000002A
},
///I-type supported Instructions (code = opcode)
{
    .name = "LB",
    .format = I_FORMAT,
    .code = 0x80000000
},
{
    .name = "LH",
    .format = I_FORMAT,
    .code = 0x84000000
},
{
    .name = "LW",
    .format = I_FORMAT,
    .code = 0X8C000000
},
{
    .name = "LWU",
    .format = I_FORMAT,
    .code = 0X9C000000
},
{
    .name = "LBU",
    .format = I_FORMAT,
    .code = 0X90000000
},
{
    .name = "LHU",
    .format = I_FORMAT,
    .code = 0X94000000
},
{
    .name = "SB",
    .format = I_FORMAT,
    .code = 0XA0000000
},
{
    .name = "SH",
    .format = I_FORMAT,
    .code = 0XA4000000
},
{
    .name = "SW",
    .format = I_FORMAT,
    .code = 0XAC000000
},
{
    .name = "ADDI",
    .format = I_FORMAT,
    .code = 0X20000000
},
{
    .name = "ANDI",
    .format = I_FORMAT,
    .code = 0X30000000
},
{
    .name = "ORI",
    .format = I_FORMAT,
    .code = 0X34000000
},
{
    .name = "XORI",
    .format = I_FORMAT,
    .code = 0X38000000
},
{
    .name = "LUI",
    .format = I_FORMAT,
    .code = 0X3C000000
},
{
    .name = "SLTI",
    .format = I_FORMAT,
    .code = 0X28000000
},
{
    .name = "BEQ",
    .format = I_FORMAT,
    .code = 0X10000000
},
{
    .name = "BNE",
    .format = I_FORMAT,
    .code = 0X14000000
},
{
    .name = "J",
    .format = I_FORMAT,
    .code = 0X08000000
},
{
    .name = "JAL",
    .format = I_FORMAT,
    .code = 0X0C000000
},
///J-TYPE supported instructions (code = last 6 bits)
{
    .name = "JR",
    .format = J_FORMAT,
    .code = 0X00000008
},
{
    .name = "JALR",
    .format = J_FORMAT,
    .code = 0X00000009
},
};

///Buffer sizes for file reading
#define LINE_LENGTH 128
#define WORD_LENGTH 32


int get_inst_index(char* instruction_name)
{
    for(int i=0;i<NSUPORTED_INST;i++)
    {
        if(strcasecmp(supported_ins[i].name,instruction_name) == 0)
        {
            return i;
        }
    }
    return -1;
}

void write_inst(char* instruction , FILE* fp_out ,int line_num)
{
    char* instruction_name = malloc(WORD_LENGTH);
    if(instruction_name == NULL)
    {
        perror("Error al alocar memoria");
        exit(EXIT_FAILURE);
    }
    sscanf(instruction,"%s ",instruction_name);
    int inst_index = get_inst_index(instruction_name);
    if(inst_index < 0)
    {
        fprintf(stderr,"Error Invalid instruction at line %d\n",line_num);
        exit(EXIT_FAILURE);
    }
    switch (supported_ins[inst_index].format)
    {

    case RDRSRT_FORMAT : case RDRTRS_FORMAT : case RDRTSA_FORMAT:
        {   
            R_instruction* inst = calloc(1,sizeof(R_instruction));
            //inst->function = supported_ins[inst_index].code;
            int ret;
            if(supported_ins[inst_index].format == RDRTSA_FORMAT)ret=RDRTSA;
            else if (supported_ins[inst_index].format == RDRSRT_FORMAT)ret=RDRSRT;
            else ret=RDRTRS;
            if(ret<3 || inst->rd > 31 || inst->rs > 31 || inst->rt > 31 || inst->sa > 31)
            {
                fprintf(stderr,"Error Invalid instruction at line %d\n",line_num);
                exit(EXIT_FAILURE);    
            }
            unsigned int instruction = inst->opcode + (inst->rs << RS_OFFSET) + (inst->rt << RT_OFFSET) + (inst->rd << RD_OFFSET) + (inst->sa << SA_OFFSET) + supported_ins[inst_index].code;
            char instruction_hex [WORD_LENGTH] ;
            sprintf(instruction_hex,OUT_FORMAT,instruction);
            printf("instruction : %s , rd : %d rt : %d rs : %d sa : %d code : %s\n",instruction_name,inst->rd,inst->rt,inst->rs,inst->sa,instruction_hex);
            fwrite(&instruction_hex,sizeof(char),10,fp_out);
            break;
        }

    case I_FORMAT:
        //I_instruction* inst = calloc(1,sizeof(I_instruction));
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
    int line_num=1;
    while(fgets(line, LINE_LENGTH,fp_in)) 
    {
        write_inst(line,fp_out,line_num);
        line_num ++;
    }
    free(line);
    fclose(fp_in);
    fclose(fp_out);
}