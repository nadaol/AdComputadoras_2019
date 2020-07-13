`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2020 22:24:14
// Design Name: 
// Module Name: test_bench_rx
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

module test_bench_IF_Uart();
    
//IF_top inputs
	reg clk,reset,enable,tx_start,tx_out,rea;
	reg [`PC_WIDTH - 1 :0] pc_offset;
	reg [`WORD_WIDTH-1:0] tx_in;
    reg [`PC_WIDTH - 1 :0] pc_inst_index;
    reg [`REGISTERS_WIDTH - 1 :0] pc_register;
    reg [1:0] pc_src;
    wire wea;
    wire [`PC_WIDTH - 1 :0] write_addr;
    wire [`INST_WIDTH - 1 :0]instruction_data_write;
 //Uart_top inputs   
    wire rx_in,tx_done;
    
//IF_top outputs
    wire [`PC_WIDTH - 1 :0] pc_adder;
    wire [`INST_WIDTH - 1 :0] instruction;
        wire tick;

//Test Variables
    reg [`INST_WIDTH-1:0] ram [`INST_MEMORY_DEPTH-1:0]  ;
    integer i;
    integer j;
	
	always #`CLK_PERIOD clk = !clk;
	
	initial
	begin
	   $readmemh("out.coe",ram,0);         //Cargo instrucciones
	   enable = 1'b0;
	   tx_start = 1'b0;
	   clk =           1'b0;
	   tx_in = {`WORD_WIDTH{1'b0}};
	   @(posedge clk) #1;   
	   reset =         1'b1;
	   repeat(10)                                  //Resetear y esperar 10 ciclos de reloj
	   @(posedge clk) #1;                   
        reset= 0;
        i = 0;
        j=0 ;
        //Enviar las intrucciones (out.coe)al modulo tx para cargarlas en memoria de instruccion
        while(ram[i] == ram[i])
        begin
            while(j<`INST_WIDTH/`WORD_WIDTH)
               begin
	           tx_in = ( ram[i] >> (j*`WORD_WIDTH) );
	           tx_start = 1'b1;
	           @(negedge tx_done)tx_start = 1'b0;
	           #10000;
	           j = j + 1;
	           end
	      i = i + 1 ;
	      j = 0;
	      end
        tx_start = 1'b0;
        rea = 1'b1;
        pc_src = 2'b00;  
        @(posedge clk) #1;  
        enable = 1'b1;  
	   
	   repeat(10)                  //Lectura primeras 10 instrucciones
	   @(posedge clk) #1;
	   $finish;
	   
	end
	
//Module under test Instantiation
Uart_top uart
(
    .clk(clk),
    .tx_start(tx_start),
    .tx_in(tx_in),
    .tx_out(rx_in),//connect tx_out rx_in
    .tx_done(tx_done),
    .reset(reset),
    .rx_in(rx_in),
    .wea(wea),
    .tick(tick),
    .instruction_data_write(instruction_data_write),
    .write_addr(write_addr)
);
	
//Module under test Instantiation
IF_top if_top
(
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .pc_offset(pc_offset),
    .pc_inst_index(pc_inst_index),
    .pc_register(pc_register),
    .pc_src(pc_src),
    .wea(wea),
    .rea(rea),
    .instruction_data_write(instruction_data_write),
    .write_addr(write_addr),
    .pc_adder(pc_adder),
    .instruction(instruction)
);  
     
endmodule   	
