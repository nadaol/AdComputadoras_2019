`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.07.2020 20:06:50
// Design Name: 
// Module Name: Stall_unit
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

module Stall_unit(
input reset,
input ID_EX_MemRead,
input [`RS_WIDTH - 1 :0] IF_ID_rs,
input [`RT_WIDTH - 1 :0] IF_ID_rt,
input [`RT_WIDTH - 1 :0] ID_EX_rt,
output reg pc_Write,
output reg control_enable,
output reg IF_ID_write
);

always @ *
begin
    if(reset)
    begin
			pc_Write <= 1;
			control_enable <= 1;
			IF_ID_write <= 1;
		end
		
	else if( ID_EX_MemRead && ((ID_EX_rt == IF_ID_rs) ||(ID_EX_rt == IF_ID_rt)))
		begin
			pc_Write <= 0;
			control_enable <= 0;
			IF_ID_write <= 0;
		end
	else
		begin
			pc_Write <= 1;
			control_enable <= 1;
			IF_ID_write <= 1;
		end
end

endmodule
