`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.06.2020 16:38:57
// Design Name: 
// Module Name: test_Alu_control
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
`define MAX_CONTROL_ALUOP 7
`define MAX_INST_FUNCTION 63
`define ASYNC_WAIT      #10         //Period for asyc wait steps in timescale unit

module test_bench_Alu_control();
    //Test Parameters
    parameter alu_control_opcode_width = `ALU_CONTROL_WIDTH;
    parameter control_aluop_width = `ALUOP_WIDTH;
    //Test Inputs
	reg [5:0] inst_function;
	reg [control_aluop_width-1:0] control_aluop;
    //Test Outputs
	wire [alu_control_opcode_width-1:0] alu_control_opcode;
	integer i ;
	initial
	begin
	control_aluop = {control_aluop_width{1'b0}};
	inst_function = {5{1'b0}};
	`ASYNC_WAIT;
	for (i = 0 ; i < `MAX_INST_FUNCTION + 1 ; i = i+1)
        begin
        inst_function = i ;
        `ASYNC_WAIT;
        end

	for (i = 0 ; i < `MAX_CONTROL_ALUOP + 1 ; i = i+1)
        begin
        control_aluop = i ;
        `ASYNC_WAIT;
        end
    for (i = 0 ; i < `MAX_INST_FUNCTION + 1 ; i = i+1)
        begin
        inst_function = i ;
        `ASYNC_WAIT;
        end
	$finish;
	end
	
	//Module under test Instantiation
	Alu_control
	#(
	   .alu_control_opcode_width(`ALU_CONTROL_WIDTH),
	   .control_aluop_width(`ALUOP_WIDTH)
	)
	uut
	(
		.inst_function(inst_function), 
		.control_aluop(control_aluop), 
		.alu_control_opcode(alu_control_opcode)
    );
	
endmodule