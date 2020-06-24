#include "instruction_set.h"

///Array of supported instructions based on MIPSIV instruction set
instruction_set supported_ins [NSUPORTED_INST] =
{
///R-type supported Instructions (code = function)
{
    .name = "SLL",
    .format = RDRTSA_FORMAT,
    .structure = R_TYPE,
    .code = 0x00000000
},
{
    .name = "SRL",
    .format = RDRTSA_FORMAT,
    .structure = R_TYPE,
    .code = 0x00000002
},
{
    .name = "SRA",
    .format = RDRTSA_FORMAT,
    .structure = R_TYPE,
    .code = 0x00000003
},  
{
    .name = "SRLV",
    .format = RDRTRS_FORMAT,
    .structure = R_TYPE,
    .code = 0x00000006
},  
{
    .name = "SRAV",
    .format = RDRTRS_FORMAT,
    .structure = R_TYPE,
    .code = 0x00000007
},  
{
    .name = "ADD",
    .format = RDRSRT_FORMAT,
    .structure = R_TYPE,
    .code = 0x00000020
},  
{
    .name = "SLLV",
    .format = RDRTRS_FORMAT,
    .structure = R_TYPE,
    .code = 0x000000004
},  
{
    .name = "SUB",
    .format = RDRSRT_FORMAT,
    .structure = R_TYPE,
    .code = 0x00000022
},  
{
    .name = "AND",
    .format = RDRSRT_FORMAT,
    .structure = R_TYPE,
    .code = 0x00000024
},  
{
    .name = "OR",
    .format = RDRSRT_FORMAT,
    .structure = R_TYPE,
    .code = 0x00000025
},  
{
    .name = "XOR",
    .format = RDRSRT_FORMAT,
    .structure = R_TYPE,
    .code = 0x00000026
},  
{
    .name = "NOR",
    .format = RDRSRT_FORMAT,
    .structure = R_TYPE,
    .code = 0x00000027
}, 
{
    .name = "SLT",
    .format = RDRSRT_FORMAT,
    .structure = R_TYPE,
    .code = 0x0000002A
},
///I-type supported Instructions (code = opcode)
{
    .name = "LB",
    .format = RTOFFBASE_FORMAT,
    .structure = I_TYPE,
    .code = 0x80000000
},
{
    .name = "LH",
    .format = RTOFFBASE_FORMAT,
    .structure = I_TYPE,
    .code = 0x84000000
},
{
    .name = "LW",
    .format = RTOFFBASE_FORMAT,
    .structure = I_TYPE,
    .code = 0X8C000000
},
{
    .name = "LWU",
    .format = RTOFFBASE_FORMAT,
    .structure = I_TYPE,
    .code = 0X9C000000
},
{
    .name = "LBU",
    .format = RTOFFBASE_FORMAT,
    .structure = I_TYPE,
    .code = 0X90000000
},
{
    .name = "LHU",
    .format = RTOFFBASE_FORMAT,
    .structure = I_TYPE,
    .code = 0X94000000
},
{
    .name = "SB",
    .format = RTOFFBASE_FORMAT,
    .structure = I_TYPE,
    .code = 0XA0000000
},
{
    .name = "SH",
    .format = RTOFFBASE_FORMAT,
    .structure = I_TYPE,
    .code = 0XA4000000
},
{
    .name = "SW",
    .format = RTOFFBASE_FORMAT,
    .structure = I_TYPE,
    .code = 0XAC000000
},
{
    .name = "ADDI",
    .format = RTRSIMM_FORMAT,
    .structure = I_TYPE,
    .code = 0X20000000
},
{
    .name = "ANDI",
    .format = RTRSIMM_FORMAT,
    .structure = I_TYPE,
    .code = 0X30000000
},
{
    .name = "ORI",
    .format = RTRSIMM_FORMAT,
    .structure = I_TYPE,
    .code = 0X34000000
},
{
    .name = "XORI",
    .format = RTRSIMM_FORMAT,
    .structure = I_TYPE,
    .code = 0X38000000
},
{
    .name = "LUI",
    .format = RTIMM_FORMAT,
    .structure = I_TYPE,
    .code = 0X3C000000
},
{
    .name = "SLTI",
    .format = RTRSIMM_FORMAT,
    .structure = I_TYPE,
    .code = 0X28000000
},
{
    .name = "BEQ",
    .format = RSRTOFF_FORMAT,
    .structure = I_TYPE,
    .code = 0X10000000
},
{
    .name = "BNE",
    .format = RSRTOFF_FORMAT,
    .structure = I_TYPE,
    .code = 0X14000000
},
{
    .name = "J",
    .format = TARGET_FORMAT,
    .structure = J_TYPE,
    .code = 0X08000000
},
{
    .name = "JAL",
    .format = TARGET_FORMAT,
    .structure = J_TYPE,
    .code = 0X0C000000
},
///J-TYPE supported instructions (code = last 6 bits)
{
    .name = "JR",
    .format = RS_FORMAT,
    .structure = R_TYPE,
    .code = 0X00000008
},
{
    .name = "JALR",
    .format = RDRS_FORMAT,
    .structure = R_TYPE,
    .code = 0X00000009
},
};

