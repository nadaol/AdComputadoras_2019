`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2020 23:15:36
// Design Name: 
// Module Name: Sign_extend
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


module Sign_extend
#(
    parameter Width_in = 16,
    parameter Width_out = 32
)
(
    input [Width_in - 1 :0] sign_extend_in,
    output [Width_out - 1 :0] sign_extend_out
    );
    
assign sign_extend_out = sign_extend_in;
    
endmodule
