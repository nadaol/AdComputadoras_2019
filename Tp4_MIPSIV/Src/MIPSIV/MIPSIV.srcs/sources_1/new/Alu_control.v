`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.06.2020 19:20:41
// Design Name: 
// Module Name: Alu_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "Parameters.vh"

//Control para el modulo Alu , segun la instruccion genera el codigo de operacion a realizar por la Alu
module Alu_control
(
    input [`FUNCTION_WIDTH - 1:0] inst_function,   //6 bit instruction function code for R-Type instructions
    input [`ALUOP_WIDTH-1:0] control_aluop,  //Type of instruction indicator from main control unit(add(for load/stores),sub(for branch instructions) or determined by inst_function)
    output reg [`ALU_CONTROL_WIDTH-1:0] alu_control_opcode //Final control signal to Alu
    );
    
    always@(*)
    begin                   //Multi-level alu operation decoding
        case(control_aluop) 
            `RTYPE_ALUCODE :         //R-Type instructions code : function code -> alu aperations code
            case(inst_function)
                    `SLL_FUNCTIONCODE  : alu_control_opcode = `SLL; 
					`SRL_FUNCTIONCODE  : alu_control_opcode = `SRL; 
					`SRA_FUNCTIONCODE  : alu_control_opcode = `SRA; 
					`SRLV_FUNCTIONCODE : alu_control_opcode = `SRLV;
					`SRAV_FUNCTIONCODE : alu_control_opcode = `SRAV; 
					`ADD_FUNCTIONCODE  : alu_control_opcode = `ADD;
					`SLLV_FUNCTIONCODE : alu_control_opcode = `SLLV;
					`SUB_FUNCTIONCODE  : alu_control_opcode = `SUB;
					`AND_FUNCTIONCODE  : alu_control_opcode = `AND;
					`OR_FUNCTIONCODE   : alu_control_opcode = `OR;
					`XOR_FUNCTIONCODE  : alu_control_opcode = `XOR;
					`NOR_FUNCTIONCODE  : alu_control_opcode = `NOR;
					`SLT_FUNCTIONCODE  : alu_control_opcode = `SLT;
					default            : alu_control_opcode = alu_control_opcode;//J & JALR do not use any Alu operation
            endcase         //Rest of instructions code types -> alu aperations code
            `LOAD_STORE_ADDI_ALUCODE :   alu_control_opcode = `ADD;
            `ANDI_ALUCODE :              alu_control_opcode = `AND;
            `ORI_ALUCODE :               alu_control_opcode = `OR;
            `XORI_ALUCODE :              alu_control_opcode = `XOR;
            `LUI_ALUCODE :               alu_control_opcode = `SLL16;
            `SLTI_ALUCODE :              alu_control_opcode = `SLT;
            `BEQ_ALUCODE :               alu_control_opcode = `SUB;
            `BNE_ALUCODE :               alu_control_opcode = `NEQ;
            `ORI_ALUCODE :               alu_control_opcode = `OR ;
            default:                        alu_control_opcode = alu_control_opcode;
    endcase
    end
    
endmodule
