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

module Alu_control
#(
    parameter alu_control_opcode_width = 4,
    parameter control_aluop_width = 3
)
(
    input [5:0] inst_function,   //6 bit instruction function code for R-Type instructions
    input [control_aluop_width-1:0] control_aluop,  //Type of instruction indicator from main control unit(add(for load/stores),sub(for branch instructions) or determined by inst_function)
    output reg [alu_control_opcode_width-1:0] alu_control_opcode //Final control signal to Alu
    );
    
 // Function instruction codes
localparam INST_FUNCTION_SLL =  6'b000000;
localparam INST_FUNCTION_SRL =  6'b000010;
localparam INST_FUNCTION_SRA =  6'b000011;
localparam INST_FUNCTION_SRLV=  6'b000100;
localparam INST_FUNCTION_SRAV=  6'b000110;
localparam INST_FUNCTION_ADD =  6'b000111;
localparam INST_FUNCTION_SLLV=  6'b100001;
localparam INST_FUNCTION_SUB =  6'b100011;
localparam INST_FUNCTION_AND =  6'b100100;
localparam INST_FUNCTION_OR  =  6'b100101;  
localparam INST_FUNCTION_XOR =  6'b100110; 
localparam INST_FUNCTION_NOR =  6'b100111;  
localparam INST_FUNCTION_SLT =  6'b101010;  
    
//   type of operation  control_aluop
localparam RTYPE =          {{control_aluop_width{1'b0}}};//for RTYPE instructions ,map to ARITH operation ,specified in function segment of instruction
localparam LOAD_STORE_ADDI ={{control_aluop_width-1{1'b0}},1'b1};//for load/store and ADDI ,instructions map to ADD operation
localparam ANDI =           {{control_aluop_width-2{1'b0}},2'b10};//for ANDI instruction ,map to AND operation
localparam ORI =            {{control_aluop_width-2{1'b0}},2'b11};//for ORI instruction ,map to OR operation
localparam XORI =           {{control_aluop_width-3{1'b0}},3'b100};//for XORI instruction ,map to XOR operation
localparam LUI =            {{control_aluop_width-3{1'b0}},3'b101};//for LUI instruction ,map to LUI operation (shift left logical 16)
localparam SLTI =           {{control_aluop_width-3{1'b0}},3'b110};//for SLTI instruction ,map to SLT operation (comparation)
localparam BRANCH =         {{control_aluop_width-3{1'b0}},3'b111};//for BRANCH instructions ,map to SUB operation

//ARITH operation   alu_control_opcode
localparam SLL =    {{alu_control_opcode_width{1'b0}}};
localparam SRL =    {{alu_control_opcode_width-1{1'b0}},1'b1};
localparam SRA =    {{alu_control_opcode_width-2{1'b0}},2'b10};
localparam ADD =    {{alu_control_opcode_width-2{1'b0}},2'b11};
localparam SUB =    {{alu_control_opcode_width-3{1'b0}},3'b100};
localparam AND =    {{alu_control_opcode_width-3{1'b0}},3'b101};
localparam OR =     {{alu_control_opcode_width-3{1'b0}},3'b110};
localparam XOR =    {{alu_control_opcode_width-3{1'b0}},3'b111};
localparam NOR =    {{alu_control_opcode_width-4{1'b0}},4'b1000};
localparam SLT =    {{alu_control_opcode_width-4{1'b0}},4'b1001};
localparam SLL16 =  {{alu_control_opcode_width-4{1'b0}},4'b1010};
    
    always@(*)
    begin                   //Multi-level alu operation decoding
        case(control_aluop) 
            RTYPE :         //R-Type instructions code : function code -> alu aperations code
            case(inst_function)
                    INST_FUNCTION_SLL  : alu_control_opcode = SLL; 
					INST_FUNCTION_SRL  : alu_control_opcode = SRL; 
					INST_FUNCTION_SRA  : alu_control_opcode = SRA; 
					INST_FUNCTION_SRLV : alu_control_opcode = SRL;
					INST_FUNCTION_SRAV : alu_control_opcode = SRA; 
					INST_FUNCTION_ADD  : alu_control_opcode = ADD;
					INST_FUNCTION_SLLV : alu_control_opcode = SLL;
					INST_FUNCTION_SUB  : alu_control_opcode = SUB;
					INST_FUNCTION_AND  : alu_control_opcode = AND;
					INST_FUNCTION_OR   : alu_control_opcode = OR;
					INST_FUNCTION_XOR  : alu_control_opcode = XOR;
					INST_FUNCTION_NOR  : alu_control_opcode = NOR;
					INST_FUNCTION_SLT  : alu_control_opcode = SLT;
					default            : alu_control_opcode = {{alu_control_opcode_width{1'b1}}};
            endcase         //Rest of instructions code types -> alu aperations code
            LOAD_STORE_ADDI :   alu_control_opcode = ADD;
            ANDI :              alu_control_opcode = AND;
            ORI :               alu_control_opcode = OR;
            XORI :              alu_control_opcode = XOR;
            LUI :               alu_control_opcode = SLL16;
            SLTI :              alu_control_opcode = SLT;
            BRANCH :            alu_control_opcode = SUB;
            ORI :               alu_control_opcode = OR ;
            default:            alu_control_opcode = {{alu_control_opcode_width{1'b1}}};
    endcase
    end
    
endmodule
