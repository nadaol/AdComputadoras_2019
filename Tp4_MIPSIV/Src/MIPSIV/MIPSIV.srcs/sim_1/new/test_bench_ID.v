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

`define INST_OPCODE offset[`OPCODE_SBIT + `OPCODE_WIDTH -1 : `OPCODE_SBIT]

`include "Parameters.vh"

module test_bench_ID();

//Inputs
reg clk,reset;
reg [`PC_WIDTH - 1 :0] pc_adder_in;
reg [`INST_WIDTH - 1 :0] instruction;
reg [`RD_WIDTH - 1 : 0] Write_addr;
reg [`REGISTERS_WIDTH - 1 :0] Write_data;
//Control signal inputs
reg RegWrite_in,Branch_in,Zero_in;

//Outputs
wire [`REGISTERS_WIDTH - 1 :0] Read_data1,Read_data2;
wire [`REGISTERS_WIDTH - 1 :0] offset;
wire [`RT_WIDTH - 1 :0] rt;
wire [`RD_WIDTH - 1 :0] rd;
wire [`PC_WIDTH - 1 :0] pc_adder;
//control signal outputs
wire Branch,Zero,MemRead,MemWrite,RegDst,RegWrite;
wire [2:0] Aluop;
wire [1:0] AluSrc;
wire [1:0] MemtoReg;
wire [1:0] pc_src;

//Test Variables
reg [`INST_WIDTH-1:0] ram [`INST_MEMORY_DEPTH-1:0]  ;
integer i;
integer j;

always #`CLK_PERIOD clk = !clk;
	
	initial
	begin
	$readmemh("out.coe",ram,0);
	clk =          1'b0;
	reset =        1'b1;
	pc_adder_in = 13;
	i = 0;
	RegWrite_in = 1'b0;
	Branch_in = 1'b1;
	Zero_in = 1'b1;
	@(negedge clk) #1;   
	reset = 1'b0;
        while(ram[i] == ram[i])
        begin
               instruction = ram[i];
	           @(negedge clk)#1;
	           i = i + 1 ;
	      end
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
    .RegWrite_in(RegWrite_in),
    .Zero_in(Zero_in),
    .Branch_in(Branch_in),
    //outputs
    .Read_data1(Read_data1),
    .Read_data2(Read_data2),
    .offset(offset),
    .rt(rt),
    .rd(rd),
    .pc_adder(pc_adder),
    //control signal outputs
    .RegWrite(RegWrite),
    .Branch(Branch),
    .Zero(Zero),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .RegDst(RegDst),
    .Aluop(Aluop),
    .AluSrc(AluSrc),
    .MemtoReg(MemtoReg),
    .pc_src(pc_src)
);


endmodule
