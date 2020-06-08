`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:19:41 09/25/2019 
// Design Name: 
// Module Name:    Main 
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
module Main  #( 								// Default setting: 
															// 19,200 baud , 8 data bits , 1 stop bit  
							parameter DBIT = 8, 		// # data bits 
										 SB_TICK = 16, // # ticks for stop bits , 
															// 16/24/32 for 1/1. 5/2 bits 
										 DVSR = 163,   // baud rate divisor 
															// DVSR = 50M/( 16* baud rate) 
										 DVSR_BIT = 8 // # bits of DVSR 
						 ) 
						 ( input wire clk, reset, rx,
						   output wire tx,
							output [DBIT-1:0]led
					    );

wire rd_uart, wr_uart, tx_full, rx_empty;
wire [DBIT-1:0] w_data, r_data, a, b, op, w;

assign led = w_data;
 
Alu #(.DATA_LENGTH(DBIT)) alu_unit 
	(.A(a), .B(b), .Op_code(op), .Resultado_reg(w)); 

Uart_Interface #(.REG_SIZE(DBIT)) interfaz_unit 
	(.clk(clk), .reset(reset), .rd_uart(rd_uart), .wr_uart(wr_uart), 
	 .tx_full(tx_full), .rx_empty(rx_empty), .w_data(w_data),
	 .r_data(r_data), .a(a), .b(b), .op(op), .w(w));

Uart #(.DBIT(DBIT), .SB_TICK(SB_TICK), .DVSR(DVSR), .DVSR_BIT(DVSR_BIT)) uart_unit
	(.clk(clk), .reset(reset), .rd_uart(rd_uart), .wr_uart(wr_uart), 
	 .tx_full(tx_full), .rx_empty(rx_empty), .w_data(w_data),
	 .r_data(r_data), .rx(rx), .tx(tx));	 



endmodule