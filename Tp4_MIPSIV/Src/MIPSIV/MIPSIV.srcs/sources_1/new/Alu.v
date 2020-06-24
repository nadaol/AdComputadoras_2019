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


module Alu #(
	parameter registers_data_width = 32,
    parameter alu_control_opcode_width = 4
	)
	(
	input signed [registers_data_width-1 : 0] registers_data1,
	input signed [registers_data_width-1 : 0] registers_data2,
	input [alu_control_opcode_width-1 : 0] alu_control_opcode,

	output reg [registers_data_width - 1 : 0] alu_result,
	output wire alu_zero
	);
	
	//ARITH operation   alu_opcode
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

	always @(*)
	begin : alu_operations
		case (alu_control_opcode)
			SLL      : alu_result = registers_data2 << registers_data1; 
			SRL      : alu_result = registers_data2 >> registers_data1; 
			SRA      : alu_result = registers_data2 >>> registers_data1; 
			ADD      : alu_result = registers_data1 + registers_data2;
			SUB      : alu_result = registers_data1 - registers_data2;
			AND      : alu_result = registers_data1 & registers_data2;
			OR       : alu_result = registers_data1 | registers_data2;
			XOR      : alu_result = registers_data1 ^ registers_data2;
			NOR      : alu_result = ~(registers_data1 | registers_data2);
			SLT      : alu_result = registers_data1 < registers_data2;
			SLL16    : alu_result = registers_data2 << 16;
			default  : alu_result = {registers_data_width{1'b0}};
		endcase
	end
	
	assign alu_zero = alu_result == 0;

	endmodule
