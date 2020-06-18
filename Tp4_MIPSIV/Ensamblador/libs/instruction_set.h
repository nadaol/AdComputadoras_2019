/**
Created on 17/06/2020.

 @author jmorales (jmorales@unc.edu.ar)
 @details https://itnext.io/bits-to-bitmaps-a-simple-walkthrough-of-bmp-image-format-765dc6857393
*/

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
//Instructions formats
#define RDRTSA sscanf(instruction,"%*s %u , %u , %u",&inst->rd,&inst->rt,&inst->sa)
#define RDRTRS sscanf(instruction,"%*s %u , %u , %u",&inst->rd,&inst->rt,&inst->rs)
#define RDRSRT sscanf(instruction,"%*s %u , %u , %u",&inst->rd,&inst->rs,&inst->rt)
#define IFORMAT "%*s"
#define JFORMAT "%s "
//.coe output line format
#define OUT_FORMAT "%08x,\n"

void parse_asm(const char* in_file,const char* out_file);

enum format_code
{
    RDRTSA_FORMAT = 0,
    RDRTRS_FORMAT = 1,
    RDRSRT_FORMAT = 2,
    I_FORMAT = 3,
    J_FORMAT = 4
};

///Supported instruction set structure
typedef struct _intruction_set
{
    ///Name of supported instruction
    const char* name;
    ///Format specifier
    enum format_code format;
    ///Hexadecimal Opcode/function of instruction
    unsigned int code ;
}instruction_set;


extern instruction_set supported_ins [NSUPORTED_INST];

///MIPSIV instruction set formats

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