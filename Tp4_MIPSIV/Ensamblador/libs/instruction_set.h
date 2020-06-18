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
#define RFORMAT "%*s %[0-9]%[0-9]%[0-9]"
#define IFORMAT "%*s"
#define JFORMAT "%s "

void parse_asm(const char* in_file,const char* out_file);

enum format_code
{
    R_FORMAT = 0,
    I_FORMAT = 1,
    J_FORMAT = 2
};

///Supported instruction set structure
typedef struct _intruction_set
{
    ///Name of supported instruction
    const char* name;
    ///Format specifier
    enum format_code format;
    ///Opcode/function of instruction
    char code [6];
}instruction_set;


extern instruction_set supported_ins [NSUPORTED_INST];

///MIPSIV instruction set formats

/// R-Type instruction (register)
typedef struct _R_instruction
{
    ///6-bit primary operation code
    char opcode [3] ;
    ///5-bit source register specifier
    char rs [3];
    ///5-bit target (source/destination) register specifier or used to specify funcions within the primary opcode value REGIMM
    char rt [3];
    ///5-bit destination register specifier
    char rd [3];
    ///5-bit shift amount
    char sa [3];
    ///6-bit function field used to specify functions within the primary operation code value SPECIAL
    char function [3];
}R_instruction;

///I-Type instruction (Inmmediate)
typedef struct _I_instruction
{
    ///6-bit primary operation code
    char opcode [3] ;
    ///5-bit source register specifier or immediate offset base value
    char rs [3];
    ///5-bit target (source/destination) register specifier or used to specify funcions within the primary opcode value REGIMM
    char rt [3];
    /**16-bit signed immediate used for logical/arithmetic operands,load/store address byte offsets,
    PC-relative branch signed instruction displacement**/
    char immediate[6];

}I_instruction;

///J-Type intruction (jump)
typedef struct _J_instruction
{
    ///6-bit primary operation code
    char opcode [7] ;
    ///26-bit insdex shifted left two bits to supply the low-order 28 bits of the jump target address
    char instr_index[27];
}J_instruction;

#endif