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
input start,
input ID_EX_MemRead,
input [`RS_WIDTH - 1 :0] IF_ID_rs,
input [`RT_WIDTH - 1 :0] IF_ID_rt,
input [`RT_WIDTH - 1 :0] ID_EX_rt,
output reg enable_pc,
output reg control_enable,
output reg IF_ID_write
);

always @ *
begin
    if(start)
    begin           //Valor inicial de arranque
			enable_pc <= 1;
			control_enable <= 1;
			IF_ID_write <= 1;
		end
	
    else
    begin
        enable_pc <= 0;
        control_enable <= 0;
        IF_ID_write <= 0;
    end

		//Condición de dependencia de registros con una instrucción load
	 if( ID_EX_MemRead && ((ID_EX_rt == IF_ID_rs) ||(ID_EX_rt == IF_ID_rt)))
		begin                 //Introducción del retardo
			enable_pc <= 0;
			control_enable <= 0;
			IF_ID_write <= 0;
		end
end

endmodule

