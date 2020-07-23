`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2020 19:46:40
// Design Name: 
// Module Name: test_bench_MEM
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

module test_bench_MEM();

//inputs
reg clk,reset;
reg [`DATA_MEMORY_ADDR_WIDTH - 1 : 0] Addr;
reg [`REGISTERS_WIDTH -1 : 0] Write_Data;
reg [`REGISTERS_ADDR_WIDTH -1 :0] Write_addr_in;
//Control signal inputs
reg MemWrite,MemRead,Zero,Branch,RegWrite_in;
reg [1:0] MemtoReg_in;

//outputs
wire [`REGISTERS_WIDTH -1 : 0] Read_data,Alu_result;
wire [`REGISTERS_ADDR_WIDTH -1 :0] Write_addr;
    //control signals out
wire[1:0] MemtoReg;
wire RegWrite;
wire branch_taken;

//Testbench variables
integer i;

always #`CLK_PERIOD clk = !clk;
	
	initial
	begin
	clk = 0;
	reset = 1'b1;
	i = 1'b0 ;
	@(negedge clk) #1;
	reset = 1'b0;
	Write_addr_in = 9;
	MemWrite = 1'b1;
	MemRead = 1'b1;
	Zero = 1'b1;
	Branch = 1'b1;
	RegWrite_in = 1'b1;
	MemtoReg_in = 1'b1;
	@(negedge clk) #1;
	Branch = 1'b0;
	while(i<`DATA_MEMORY_DEPTH)
        begin   
	           Addr = i;
	           Write_Data = i+10;
	           @(posedge clk) #1;//Write data_memory[i] = i + 1
	           @(negedge clk) #1;//Read data_memory[i]
	           i = i + 1;
	    end
	 @(negedge clk) #1;
	 @(negedge clk) #1;
	$finish;
	end
	
	MEM_top mem_top
(
    //inputs
    .clk(clk),
    .reset(reset),
    .Addr(Addr),
    .Write_Data(Write_Data),
    .Write_addr_in(Write_addr_in),
    //control signals in
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .Zero(Zero),
    .Branch(Branch),
    .RegWrite_in(RegWrite_in),
    .MemtoReg_in(MemtoReg_in),
    //outputs
    .Read_data(Read_data),
    .Alu_result(Alu_result),
    .Write_addr(Write_addr),
    //control signals out
    .MemtoReg(MemtoReg),
    .RegWrite(RegWrite),
    .branch_taken(branch_taken)
);

endmodule
