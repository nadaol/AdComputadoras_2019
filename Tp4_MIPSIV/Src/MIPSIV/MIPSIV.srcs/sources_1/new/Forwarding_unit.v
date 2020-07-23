`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.07.2020 16:59:07
// Design Name: 
// Module Name: Forwarding_unit
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


module Forwarding_unit(
//inputs
input [`RT_WIDTH - 1 :0] ID_EX_rt,
input [`RS_WIDTH - 1 :0] ID_EX_rs,
input [`RD_WIDTH - 1 :0] MEM_WB_rd,
input [`RD_WIDTH - 1 :0] EX_MEM_rd,
//outputs
output [1:0] operand1_hazard,
output [1:0] operand2_hazard
    );
    
    
    
endmodule
