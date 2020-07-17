`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.07.2020 17:17:05
// Design Name: 
// Module Name: test_bench_EX
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
`define INST_FUNCTION offset[`FUNCTION_SBIT + `FUNCTION_WIDTH -1 : `FUNCTION_SBIT]

module test_bench_EX();

//Inputs
reg clk,reset;
reg [`PC_WIDTH - 1 :0] pc_adder_in;
reg [`REGISTERS_WIDTH - 1 :0] offset;
reg [`REGISTERS_WIDTH - 1 :0] Read_data1,Read_data2_in;
reg [`RD_WIDTH - 1 : 0]rd;
reg [`RT_WIDTH - 1 : 0]rt;

//Control signal inputs
reg RegDst;
reg [1:0] AluSrc;
reg [`ALUOP_WIDTH - 1 : 0] Aluop;

//Outputs
wire [`PC_WIDTH - 1 :0] pc_adder;
wire [`REGISTERS_WIDTH - 1 :0] Alu_result;
wire [`REGISTERS_WIDTH - 1 :0] Read_data2;
wire [`REGISTERS_ADDR_WIDTH - 1 :0] Write_addr;
//control signal outputs
wire Branch,MemRead,MemWrite,Zero;
wire [1:0] MemtoReg;

always #`CLK_PERIOD clk = !clk;
	
	initial
	begin
	clk =          1'b0;
	reset =        1'b1;
    
	@(negedge clk) #1;   
    reset =        1'b0;
    @(negedge clk) #1;  
    pc_adder_in = 100;
    Read_data1 = 1;
    Read_data2_in = 2;
    offset = 0;
    rd = 5;
    rt = 6;
    //control signals
    RegDst = 0;//write addr <- rt
    Aluop = `RTYPE_ALUCODE;//Rtype instruction ,add alu operation
    `INST_FUNCTION = `ADD_FUNCTIONCODE;
    AluSrc[0] = 1'b0;//operand 1 <- Read_data1
    AluSrc[1] = 1'b0;//operand 2 <- Read_data2
    @(negedge clk) #1;

    @(negedge clk) #1;
    RegDst = 0;//write addr <- rt
    Aluop = `ORI_ALUCODE;//Itype instruction ,ori alu operation
    offset = 10;
    AluSrc[0] = 1'b0;//operand 1 <- Read_data1
    AluSrc[1] = 1'b1;//operand 2 <- offset
    @(negedge clk) #1;
    reset = 1;
    @(negedge clk) #1;
    reset = 0;
    @(negedge clk) #1;
    @(negedge clk) #1;
    $finish;
	end
	
EX_top ex_top
(
    //inputs
    .clk(clk),
    .reset(reset),
    .pc_adder_in(pc_adder_in),
    .offset(offset),
    .Read_data1(Read_data1),
    .Read_data2_in(Read_data2_in),
    .rt(rt),
    .rd(rd),
    //control signals in
    .RegDst(RegDst),
    .Aluop(Aluop),
    .AluSrc(AluSrc),
    .MemRead_in('b0),//control signals not used in this stage
    .MemWrite_in('b0),
    .Branch_in('b0),
    .MemtoReg_in('b0),
    //Outputs
    .pc_adder(pc_adder),
    .Alu_result(Alu_result),
    .Write_addr(Write_addr),
    .Read_data2(Read_data2),
    //Control signals out
    .Branch(Branch),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .Zero(Zero),
    .MemtoReg(MemtoReg)
);

endmodule
