`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.06.2020 20:13:38
// Design Name: 
// Module Name: Alu
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

//Unidad aritmetica logica con soporte para 11 operaciones
module Alu #(
	parameter registers_data_width = `REGISTERS_WIDTH,
    parameter alu_control_opcode_width = `ALU_CONTROL_WIDTH
	)
	(
	input signed [registers_data_width-1 : 0] Alu_operand1,
	input signed [registers_data_width-1 : 0] Alu_operand2,
	input [alu_control_opcode_width-1 : 0] alu_control_opcode,

	output reg [registers_data_width - 1 : 0] alu_result,
	output wire alu_zero
	);

//Multiplexor de operaciones segun el codigo de control
	always @(*)
	begin : alu_operations
		case (alu_control_opcode)
			`SLL      : alu_result = Alu_operand1 << Alu_operand2[`SA_WIDTH + `SA_SBIT - 1 : `SA_SBIT]; 
			`SRL      : alu_result = Alu_operand1 >> Alu_operand2[`SA_WIDTH + `SA_SBIT - 1 : `SA_SBIT]; 
			`SRA      : alu_result = Alu_operand1 >>> Alu_operand2[`SA_WIDTH + `SA_SBIT - 1 : `SA_SBIT]; 
			`SLLV      : alu_result = Alu_operand2 << Alu_operand1; 
			`SRLV      : alu_result = Alu_operand2 >> Alu_operand1; 
			`SRAV      : alu_result = Alu_operand2 >>> Alu_operand1; 
			`ADD      : alu_result = Alu_operand1 + Alu_operand2;
			`SUB      : alu_result = Alu_operand1 - Alu_operand2;
			`AND      : alu_result = Alu_operand1 & Alu_operand2;
			`OR       : alu_result = Alu_operand1 | Alu_operand2;
			`XOR      : alu_result = Alu_operand1 ^ Alu_operand2;
			`NOR      : alu_result = ~(Alu_operand1 | Alu_operand2);
			`SLT      : alu_result = Alu_operand1 < Alu_operand2;
			`SLL16    : alu_result = Alu_operand1 << 16;
			default  : alu_result = {registers_data_width{1'b0}};
		endcase
	end
	
	assign alu_zero = alu_result == 0;

	endmodule
