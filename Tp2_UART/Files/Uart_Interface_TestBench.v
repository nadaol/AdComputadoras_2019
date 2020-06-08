`timescale 1us / 1ns

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:53:03 09/29/2019
// Design Name:   Main
// Module Name:   /home/nadaol/git/adcomputadoras_2019/Tp2_UART/Ise_Project/Uart_Interface_TestBench.v
// Project Name:  Uart
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Main
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Uart_Interface_TestBench;

	//Entradas
	reg clk;
	reg reset;
	reg tx_full;
	reg rx_empty;
	reg [7:0] r_data;
	reg [7:0] w;

	//Salidas
	wire rd_uart;
	wire wr_uart;
	wire [7:0] w_data;
	wire [7:0] a;
	wire [7:0] b;
	wire [7:0] op;

	// Instantiate the Unit Under Test (UUT)
	Uart_Interface uut (
		.clk(clk), 
		.reset(reset), 
		.rd_uart(rd_uart), 
		.wr_uart(wr_uart), 
		.w_data(w_data), 
		.tx_full(tx_full), 
		.rx_empty(rx_empty), 
		.r_data(r_data), 
		.a(a), 
		.b(b), 
		.op(op), 
		.w(w)
	);
	
	initial begin
			clk = 0;
			forever begin
					#0.01 clk = ~clk;
			end
	end

	initial begin
		// Initialize Inputs
		reset = 1;
		tx_full = 0;
		rx_empty = 1;
		r_data = 0;
		w = 8'b10000010;

		// Wait 100 ns for global reset to finish
		#100 reset =0;
		#1 r_data = 8'b00000001;//valor primer operando
		rx_empty = 0;
		#0.02 rx_empty= 1;
		#0.02 r_data = 8'b00000100;//valor segundo operando
		rx_empty = 0;
		#0.02 rx_empty= 1;
		#0.02 r_data = 8'b10000000;//valor operando (suma)
		rx_empty = 0;
		#0.02 rx_empty= 1;

	end
      
endmodule

