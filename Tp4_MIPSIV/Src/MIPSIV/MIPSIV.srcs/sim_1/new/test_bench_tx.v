`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.07.2020 21:59:49
// Design Name: 
// Module Name: test_bench_tx
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
//`define CLK_PERIOD      5      //Periodo generador de clk en unidad especificada en timescale 
//`define BAUD_RATE       19200
//`define FREC_CLOCK_MHZ 100
`define STOP_BIT_COUNT          1          // Cantidad de bits de parada de trama UART.
//`define WORD_WIDTH                8          // Tamanio de palabra util enviada por trama UART.

module test_bench_tx();
    
//Test Inputs
	reg clk;
	reg reset;
	reg tx_start;
	reg [`WORD_WIDTH-1:0] tx_in;

//Test Outputs
    //baud rate generator output
	wire tick;
	//tx outputs
	wire tx_out;
	wire tx_done;
	
	always #`CLK_PERIOD clk = !clk;
	
	initial
	begin
	   clk =           1'b0;
	   @(posedge clk) #1;   
	   reset =         1'b1;
	   repeat(10)                                  //Resetear y esperar 10 ciclos de reloj
	   @(posedge clk) #1;                   
        reset= 1'b0;
        tx_in = `WORD_WIDTH'h55;
        tx_start = 1'b1;                            //Comenzar transmision primer dato
	                               
        @(posedge tx_done) #1;
        @(negedge tx_done) #1;
        tx_in = `WORD_WIDTH'h77;
        @(posedge tx_done) #1;
        @(negedge tx_done) #1;
        tx_in = `WORD_WIDTH'h44;
        @(posedge tx_done) #1;
        @(negedge tx_done) #1;
        tx_in = `WORD_WIDTH'h66;
        @(posedge tx_done) #1;
        @(negedge tx_done) #1;
        
        tx_start = 1'b0;
        repeat(200)
        @(posedge tick) #1;
        
        tx_start = 1'b1;
        tx_in = `WORD_WIDTH'h77;
        @(posedge tx_done) #1;
        @(negedge tx_done) #1;
        tx_in = `WORD_WIDTH'h44;
        @(posedge tx_done) #1;
        @(negedge tx_done) #1;
        
        tx_start = 1'b0;

	   $finish;
	   
	end
	
//Module under test Instantiation
	Baud_rate_generator
	#(
	   .BAUD_RATE(`BAUD_RATE),
	   .FREC_CLOCK_MHZ(`FREC_CLOCK_MHZ)
	)
	uut1
	(
		.clk(clk), 
		.baud_rate_tick(tick),
		.reset(reset)
    );
	
//Module under test Instantiation
	Tx
	#(
	   .WORD_WIDTH(`WORD_WIDTH),
	   .STOP_BIT_COUNT(`STOP_BIT_COUNT)
	)
	uut2
	(
		.clk(clk), 
		.tick(tick),
		.tx_in(tx_in),
		.reset(reset), 
		.tx_out(tx_out),
		.tx_done(tx_done),
		.tx_start(tx_start)
    );
    
     
endmodule  