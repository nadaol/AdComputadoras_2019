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

/*
addi 0,1,5 ; reg[0] = reg[1] + 5 
sw 0,10(0) ; memory[reg[10] + 0] = reg[0] 
addi 0,0,5 ; reg[0] = reg[0] + 5
lw 2,10(0); reg[2] = memory[reg[10]+0]
sub 3,0,2 ; reg[3] = reg[0] - reg[2]
srl 4,3,2 ; reg[4] = reg[3] >> 2
beq 4,3,2 ; if(reg[3]==reg[4])jump pc+2
j 6 ; jump 6
slt 5,3,4 ; reg[5]=(reg[3]<reg[4])
jalr 6,2 ; reg[6] = return address  ; jump reg[2]
srav 7,3,0 ; reg[3] >> reg[0]
xori 8,6,7 ; reg[8] = reg[6] xori reg[7]
*/

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
reg RegWrite_in,Branch_in,Zero_in,control_enable;

//Outputs
wire [`REGISTERS_WIDTH - 1 :0] Read_data1,Read_data2;
wire [`REGISTERS_WIDTH - 1 :0] offset;
wire [`RT_WIDTH - 1 :0] rt;
wire [`RD_WIDTH - 1 :0] rd;
wire [`RS_WIDTH - 1 :0] rs;
wire [`PC_WIDTH - 1 :0] pc_adder;
//control signal outputs
wire Branch,MemRead,MemWrite,RegWrite;
wire [2:0] Aluop;
wire [1:0] AluSrc,regDst,MemtoReg,pc_src;

//Test Variables
reg [`INST_WIDTH-1:0] ram [`INST_MEMORY_DEPTH-1:0]  ;
integer i;

always #`CLK_PERIOD clk = !clk;
	
	initial
	begin
	$readmemh("out.coe",ram,0);
	clk =          1'b0;
	reset =        1'b1;
	Write_addr = 'h10 ;
	Write_data = 'h20;
	pc_adder_in = 13;
	i = 0;
	control_enable = 1'b1;
	RegWrite_in = 1'b0;
	Branch_in = 1'b0;
	Zero_in = 1'b0;
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
    .control_enable(control_enable),
    .Branch_in(Branch_in),
    //outputs
    .Read_data1(Read_data1),
    .Read_data2(Read_data2),
    .offset(offset),
    .rt(rt),
    .rd(rd),
    .rs(rs),
    .pc_adder(pc_adder),
    //control signal outputs
    .RegWrite(RegWrite),
    .Branch(Branch),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .regDst(regDst),
    .Aluop(Aluop),
    .AluSrc(AluSrc),
    .MemtoReg(MemtoReg),
    .pc_src(pc_src)
);

endmodule
