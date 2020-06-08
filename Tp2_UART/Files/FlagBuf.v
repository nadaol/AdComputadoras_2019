`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:27:54 09/28/2019 
// Design Name: 
// Module Name:    FlagBuf 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Uart_FlagBuf
#(parameter W = 8) // # bits del buffer 
					  (input wire clk, reset, 
						input wire clr_flag , set_flag , 
						input wire [W-1:0] din,
						output wire flag, 
						output wire [W-1:0] dout); 

// Señales internas
reg [W-1:0] buf_reg, buf_next ; 
reg flag_reg, flag_next; 

// FF & register 
always @(posedge clk) 
	if (reset) 
		begin 
			buf_reg <= 0; //buffer 
			flag_reg <= 1'b0; //full flag
		end 
	else 
		begin
			buf_reg <= buf_next;
			flag_reg <= flag_next;
		end 

// Logica de estados

always @* 
begin 
	buf_next = buf_reg; 
	flag_next = flag_reg; 
	if (set_flag)
		begin //levanto la bandera y cargo el dato ya recibido o para transmitir
			buf_next = din; 
			flag_next = 1'b1 ; 
		end 
	else 
		if (clr_flag) 
			flag_next = 1'b0; //bajo la bandera 
end 

//Logica de salida
assign dout = buf_reg; 
assign flag = flag_reg; 

endmodule 