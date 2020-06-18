#ifndef _INSTRUCTION_SET_H_
#define _INSTRUCTION_SET_H_

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

///Number of supported instructions
#define NSUPORTED_INST 34

///Register's offset from rigth to left
#define RS_OFFSET 21
#define RT_OFFSET 16
#define RD_OFFSET 11
#define SA_OFFSET 6

//R-type instructions formats
#define RDRTSA sscanf(instruction,"%*s %u , %u , %u",&inst->rd,&inst->rt,&inst->sa)
#define RDRTRS sscanf(instruction,"%*s %u , %u , %u",&inst->rd,&inst->rt,&inst->rs)
#define RDRSRT sscanf(instruction,"%*s %u , %u , %u",&inst->rd,&inst->rs,&inst->rt)
#define RDRS sscanf(instruction,"%*s %u , %u",&inst->rd,&inst->rs)
#define RS sscanf(instruction,"%*s %u",&inst->rs)
///I-type instructions
#define RTOFFBASE sscanf(instruction,"%*s %u , %u ( %u )",&inst->rt,&inst->immediate,&inst->rs)
#define RTRSIMM sscanf(instruction,"%*s %u , %u , %u",&inst->rt,&inst->rs,&inst->immediate)
#define RSRTOFF sscanf(instruction,"%*s %u , %u , %u",&inst->rs,&inst->rt,&inst->immediate)
#define RTIMM sscanf(instruction,"%*s %u , %u ",&inst->rt,&inst->immediate)
///J-type instructions
#define TARGET sscanf(instruction,"%*s %u",&inst->instr_index)

//.coe output line format
#define OUT_FORMAT "%08x,\n"

void parse_asm(const char* in_file,const char* out_file);

//instruction structures id's
enum structure_code
{
    R_TYPE = 0,
    I_TYPE = 1,
    J_TYPE = 2
};

///Instruction formats id's
enum format_code
{
    RDRTSA_FORMAT = 0,
    RDRTRS_FORMAT = 1,
    RDRSRT_FORMAT = 2,
    RTOFFBASE_FORMAT = 3,
    RTRSIMM_FORMAT  = 4,
    RTIMM_FORMAT = 5,
    RSRTOFF_FORMAT = 6,
    TARGET_FORMAT = 7,
    RDRS_FORMAT = 8,
    RS_FORMAT = 9
};

///Supported instruction structure
typedef struct _intruction_set
{
    ///Name of the supported instruction
    const char* name;
    //Structure specifier
    enum structure_code structure;
    ///Format specifier
    enum format_code format;
    ///Hexadecimal Opcode/function of instruction
    unsigned int code ;
}instruction_set;

extern instruction_set supported_ins [NSUPORTED_INST];

///MIPSIV instruction set structures

/// R-Type instruction (register)
typedef struct _R_instruction
{
    ///6-bit primary operation code
    unsigned int opcode ;
    ///5-bit source register specifier
    unsigned int rs ;
    ///5-bit target (source/destination) register specifier or used to specify funcions within the primary opcode value REGIMM
    unsigned int rt ;
    ///5-bit destination register specifier
    unsigned int rd ;
    ///5-bit shift amount
    unsigned int sa ;
    ///6-bit function field used to specify functions within the primary operation code value SPECIAL
    unsigned int function;
}R_instruction;

///I-Type instruction (Inmmediate)
typedef struct _I_instruction
{
    ///6-bit primary operation code
    unsigned int opcode ;
    ///5-bit source register specifier or immediate offset base value
    unsigned int rs ;
    ///5-bit target (source/destination) register specifier or used to specify funcions within the primary opcode value REGIMM
    unsigned int rt ;
    /**16-bit signed immediate used for logical/arithmetic operands,load/store address byte offsets,
    PC-relative branch signed instruction displacement**/
    unsigned int immediate ;
}I_instruction;

///J-Type intruction (jump)
typedef struct _J_instruction
{
    ///6-bit primary operation code
    unsigned int opcode ;
    ///26-bit insdex shifted left two bits to supply the low-order 28 bits of the jump target address
    unsigned int instr_index ;
}J_instruction;

#endif