`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2020 23:54:03
// Design Name: 
// Module Name: Mux
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


module Mux_2to1
#(
    parameter Width_inout = 32
)
(
    input  mux_control,
    input [(Width_inout) -1 :0] mux_in_1,
    input [(Width_inout) -1 :0] mux_in_2,
    output [Width_inout - 1 :0] mux_out
    );
    
   assign mux_out = mux_control ? mux_in_1 : mux_in_2;
   
endmodule
