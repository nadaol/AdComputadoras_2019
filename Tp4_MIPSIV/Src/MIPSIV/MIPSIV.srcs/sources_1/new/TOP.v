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
input clk,reset,start,tx_start,
input [`WORD_WIDTH-1:0] tx_in,//Instruccion in to uart to load to instruction memory
//Output
output tx_done      //Flag to know when to load next instruction
);


//-------- Uart output to IF input
wire wea,rea,enable2;
wire [`PC_WIDTH - 1:0] write_addr;
wire [`INST_WIDTH - 1 :0] instruction_data_write;
// Uart input
wire rx_in;

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
wire [`ALUOP_WIDTH -1:0]ID_Aluop;

//Control signals
// To IF stage
wire [1:0]ID_pc_src;
wire IF_ID_reset;           // -------------------------------------------------
//used in later stages
wire ID_Branch,ID_MemWrite,ID_RegWrite;
wire EX_MEM_reset;  // ---------------------------------------------------------
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
wire [`RD_WIDTH - 1 :0] EX_rd;// To forwarding unit

//Control signals
wire EX_MemWrite;
wire [1:0] EX_MemtoReg;  //Used in later stages   
wire EX_MEM_Reg_write ; //used in forwarding unit input too
wire EX_MemRead;        //used in forwarding unit input too

//EX outputs to IF stage input
wire [`PC_WIDTH - 1 :0] EX_pc_adder;

//EX outputs to ID stage input
wire EX_Zero;
wire EX_Branch;

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
    .rea(rea),
    .instruction_data_write(instruction_data_write),
    .write_addr(write_addr),
    .enable(enable2)
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
    .pc_register(ID_Read_data1),
    //Input control signals
    .enable(enable && enable2),
    .IF_ID_write(IF_ID_write && enable2),
    .enable_load(enable2),
    .IF_ID_reset(IF_ID_reset), // -----------------------------------------------
    .pc_src(ID_pc_src),
    .wea(wea),
    .rea(rea),
    //outputs
    .pc_adder(IF_pc_adder),
    .instruction(IF_instruction)
);  


Stall_unit top_stall_unit
    (
        //inputs
        .start (start),
        .ID_EX_MemRead (ID_MemRead),
        .IF_ID_rs (IF_instruction[`RS_SBIT + `RS_WIDTH - 1:`RS_SBIT]),
        .IF_ID_rt (IF_instruction[`RT_SBIT + `RT_WIDTH - 1:`RT_SBIT]),
        .ID_EX_rt(ID_rt),
        //outputs
        .enable(enable),
        .control_enable(control_enable),
        .IF_ID_write(IF_ID_write) 
    );


   ID_top id_top
(
    //inputs
    .clk(clk),
    .reset(reset),
    .pc_adder_in(IF_pc_adder),
    .instruction(IF_instruction),
    .Write_addr(MEM_Write_addr),
    .Write_data(WB_Write_data),
    //control inputs
    .RegWrite_in(MEM_WB_RegWrite),
    .Zero_in(EX_Zero),
    .control_enable(control_enable),
    .Branch_in(EX_Branch),
    .ID_write(enable2),
    //outputs
    .Read_data1(ID_Read_data1),
    .Read_data2(ID_Read_data2),
    .offset(ID_offset),
    .rt(ID_rt),
    .rd(ID_rd),
    .rs(ID_rs),
    .pc_adder(ID_pc_adder),
    //control signal outputs
    .RegWrite(ID_RegWrite),
    .Branch(ID_Branch),
    .MemRead(ID_MemRead),
    .MemWrite(ID_MemWrite),
    .regDst(ID_regDst),
    .Aluop(ID_Aluop),
    .AluSrc(ID_AluSrc),
    .MemtoReg(ID_MemtoReg),
    .pc_src(ID_pc_src),
    .IF_ID_reset(IF_ID_reset),// -------------------------------------------
    .EX_MEM_reset(EX_MEM_reset)
    
);

Forwarding_unit uut
(
    //input
    .ID_EX_rt(ID_rt),
    .ID_EX_rs(ID_rs),
    .MEM_WB_Write_Addr(MEM_Write_addr),
    .EX_MEM_Write_Addr(EX_Write_addr),
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
    .pc_adder_in(ID_pc_adder),
    .offset(ID_offset),
    .Read_data1(ID_Read_data1),
    .Read_data2_in(ID_Read_data2),
    .rt(ID_rt),
    .rd_in(ID_rd),
    .operand1_hazard(operand1_hazard),
    .operand2_hazard(operand2_hazard),
    .MEM_WB_Write_Data(WB_Write_data),
    //control signals in
    .RegDst(ID_regDst),
    .Aluop(ID_Aluop),
    .AluSrc(ID_AluSrc),
    .MemRead_in(ID_MemRead),//control signals not used in this stage
    .MemWrite_in(ID_MemWrite),
    .Branch_in(ID_Branch),
    .MemtoReg_in(ID_MemtoReg),
    .RegWrite_in(ID_RegWrite),
    .EX_MEM_reset(EX_MEM_reset), 
    .enable(enable2),            // enable ----------------------------------------
    //Outputs
    .pc_adder(EX_pc_adder),
    .pc_adder1(EX_pc_adder1),
    .Write_addr(EX_Write_addr),
    .Read_data2(EX_Read_data2),
    .Alu_result(EX_Alu_result),
    //Control signals out
    .Branch(EX_Branch),
    .MemRead(EX_MemRead),
    .MemWrite(EX_MemWrite),
    .Zero(EX_Zero),
    .MemtoReg(EX_MemtoReg),
    .rd(EX_rd),
    .RegWrite(EX_MEM_RegWrite)
);

MEM_top mem_top
(
    //inputs
    .clk(clk),
    .reset(reset),
    .Addr(EX_Alu_result),
    .Write_Data_in(EX_Read_data2),
    .Write_addr_in(EX_Write_addr),
    .pc_adder_in(EX_pc_adder1),
    .rd_in(EX_rd),
    //control signals in
    .MemWrite_in(EX_MemWrite),
    .MemRead_in(EX_MemRead),
    .RegWrite_in(EX_MEM_RegWrite),
    .MemtoReg_in(EX_MemtoReg),
    .MEM_write(enable2),
    //outputs
    .Read_data(MEM_Read_data),
    .Alu_result(MEM_Alu_result),
    .Write_addr(MEM_Write_addr),
    .rd(MEM_rd),
    .pc_adder(MEM_pc_adder),
    //control signals out
    .MemtoReg(MEM_MemtoReg),
    .RegWrite(MEM_WB_RegWrite)
);


WB_top wb_top(
//inputs
    .Read_data(MEM_Read_data),
    .Alu_result(MEM_Alu_result),
    .Return_Addr(MEM_pc_adder),
    //control signals in
    .MemtoReg(MEM_MemtoReg),
    //outputs
    .Write_data(WB_Write_data)
    );

endmodule
