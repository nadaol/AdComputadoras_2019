`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2020 23:57:58
// Design Name: 
// Module Name: Add
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
`define INST_MEMORY_ADDR_WIDTH $clog2(`INST_MEMORY_DEPTH)

module Adder
#
(
    parameter Width_inout = `INST_MEMORY_ADDR_WIDTH
)
(
    input [Width_inout-1:0] adder_in_1,
    input [Width_inout-1:0] adder_in_2,
    input [Width_inout-1:0] adder_out
    );
   
 assign adder_out = adder_in_1 + adder_in_2;
 
endmodule
