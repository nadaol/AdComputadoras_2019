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


module ID_top(
    //inputs
    input clk,reset,
    input [`PC_WIDTH - 1 :0] pc_adder_in,
    input [`INST_WIDTH - 1 :0] instruction,
    input [`RD_WIDTH - 1 : 0] Write_addr,
    input [`REGISTERS_WIDTH - 1 :0] Write_data,
    //control signals in
    input RegWrite,branch_taken,
    //Outputs
    output reg [`REGISTERS_WIDTH - 1 :0] Read_data1,Read_data2,
    output reg [`REGISTERS_WIDTH - 1 :0] offset,
    output reg [`RT_WIDTH - 1 :0] rt,
    output reg [`RD_WIDTH - 1 :0] rd,
    output reg [`PC_WIDTH - 1 :0] pc_adder,
    //Control signals out
    output reg Branch,MemRead,MemWrite,RegDst,
    output reg [2:0]Aluop,
    output reg [1:0]AluSrc,
    output reg [1:0] MemtoReg,
    output reg [1:0]pc_src
    );
    
    //Modules outputs (ID/EX register inputs)
    wire [`REGISTERS_WIDTH - 1 :0] Read_data1_out,Read_data2_out;
    wire [`REGISTERS_WIDTH - 1 :0] offset_out;
    wire [`RT_WIDTH - 1 :0] rt_out;
    wire [`RD_WIDTH - 1 :0] rd_out;
    wire [2:0] Aluop_out;
    wire [1:0] AluSrc_out,pc_src_out;
    wire Branch_out,MemRead_out,MemWrite_out,RegDst_out;
    
    //ID/EX Memory register
    always@(negedge clk)
    begin
    if(reset)
        begin
        //Reset register outputs
        AluSrc <=0;
        Branch <=0;
        MemRead <= 0;
        MemWrite <= 0;
        RegDst <= 0;
        MemtoReg <= 0;
        Aluop <= 0;
        pc_src <= 0;
        Read_data1 <= 0;
        Read_data2 <= 0;
        rt <= 0;
        rd <= 0;
        offset <=0;
        end
     else
     begin
        //Register output <= Moldules outputs
        AluSrc <= AluSrc_out;
        Branch <= Branch_out;
        MemRead <= MemRead_out;
        MemWrite <= AluSrc_out;
        RegDst <= AluSrc_out;
        MemtoReg <= AluSrc_out;
        Aluop <= AluSrc_out;
        pc_src <= AluSrc_out;
        Read_data1 <= Read_data1_out;
        Read_data2 <= Read_data2_out;
        rt <= rt_out;
        rd <= rd_out;
        pc_adder <= pc_adder_in;
        offset <= offset_out;
     end
    end
    

    
    Registers registers
    (
        .clk(clk), 
		.reset(reset),
		.control_write(RegWrite),
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
        .opcode(instruction[`OPCODE_SBIT+`OPCODE_WIDTH -1 :`OPCODE_SBIT]),
        .Function(instruction[`FUNCTION_SBIT+`FUNCTION_WIDTH -1 :`FUNCTION_SBIT]),
        .regDst(reg_Dst_out),
        .Branch(Branch_out),
        .branch_taken(branch_taken),//?
        .RegWrite(RegWrite_out),
        .AluSrc(AluSrc_out),
        .AluOp(Aluop_out),
        .MemRead(MemRead_out),
        .MemWrite(MemWrite_out),
        .MemtoReg(MemtoReg_out)
    );
 
//non module outputs
assign rt_out = instruction[`RT_SBIT+`RT_WIDTH -1 :`RT_SBIT];   
assign rd_out = instruction[`RD_SBIT+`RD_WIDTH -1 :`RD_SBIT];
    
endmodule
