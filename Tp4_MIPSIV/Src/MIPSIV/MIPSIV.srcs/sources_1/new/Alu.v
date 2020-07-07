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
	input signed [registers_data_width-1 : 0] registers_data1,
	input signed [registers_data_width-1 : 0] registers_data2,
	input [alu_control_opcode_width-1 : 0] alu_control_opcode,

	output reg [registers_data_width - 1 : 0] alu_result,
	output wire alu_zero
	);

//Multiplexor de operaciones segun el codigo de control
	always @(*)
	begin : alu_operations
		case (alu_control_opcode)
			`SLL      : alu_result = registers_data2 << registers_data1; 
			`SRL      : alu_result = registers_data2 >> registers_data1; 
			`SRA      : alu_result = registers_data2 >>> registers_data1; 
			`ADD      : alu_result = registers_data1 + registers_data2;
			`SUB      : alu_result = registers_data1 - registers_data2;
			`AND      : alu_result = registers_data1 & registers_data2;
			`OR       : alu_result = registers_data1 | registers_data2;
			`XOR      : alu_result = registers_data1 ^ registers_data2;
			`NOR      : alu_result = ~(registers_data1 | registers_data2);
			`SLT      : alu_result = registers_data1 < registers_data2;
			`SLL16    : alu_result = registers_data2 << 16;
			default  : alu_result = {registers_data_width{1'b0}};
		endcase
	end
	
	assign alu_zero = alu_result == 0;

	endmodule