///Buffer sizes for file reading
#define LINE_LENGTH 128
#define WORD_LENGTH 32

///Busqueda de instruccion soportada por nombre
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

///Parsea una instruccion 'instruction' en ensamblador a instruccion hexadecimal segun el set de instrucciones del MIPSIV
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
    int format = supported_ins[inst_index].format;
    switch (supported_ins[inst_index].structure)
    {
        case R_TYPE :
        {
            R_instruction* inst = calloc(1,sizeof(R_instruction));
            int ret,narg = 0;
            if(format == RDRTSA_FORMAT){ret=RDRTSA;narg=3;}
            else if (format == RDRSRT_FORMAT){ret=RDRSRT;narg=3;}
            else if(format == RDRS_FORMAT){ret=RDRS;narg=2;}
            else if(format == RDRTRS_FORMAT){ret=RDRTRS;narg=3;}
            else if(format == RS_FORMAT){ret = RS;narg=1;}
            else  ret=-1;
            if(ret<narg || inst->rd > 0X1F || inst->rs > 0X1F || inst->rt > 0X1F || inst->sa > 0X1F)
            {
                fprintf(stderr,"Error Invalid instruction at line %d\n",line_num);
                exit(EXIT_FAILURE);    
            }
            unsigned int instruction = (inst->rs << RS_OFFSET) + (inst->rt << RT_OFFSET) + (inst->rd << RD_OFFSET) + (inst->sa << SA_OFFSET) + supported_ins[inst_index].code;
            char instruction_hex [WORD_LENGTH] ;
            sprintf(instruction_hex,OUT_FORMAT,instruction);
            //printf("instruction : %s , rd : %d rt : %d rs : %d sa : %d code : %s\n",instruction_name,inst->rd,inst->rt,inst->rs,inst->sa,instruction_hex);
            fwrite(&instruction_hex,sizeof(char),10,fp_out);
            break;
        }
        case I_TYPE :
        {
            I_instruction* inst = calloc(1,sizeof(R_instruction));
            int ret,narg = 0;
            if(format == RTOFFBASE_FORMAT){ret=RTOFFBASE;narg=3;}
            else if (format == RTRSIMM_FORMAT){ret=RTRSIMM;narg=3;}
            else if(format == RSRTOFF_FORMAT){ret=RSRTOFF;narg=3;}
            else if(format == RTIMM_FORMAT){ret=RTIMM;narg=2;}
            else  ret = -1;
             if(ret<narg || inst->rs > 0X1F || inst->rt > 0X1F || inst->immediate > 0XFFFF)
            {
                fprintf(stderr,"Error Invalid instruction at line %d\n",line_num);
                exit(EXIT_FAILURE);
            }
            unsigned int instruction = supported_ins[inst_index].code + (inst->rs << RS_OFFSET) + (inst->rt << RT_OFFSET) + (inst->immediate);
            char instruction_hex [WORD_LENGTH] ;
            sprintf(instruction_hex,OUT_FORMAT,instruction);
            //printf("instruction : %s , rd : %d rt : %d rs : %d sa : %d code : %s\n",instruction_name,inst->rd,inst->rt,inst->rs,inst->sa,instruction_hex);
            fwrite(&instruction_hex,sizeof(char),10,fp_out);
            break;
        }
        case J_TYPE :
        {
            J_instruction* inst = calloc(1,sizeof(R_instruction));
            int ret,narg = 0;
            if(format == TARGET_FORMAT){ret=TARGET;narg=1;}
            else  ret = -1;
            if(ret<narg || inst->instr_index > 0x3FFFFFF)
            {
                fprintf(stderr,"Error Invalid instruction at line %d\n",line_num);
                exit(EXIT_FAILURE);
            }
            unsigned int instruction = supported_ins[inst_index].code + (inst->instr_index);
            char instruction_hex [WORD_LENGTH] ;
            sprintf(instruction_hex,OUT_FORMAT,instruction);
            //printf("instruction : %s , rd : %d rt : %d rs : %d sa : %d code : %s\n",instruction_name,inst->rd,inst->rt,inst->rs,inst->sa,instruction_hex);
            fwrite(&instruction_hex,sizeof(char),10,fp_out);
            break;
        }
        default:
        printf("Error not implemented structure\n");
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
    const char init [LINE_LENGTH]= "memory_initialization_radix=16;\nmemory_initialization_vector=\n";
    fwrite(&init,strlen(init),1,fp_out);
    int line_num=2;
    while(fgets(line, LINE_LENGTH,fp_in)) 
    {
        write_inst(line,fp_out,line_num);
        line_num ++;
    }
    fseek(fp_out,-2,SEEK_END);
    char end = ';';
    fwrite(&end,sizeof(char),1,fp_out);
    free(line);
    fclose(fp_in);
    fclose(fp_out);
}