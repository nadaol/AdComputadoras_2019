`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2020 01:49:50
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
`define REGISTERS_DATA_WIDTH 32       // Tamano de los de entrada 
`define ALU_CONTROL_OPCODE_WIDTH 4      // Tamano de la senal de control
`define NUM_SUPP_OPERATIONS 11
`define ASYNC_WAIT      #10         //Period for asyc wait steps in timescale unit

module test_bench_Alu();
    //Test Parameters
    parameter registers_data_width = `REGISTERS_DATA_WIDTH;
    parameter alu_control_opcode_width = `ALU_CONTROL_OPCODE_WIDTH;
    //Test Inputs
	reg signed [registers_data_width-1 : 0] registers_data1;
	reg signed [registers_data_width-1 : 0] registers_data2;
	reg [alu_control_opcode_width-1 : 0] alu_control_opcode;
    //Test Outputs
	wire [registers_data_width - 1 : 0] alu_result;
	wire alu_zero;
	integer i ;
	initial
	begin
	registers_data1 = {registers_data_width{1'b0}};
	registers_data2 = {registers_data_width{1'b0}};
	registers_data1 = 5;
	registers_data2 = 3;
	`ASYNC_WAIT;
	for (i = 0 ; i < `NUM_SUPP_OPERATIONS  ; i = i+1)
        begin
        alu_control_opcode = i ;
        `ASYNC_WAIT;
        end

	$finish;
	end
	
	//Module under test Instantiation
	Alu
	#(
	   .registers_data_width(`REGISTERS_DATA_WIDTH),
	   .alu_control_opcode_width(`ALU_CONTROL_OPCODE_WIDTH)
	)
	uut
	(
		.registers_data1(registers_data1), 
		.registers_data2(registers_data2), 
		.alu_control_opcode(alu_control_opcode), 
		.alu_result(alu_result), 
		.alu_zero(alu_zero)
    );
	
endmodule
