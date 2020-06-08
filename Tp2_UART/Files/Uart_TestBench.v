`timescale 1us / 1ns

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:50:11 09/28/2019
// Design Name:   Uart
// Module Name:   /home/nadaol/git/adcomputadoras_2019/Tp2_UART/Ise_Project/Uart_TestBench.v
// Project Name:  Uart
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Uart
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Uart_TestBench;

// Inputs
	reg clk;
	reg reset;
	reg rd_uart;
	reg wr_uart;
	reg rx;
	reg [7:0] w_data;

	// Outputs
	wire tx_full;
	wire rx_empty;
	wire tx;
	wire [7:0] r_data;

	// Instantiate the Unit Under Test (UUT)
	Uart uut (
		.clk(clk), 
		.reset(reset), 
		.rd_uart(rd_uart), 
		.wr_uart(wr_uart), 
		.rx(rx), 
		.w_data(w_data), 
		.tx_full(tx_full), 
		.rx_empty(rx_empty), 
		.tx(tx), 
		.r_data(r_data)
	);
	initial begin
			clk = 0;
			forever begin
					#0.01 clk = ~clk;//50[Mhz] -> Tick~307[KHz]
			end
	end

	initial begin
		// Initialize Inputs
		reset = 1;
		rd_uart = 0;
		wr_uart = 0;
		rx = 1;
		w_data = 0;
		#100;
		reset = 0;
		#52.16 rx = 0;//start bit
		#52.16 rx = 1;
		#52.16 rx = 1;
		#52.16 rx = 1;
		#52.16 rx = 0;
		#52.16 rx = 0;
		#52.16 rx = 1;
		#52.16 rx = 1;
		#52.16 rx = 1;
		#52.16 rx = 1;//stop bit
		
		#52.16 rx = 0;//start bit
		#52.16 rx = 0;
		#52.16 rx = 0;
		#52.16 rx = 0;
		#52.16 rx = 1;
		#52.16 rx = 1;
		#52.16 rx = 0;
		#52.16 rx = 0;
		#52.16 rx = 0;
		#52.16 rx = 0;//stop bit
		
		#52.16 rd_uart = 1;
		#0.02 rd_uart = 0;
		
	end
      
endmodule

