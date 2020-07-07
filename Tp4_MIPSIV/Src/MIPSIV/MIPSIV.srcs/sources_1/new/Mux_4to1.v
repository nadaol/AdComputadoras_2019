`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.07.2020 21:49:05
// Design Name: 
// Module Name: Mux_2to4
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


module Mux_4to1#(
    parameter Width_inout = 32
)
(
    input [2:0] mux_control,
    input [(Width_inout) -1 :0] mux_in_1,
    input [(Width_inout) -1 :0] mux_in_2,
    input [(Width_inout) -1 :0] mux_in_3,
    input [(Width_inout) -1 :0] mux_in_4,
    output [Width_inout - 1 :0] mux_out
    );
    
    assign mux_out = mux_control[1] ? (mux_control[0] ? mux_in_4 : mux_in_3) : (mux_control[0] ? mux_in_2 : mux_in_1);
   
endmodule
