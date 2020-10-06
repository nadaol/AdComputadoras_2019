`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.07.2020 19:28:33
// Design Name: 
// Module Name: EX_top
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

module EX_top(
    //inputs
    input clk,reset,
    input [`PC_WIDTH - 1 :0] pc_adder_in,
    input [`REGISTERS_WIDTH - 1 :0] offset,
    input [`REGISTERS_WIDTH - 1 :0] Read_data1,Read_data2_in,
    input [`RT_WIDTH - 1 :0] rt,
    input [`RD_WIDTH - 1 :0] rd_in,
    input [`REGISTERS_WIDTH - 1 :0] MEM_WB_Write_Data,
    input [1:0] operand1_hazard,
    input [1:0] operand2_hazard,
    //control signals in
    input enable,
    input [1:0] RegDst,
    input [`ALUOP_WIDTH - 1:0]Aluop,
    input [1:0] AluSrc,
    input MemRead_in,MemWrite_in,Branch_in,RegWrite_in,//control signals not used in this stage
    input [1:0] MemtoReg_in,
    input EX_MEM_reset,
    input EX_write,
    
    //Outputs
    output reg [`PC_WIDTH - 1 :0] pc_adder,pc_adder1,
    output reg [`REGISTERS_WIDTH - 1 :0] Alu_result,
    output reg [`REGISTERS_ADDR_WIDTH - 1 :0] Write_addr,
    output reg [`REGISTERS_WIDTH - 1 :0] Read_data2,
    output reg [`RD_WIDTH - 1 :0] rd,
    //Control signals out
    output reg Branch,MemRead,MemWrite,Zero,RegWrite,
    output reg [1:0] MemtoReg
    );
    
    //Internal signals
    wire [`REGISTERS_WIDTH - 1 :0] Alu_operand1,Alu_operand2;
    wire [`ALU_CONTROL_WIDTH -1 : 0] alu_control_opcode;
    wire [`ALUOP_WIDTH - 1 : 0] AluOp;
    wire [`REGISTERS_WIDTH - 1 :0] mx1_out;
    wire [`REGISTERS_WIDTH - 1 :0] mx2_out;
    //modules outputs, EX/MEM Register inputs
    wire [`PC_WIDTH - 1 :0] pc_adder_out;
    wire Zero_out;
    wire [`REGISTERS_WIDTH - 1 :0] Alu_result_out;
    wire [`REGISTERS_ADDR_WIDTH -1 :0] Write_addr_out;

 //ID/EX Memory register
    always@(posedge clk)
  begin
   
    if(reset)
        begin
        //Reset register outputs
        pc_adder <=0;
        Alu_result <= 0;
        Zero <= 0;
        Write_addr <=0;
        Read_data2 <= 0;
        Branch <= 0;
        MemRead <= 0;
        MemWrite <= 0;
        MemtoReg <= 0;  
        RegWrite <= 0;
        //rd <= 0;
        end
        
    else if(EX_MEM_reset && enable)// insert nop for one cycle stall
    begin
        pc_adder <=pc_adder;
        Alu_result <= Alu_result;
        Zero <= Zero;
        Write_addr <=Write_addr;
        Read_data2 <= Read_data2;
        Branch <= Branch;
        MemRead <= MemRead;
        MemWrite <= MemWrite;
        MemtoReg <= MemtoReg;  
        RegWrite <= RegWrite;
    end
        
    else if(enable)
    begin
       //Register output <= Moldules outputs
       pc_adder <= pc_adder_out;
       pc_adder1 <=  pc_adder_in;
       Zero <= Zero_out;
       Alu_result <= Alu_result_out;
       Read_data2 <= Read_data2_in;
       Write_addr <= Write_addr_out;
       Branch <= Branch_in;
       MemRead <= MemRead_in;
       MemWrite <= MemWrite_in;
       MemtoReg <= MemtoReg_in;
       RegWrite <= RegWrite_in;
       rd <= rd_in;
    end
    end
    
    Adder
 #(
    .Width_inout(`REGISTERS_WIDTH)
 )
 adder_ex
 (
    .adder_in_1(pc_adder_in),
    .adder_in_2(offset),
    .adder_out(pc_adder_out)
 );
    
       Mux_2to1 mx_ex1
    (
        .mux_in_1(Read_data1),
        .mux_in_2(Read_data2_in),
        .mux_control(AluSrc[0]),
        .mux_out(mx1_out)
    );
    
       Mux_2to1 mx_ex2
    (
        .mux_in_1(Read_data2_in),
        .mux_in_2(offset),
        .mux_control(AluSrc[1]),
        .mux_out(mx2_out)
    );
    
   Mux_4to1
   #(
        .Width_inout(`PC_WIDTH)
   ) mx_ex3
    (
        .mux_in_1(rt),
        .mux_in_2(rd_in),
        .mux_in_3('b11111),//31 for JAL instruction
        .mux_in_4('b0),//not used
        .mux_control(RegDst),
        .mux_out(Write_addr_out)
    );
    
    Mux_4to1
   #(
        .Width_inout(`PC_WIDTH)
   ) mx_ex4
    (
        .mux_in_1(mx1_out),
        .mux_in_2(Alu_result),
        .mux_in_3(MEM_WB_Write_Data),
        .mux_in_4('b0),//not used
        .mux_control(operand1_hazard),
        .mux_out(Alu_operand1)
    );
    
        Mux_4to1
   #(
        .Width_inout(`PC_WIDTH)
   ) mx_ex5
    (
        .mux_in_1(mx2_out),
        .mux_in_2(Alu_result),
        .mux_in_3(MEM_WB_Write_Data),
        .mux_in_4('b0),//not used
        .mux_control(operand2_hazard),
        .mux_out(Alu_operand2)
    );
    
    Alu alu
    (
      .Alu_operand1(Alu_operand1),
      .Alu_operand2(Alu_operand2),
      .alu_control_opcode(alu_control_opcode),
      .alu_result(Alu_result_out),
      .alu_zero(Zero_out)
    ); 
    
    Alu_control alu_control
    (
        .inst_function(offset[`FUNCTION_SBIT + `FUNCTION_WIDTH -1 : `FUNCTION_SBIT]),
        .control_aluop(Aluop),
        .alu_control_opcode(alu_control_opcode)
    );

    
    
endmodule