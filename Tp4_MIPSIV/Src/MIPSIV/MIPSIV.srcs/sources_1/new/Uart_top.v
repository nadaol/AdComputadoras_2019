`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2020 22:40:52
// Design Name: 
// Module Name: Uart_top
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

module Uart_top
(
    input rx_in,clk,reset,tx_start,
    input [`WORD_WIDTH-1:0] tx_in,
    output rea,tx_done,
    output wea,tick,tx_out,
    output [`PC_WIDTH - 1:0] write_addr,
    output [`INST_WIDTH - 1 :0] instruction_data_write,
    output clk_out
    );
    
    wire rx_done; 
    wire [`WORD_WIDTH-1:0] rx_out;
    
 Baud_rate_generator Baud_rate_gen
	(
		.clk(clk), 
		.baud_rate_tick(tick),
		.reset(reset)
    );
	
	Rx Rx
	(
		.clk(clk), 
		.tick(tick),
		.rx(rx_in),
		.reset(reset), 
		.rx_out(rx_out),
		.rx_done(rx_done)
    );
    
    Tx Tx
	(
		.clk(clk), 
		.tick(tick),
		.tx_in(tx_in),
		.reset(reset), 
		.tx_out(tx_out),
		.tx_start(tx_start),
		.tx_done(tx_done)
    );
    
    Instruction_loader Loader
	(
		.clk_in(clk), 
		.reset(reset), 
		.rx_out(rx_out),
		.rx_done(rx_done),
		.loader_inst_out(instruction_data_write),
		.loader_addr_out(write_addr),
		.loader_wea(wea),
		.loader_rea(rea),
		.clk(clk_out)
    );   
    
endmodule
