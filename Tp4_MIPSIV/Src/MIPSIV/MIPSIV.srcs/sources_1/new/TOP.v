`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.08.2020 20:25:54
// Design Name: 
// Module Name: TOP
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


module TOP(
// Inputs
input clk,reset,
input [`WORD_WIDTH-1:0] tx_in,//Instruccion in to uart to load to instruction memory
//Output
output tx_done      //Flag to know when to load next instruction
);


//-------- Uart output to IF input
wire wea,rea;
wire [`PC_WIDTH - 1:0] write_addr;
wire [`INST_WIDTH - 1 :0] instruction_data_write;
// Uart input
wire rx_in;
wire tx_start;

//--------- Forwarding unit outputs to EX input
wire [1:0] operand1_hazard;
wire [1:0] operand2_hazard;

//-------- Stall unit outputs related connections
wire enable;
wire IF_ID_write;
wire control_enable;

// --------- IF connections -------------

//IF output to IF input
wire [`INST_INDEX_WIDTH-1 : 0] IF_pc_instr_index;

//IF ouputs to ID inputs
wire [`PC_WIDTH - 1 :0] IF_pc_adder;
wire [`INST_WIDTH - 1 :0] IF_instruction;

//------------- ID stage connections ----------------

//ID outputs to EX inputs  
wire [`PC_WIDTH - 1 :0] ID_pc_adder;
wire [`REGISTERS_WIDTH - 1 :0] ID_Read_data1,ID_Read_data2;
wire [`REGISTERS_WIDTH - 1 :0] ID_offset;
wire [`RT_WIDTH - 1 :0] ID_rt;  //to forwarding unit too
wire [`RD_WIDTH - 1 :0] ID_rd;
//Control signals Used in Ex stage
wire [1:0]ID_AluSrc,ID_regDst;
wire [2:0]ID_Aluop;

//Control signals
// To IF stage
wire [1:0]ID_pc_src;
//used in later stages
wire ID_Branch,ID_MemWrite,ID_RegWrite;
wire [1:0] ID_MemtoReg;
wire ID_MemRead; // used in forwarding unit too

//ID outputs to Forwarding unit input
wire [`RS_WIDTH - 1 :0] ID_rs;


//-------------  EX stage connections ------------- 

//EX otputs to MEM stage input

wire [`PC_WIDTH - 1 :0] EX_pc_adder1;
wire [`REGISTERS_WIDTH - 1 :0] EX_Alu_result;
wire [`REGISTERS_ADDR_WIDTH - 1 :0] EX_Write_addr;
wire [`REGISTERS_WIDTH - 1 :0] EX_Read_data2;
wire [`RD_WIDTH - 1 :0] EX_rd;

//Control signals
wire EX_MemWrite;
wire [1:0] EX_MemtoReg;  //Used in later stages   
wire EX_MEM_Reg_write ; //used in forwarding unit input too
wire EX_MemRead;        //used in forwarding unit input too

//EX outputs to IF stage input
wire [`PC_WIDTH - 1 :0] EX_pc_adder;

// ------------- MEM stage connections ------------- 

//MEM outputs to WB stage input
wire [`REGISTERS_WIDTH -1 : 0] MEM_Read_data,MEM_Alu_result;
wire [`PC_WIDTH - 1 :0] MEM_pc_adder;
wire [1:0] MEM_MemtoReg;

//MEM outputs to ID stage input
wire [`REGISTERS_ADDR_WIDTH -1 :0] MEM_Write_addr;

//MEM outputs to Forwarding unit
wire [`REGISTERS_WIDTH - 1 : 0] MEM_rd;
wire MEM_WB_RegWrite;

// ------------- WB stage connections ------------- 

//WB outputs To ID stage input
wire [`REGISTERS_WIDTH -1 :0] WB_Write_data;

//Module under test Instantiation
Uart_top top_uart
(
    //inputs
    .clk(clk),
    .reset(reset),
    .rx_in(rx_in),
    .tx_start(tx_start),
    .tx_in(tx_in),
    //outputs
    .tx_out(rx_in),//connect tx_out rx_in
    .tx_done(tx_done),
    .wea(wea),
    .instruction_data_write(instruction_data_write),
    .write_addr(write_addr)
);

//Module under test Instantiation
IF_top top_if
(   
    //Inputs
    .clk(clk),
    .reset(reset),
    .write_addr(write_addr),
    .instruction_data_write(instruction_data_write),
    .pc_offset(EX_pc_adder),
    .pc_inst_index(IF_pc_instr_index),
    .pc_register(ID_Read_data1),
    //Input control signals
    .enable(enable),
    .IF_ID_write(IF_ID_write),
    .pc_src(ID_pc_src),
    .wea(wea),
    .rea(rea),
    //outputs
    .pc_adder(IF_pc_adder),
    .instruction(IF_instruction),
    .instr_index(IF_pc_instr_index)
);  


Stall_unit top_stall_unit
    (
        //inputs
        .reset (reset),
        .ID_EX_MemRead (ID_MemRead),
        .IF_ID_rs (IF_instruction[`RS_SBIT + `RS_WIDTH - 1:`RS_SBIT]),
        .IF_ID_rt (IF_instruction[`RT_SBIT + `RT_WIDTH - 1:`RT_SBIT]),
        .ID_EX_rt(ID_rt),
        //outputs
        .pc_Write(enable),
        .control_enable(control_enable),
        .IF_ID_write(IF_ID_write) 
    );
    
    // 11/08 -----------------------------
    
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

Forwarding_unit uut
(
    //input
    .ID_EX_rt(ID_EX_rt),
    .ID_EX_rs(ID_EX_rs),
    .MEM_WB_rd(MEM_WB_rd),
    .EX_MEM_rd(EX_MEM_rd),
    .MEM_WB_RegWrite(MEM_WB_RegWrite),
    .EX_MEM_RegWrite(EX_MEM_RegWrite),
    //outputs
    .operand1_hazard(operand1_hazard),
    .operand2_hazard(operand2_hazard)
);

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
    .rd_in(rd),
    .operand1_hazard(operand1_hazard),
    .operand2_hazard(operand2_hazard),
    .MEM_WB_Alu_result(MEM_WB_Alu_result),
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
    .Write_addr(Write_addr),
    .Read_data2(Read_data2),
    .Alu_result(EX_MEM_Alu_result),
    //Control signals out
    .Branch(Branch),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .Zero(Zero),
    .MemtoReg(MemtoReg)
);

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
    .RegWrite_in(RegWrite_in),
    .MemtoReg_in(MemtoReg_in),
    //outputs
    .Read_data(Read_data),
    .Alu_result(Alu_result),
    .Write_addr(Write_addr),
    //control signals out
    .MemtoReg(MemtoReg),
    .RegWrite(RegWrite)
);

WB_top wb_top(
//inputs
    .Read_data(Read_data),
    .Alu_result(Alu_result),
    .Return_Addr(Return_Addr),
    //control signals in
    .MemtoReg(MemtoReg),
    //outputs
    .Write_data(Write_data)
    );

endmodule
