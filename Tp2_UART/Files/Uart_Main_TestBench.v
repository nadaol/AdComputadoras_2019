`timescale 1us / 1ns

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:22:28 09/30/2019
// Design Name:   Main
// Module Name:   /home/nadaol/git/adcomputadoras_2019/Tp2_UART/Ise_Project/Uart_Main_TestBench.v
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

module Uart_Main_TestBench;

	// Inputs
	reg clk;
	reg reset;
	reg rx;
//	wire rd_uart, wr_uart, tx_full, rx_empty;
//	wire [8-1:0] w_data, r_data, a, b, op, w;
wire [8-1:0] led;

	// Outputs
	wire tx,tick;

	// Instantiate the Unit Under Test (UUT)
	Main uut (
		.clk(clk), 
		.reset(reset), 
		.rx(rx), 
		.tx(tx),
	 .led(led)
	);
	
Uart_BaudRateGen u(.tick(tick));

	initial begin
			clk = 0;
			forever begin
					#0.01 clk = ~clk;
			end
	end
	initial begin
		// Initialize Inputs
		reset = 1;
		rx = 1;

		// Wait 100 ns for global reset to finish
		#100;
		#1 reset = 0;
		// Add stimulus here
		#300
		//start bit
		#1 rx=0;
		//data
		#52 rx=1;
		#52 rx=0;
		#52 rx=0;
		#52 rx=0;
		#52 rx=0;
		#52 rx=0;
		#52 rx=0;
		#52 rx=0;
		//stop bit
		#52 rx=1;
		#300
		
		//start bit
		#52 rx=0;
		//data
		#52 rx=1;
		#52 rx=1;
		#52 rx=0;
		#52 rx=0;
		#52 rx=0;
		#52 rx=0;
		#52 rx=0;
		#52 rx=0;
		//stop bit
		#52 rx=1;
		
		
		//start bit
		#52 rx=0;
		//data
		#52 rx=0;
		#52 rx=0;
		#52 rx=0;
		#52 rx=0;
		#52 rx=0;
		#52 rx=1;
		#52 rx=0;
		#52 rx=0;
		//stop bit
		#52 rx=1;
		
	end
      
endmodule