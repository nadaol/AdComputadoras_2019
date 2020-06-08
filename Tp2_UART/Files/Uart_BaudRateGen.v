`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:57:04 09/25/2019 
// Design Name: 
// Module Name:    Uart_BaudRateGen 
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
module Uart_BaudRateGen
#( 
 parameter N=8, //Cantidad de bits del contador
 parameter M=163//Numero divisor de frecuencia
 //para un clock de 50Mhz-> 50Mhz/163 ~ 307Khz -> 307Khz/16~19200Hz
						) 
( 
input wire clk, reset, 
output wire tick 
						); 
//Declaracion de señales internas
reg [N-1:0] r_reg; //registro contador
wire [N-1:0] r_next; //contador

//Registros
always @(posedge clk) 
	if (reset) 
		r_reg <= 0; 
	else 
		r_reg <= r_next; 

// Logica de cambio de estados
assign r_next = (r_reg == (M-1)) ? 0 : r_reg + 1; 

//Logica de salida (1 cuando contador==162)
assign tick = (r_reg==(M-1)) ? 1'b1 : 1'b0; 
endmodule 