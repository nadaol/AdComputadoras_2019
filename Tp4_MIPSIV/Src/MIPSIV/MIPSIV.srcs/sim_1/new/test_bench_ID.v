`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.07.2020 00:43:41
// Design Name: 
// Module Name: test_bench_ID
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

module test_bench_ID();

//Inputs
reg clk,reset;
reg [`PC_WIDTH - 1 :0] pc_adder_in;
reg [`INST_WIDTH - 1 :0] instruction;
reg [`RD_WIDTH - 1 : 0] Write_addr;
reg [`REGISTERS_WIDTH - 1 :0] Write_data;
//Control signal inputs
reg RegWrite,branch_taken;

//Outputs
wire [`REGISTERS_WIDTH - 1 :0] Read_data1,Read_data2;
wire [`REGISTERS_WIDTH - 1 :0] offset;
wire [`RT_WIDTH - 1 :0] rt;
wire [`RD_WIDTH - 1 :0] rd;
wire [`PC_WIDTH - 1 :0] pc_adder;
//control signal outputs
wire Branch,MemRead,MemWrite,RegDst;
wire [2:0] Aluop;
wire [1:0] AluSrc;
wire [1:0] MemtoReg;
wire [1:0] pc_src;

always #`CLK_PERIOD clk = !clk;
	
	initial
	begin
	clk =          1'b0;
	reset =        1'b1;
	RegWrite = 1'b0;
	@(negedge clk) #1;   
    reset =        1'b0;
    @(negedge clk) #1;  
    pc_adder_in = 13;
    instruction = 'h21290005;
    @(negedge clk) #1; 
    instruction = 'h2129000f;
    @(negedge clk) #1;
    instruction = 'hac090000; 
    @(negedge clk) #1; 
    instruction = 'h214a0003;
    @(negedge clk) #1;
    $finish;
	end

ID_top id_top
(
    //inputs
    .clk(clk),
    .reset(reset),
    .pc_adder_in(pc_adder_in),
    .instruction(instruction),
    .Write_addr(Write_addr),
    .Write_data(Write_data),
    //control inputs
    .RegWrite(RegWrite),
    .branch_taken(branch_taken),
    //outputs
    .Read_data1(Read_data1),
    .Read_data2(Read_data2),
    .offset(offset),
    .rt(rt),
    .rd(rd),
    .pc_adder(pc_adder),
    //control signal outputs
    .Branch(Branch),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .RegDst(RegDst),
    .Aluop(Aluop),
    .AluSrc(AluSrc),
    .MemtoReg(MemtoReg),
    .pc_src(pc_src)
);


endmodule
