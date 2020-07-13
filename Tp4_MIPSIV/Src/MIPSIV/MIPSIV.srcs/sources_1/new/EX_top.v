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


module EX_top(
    //inputs
    input clk,reset,
    input [`PC_WIDTH - 1 :0] pc_adder_in,
    input [`REGISTERS_WIDTH - 1 :0] offset,
    input [`REGISTERS_WIDTH - 1 :0] Read_data1,Read_data2_in,
    input [`RT_WIDTH - 1 :0] rt,
    input [`RD_WIDTH - 1 :0] rd,
    //control signals in
    input RegDst,
    input [2:0]Aluop,
    input [1:0] AluSrc,
    input MemRead_in,MemWrite_in,Branch_in,
    input [1:0] MemtoReg_in,
    
    //Outputs
    output reg [`PC_WIDTH - 1 :0] pc_adder,
    output reg [`REGISTERS_WIDTH - 1 :0] Alu_result,
    output reg Zero,
    output reg [`RT_WIDTH - 1 :0] Write_addr,
    output reg [`REGISTERS_WIDTH - 1 :0] Read_data2,
    //Control signals out
    output reg Branch,MemRead,MemWrite,
    output reg [1:0] MemtoReg
    );
    
    //Internal signals
    wire [`REGISTERS_WIDTH - 1 :0] Alu_operand1,Alu_operand2;
    wire [`ALU_CONTROL_WIDTH -1 : 0] alu_control_opcode;
    wire [`ALUOP_WIDTH - 1 : 0] AluOp;
    //Modules outputs
    wire [`PC_WIDTH - 1 :0] pc_adder_out;
    wire Zero_out;
    wire [`REGISTERS_WIDTH - 1 :0] Alu_result_out;
    wire [`REGISTERS_WIDTH - 1 :0] Read_data2_out;
    wire [`RT_WIDTH - 1 :0] Write_addr_out;
    wire MemWrite_out,MemRead_out,Branch_out;
    wire [1:0] MemtoReg_out;

 //ID/EX Memory register
    always@(negedge clk)
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
        end
     else
     begin
        //Register output <= Moldules outputs
       pc_adder <= pc_adder_out;
       Zero <= Zero_out;
       Alu_result <= Alu_result_out;
       Read_data2 <= Read_data2_out;
       Write_addr <= Write_addr_out;
     end
    end
    
    Adder Adder
 (
    .adder_in_1(pc_addr_in),
    .adder_in_2(offset),
    .adder_out(pc_adder_out)
 );
    
       Mux_2to1 mx_ex1
    (
        .mux_in_1(Read_data1),
        .mux_in_2(Read_data2),
        .mux_control(AluSrc[0:0]),
        .mux_out(Alu_operand1)
    );
    
       Mux_2to1 mx_ex2
    (
        .mux_in_1(Read_data2),
        .mux_in_2(offset),
        .mux_control(AluSrc[1:1]),
        .mux_out(Alu_operand2)
    );
    
   Mux_2to1 mx_ex3
    (
        .mux_in_1(rt),
        .mux_in_2(rd),
        .mux_control(regDst),
        .mux_out(Write_addr)
    );
    
    Alu alu
    (
      .Alu_operand1(Alu_operand1),
      .Alu_operand2(Alu_operand1),
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