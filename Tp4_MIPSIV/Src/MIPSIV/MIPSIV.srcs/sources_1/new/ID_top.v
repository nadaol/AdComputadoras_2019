`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2020 19:02:55
// Design Name: 
// Module Name: ID_top
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

*/

module ID_top(
    //inputs
    input clk,reset,
    input [`PC_WIDTH - 1 :0] pc_adder_in,
    input [`INST_WIDTH - 1 :0] instruction,
    input [`RD_WIDTH - 1 : 0] Write_addr,
    input [`REGISTERS_WIDTH - 1 :0] Write_data,
    //control signals in
    input RegWrite_in,Branch_in,Zero_in,
    //Outputs
    output reg [`PC_WIDTH - 1 :0] pc_adder,
    output reg [`REGISTERS_WIDTH - 1 :0] Read_data1,Read_data2,
    output reg [`REGISTERS_WIDTH - 1 :0] offset,
    output reg [`RT_WIDTH - 1 :0] rt,
    output reg [`RD_WIDTH - 1 :0] rd,
    output reg [`RS_WIDTH - 1 :0] rs,
    //Control signals out
    output reg Branch,Zero,MemRead,MemWrite,RegWrite,
    output reg [2:0]Aluop,RegDst,
    output reg [1:0]AluSrc,
    output reg [1:0] MemtoReg,
    output [1:0]pc_src
    );
    
    //Modules outputs (ID/EX register inputs)
    wire [`REGISTERS_WIDTH - 1 :0] Read_data1_out,Read_data2_out;
    wire [`REGISTERS_WIDTH - 1 :0] offset_out;
    //Control signals output
    wire [2:0] Aluop_out;
    wire [1:0] AluSrc_out,MemtoReg_out;
    wire Branch_out,MemRead_out,MemWrite_out,RegDst_out,RegWrite_out;
    
    //ID/EX Memory register
    always@(negedge clk)
    begin
    if(reset)
        begin
        //ID register outputs
        Read_data1 <= 0;
        Read_data2 <= 0;
        offset <=0;
        rt <= 0;
        rd <= 0;
        //control outputs
        RegWrite <= 0; //ID
        AluSrc <=0;//EX
        Aluop <= 0;
        RegDst <= 0;
        MemRead <= 0;//MEM
        MemWrite <= 0;
        Branch <=0;
        MemtoReg <= 0;//WB
        end
     else
     begin
        //Register output <= Moldules outputs
        Read_data1 <= Read_data1_out;
        Read_data2 <= Read_data2_out;
        offset <= offset_out;
        rt <= instruction[`RT_SBIT+`RT_WIDTH -1 :`RT_SBIT];
        rd <= instruction[`RD_SBIT+`RD_WIDTH -1 :`RD_SBIT];
        rs <= instruction[`RS_SBIT+`RS_WIDTH -1 :`RS_SBIT];
        //control outputs
        RegWrite <= RegWrite_out; //ID
        AluSrc <= AluSrc_out;//EX
        Aluop <= Aluop_out;
        RegDst <= RegDst_out;
        MemRead <= MemRead_out;//MEM
        MemWrite <= MemWrite_out;
        Branch <= Branch_out;
        MemtoReg <= MemtoReg_out;//WB
     end
    end
    

    
    Registers registers
    (
        .clk(clk), 
		.reset(reset),
		.control_write(RegWrite_in),
		.read_register1(instruction[`RS_SBIT+`RS_WIDTH -1 :`RS_SBIT]),
		.read_register2(instruction[`RT_SBIT+`RT_WIDTH -1 :`RT_SBIT]),
		.read_data1(Read_data1_out),
		.read_data2(Read_data2_out),
		.write_data(Write_data)
    );
    
    Sign_extend sign_extend
    (
        .sign_extend_in(instruction[`OFFSET_SBIT+`OFFSET_WIDTH -1 :`OFFSET_SBIT]),
        .sign_extend_out(offset_out)
    );
    
    Control control
    (
        //inputs
        .opcode(instruction[`OPCODE_SBIT+`OPCODE_WIDTH -1 :`OPCODE_SBIT]),
        .Function(instruction[`FUNCTION_SBIT+`FUNCTION_WIDTH -1 :`FUNCTION_SBIT]),
        .Zero_in(Zero_in),//?
        .Branch_in(Branch_in),
        //ouputs
        .pc_src(pc_src),
        .RegWrite(RegWrite_out),
        .AluSrc(AluSrc_out),
        .AluOp(Aluop_out),
        .regDst(reg_Dst_out),
        .MemRead(MemRead_out),
        .MemWrite(MemWrite_out),
        .Branch(Branch_out),
        .MemtoReg(MemtoReg_out)        
    );
    
endmodule
