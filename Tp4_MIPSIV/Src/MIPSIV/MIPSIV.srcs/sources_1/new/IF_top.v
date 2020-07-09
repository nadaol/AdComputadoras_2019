`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2020 20:46:04
// Design Name: 
// Module Name: IF_top
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

`define PC_WIDTH $clog2(`INST_MEMORY_DEPTH)

module IF_top
(
    input clk,reset,enable,                                     //PC enable control
    input [`PC_WIDTH - 1 :0] pc_offset,                          //PC <- PC+1+offset (BEQ,BNE)
    input [`PC_WIDTH - 1 :0] pc_inst_index,                      //PC <- inst_index (J,JAL) 
    input [`REGISTERS_WIDTH - 1 :0] pc_register,                 //PC <- rs (JR,JALR)
    input [1:0] pc_src,                                          //next pc value control
    input wea,rea,                                               //instr_memory write/read enable
    input [`PC_WIDTH - 1 :0] write_addr,                         //instr_memory write addr
    input [`INST_WIDTH - 1 :0] instruction_data_write,           //instr to write in inst_memory
    output reg[`PC_WIDTH - 1 :0] pc_adder,                      //Next instruction address to be readed ,out to ID stage
    output reg[`INST_WIDTH - 1 :0] instruction                      //Actual Instruction readed,to ID stage
    );

wire [`PC_WIDTH - 1 :0] pc_adder_out;        //pc+1 IF/ID output
wire [`INST_WIDTH - 1 :0] inst_memory_out;   //instruction IF/ID output

wire [`PC_WIDTH - 1 :0] next_pc;    //pc_mux output,next pc address input
wire [`PC_WIDTH - 1 :0] pc_addr;    //pc output address readed,inst mem input
    
    always@(negedge clk)
    begin
    if(reset)
        begin
        pc_adder <=0;
        instruction <=0;
        end
     else
     begin
        pc_adder <= pc_adder_out;
        instruction <= inst_memory_out;
     end
    end
    
 Mux_4to1
 #
 (
    .Width_inout(`INST_MEMORY_ADDR_WIDTH)
 )
  mux_pc
 (
    .mux_control(pc_src),
    .mux_in_1(pc_adder),
    .mux_in_2(pc_offset),
    .mux_in_3(pc_inst_index),
    .mux_in_4({`PC_WIDTH{1'b0}}),
    .mux_out(next_pc)
 );
 
 Pc Pc
(
		.clk(clk), 
		.reset(reset),
		.enable(enable),
		.i_addr(next_pc),
		.o_addr(pc_addr)
);
    
 Adder Adder
 (
    .adder_in_1(pc_addr),
    .adder_in_2(`PC_ADDER_VALUE),
    .adder_out(pc_adder_out)
 );
    
Memory Instruction_memory
(
		.clk(clk), 
		.reset(reset), 
		.wea(wea), 
		.rea(rea),
		.write_data(instruction_data_write), 
		.read_data(inst_memory_out), 
		.read_addr(pc_addr),
		.write_addr(write_addr)
);
    
endmodule