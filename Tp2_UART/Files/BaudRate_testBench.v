`timescale 1us / 1ns

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:31:54 10/01/2019
// Design Name:   Uart_BaudRateGen
// Module Name:   /home/nadaol/git/adcomputadoras_2019/Tp2_UART/Ise_Project/BaudRate_testBench.v
// Project Name:  Uart
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Uart_BaudRateGen
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module BaudRate_testBench;

	// Entradas
	reg clk;
	reg reset;

	//Salidas
	wire tick;

	// Instantiate the Unit Under Test (UUT)
	Uart_BaudRateGen uut (
		.clk(clk), 
		.reset(reset), 
		.tick(tick)
	);

	initial begin
			clk = 0;
			forever begin
					#0.01 clk = ~clk;
			end
	end
	initial begin
#100 reset = 1;
		#100 
		// Wait 100 ns for global reset to finish
reset =0;

	end
      
endmodule

