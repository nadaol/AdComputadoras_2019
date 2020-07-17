`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.07.2020 16:13:16
// Design Name: 
// Module Name: WB_top
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


module WB_top(
  //inputs
    input clk,reset,
    input [`REGISTERS_WIDTH - 1 : 0] Read_data,Alu_result,
    input [`PC_WIDTH - 1 : 0] Return_Addr,
    //control signals in
    input [1:0] MemtoReg,
    
    //outputs
    output reg [`REGISTERS_WIDTH -1 :0] Write_data
    );
    
 Mux_4to1
 #
 (
    .Width_inout(`REGISTERS_WIDTH)
 )
  mux_wb
 (
    .mux_control(MemtoReg),
    .mux_in_1(Read_data),
    .mux_in_2(Alu_result),
    .mux_in_3(Return_ADDR),
    .mux_in_4({`REGISTERS_WIDTH{1'b0}}),
    .mux_out(Write_data)
 );
    
endmodule
