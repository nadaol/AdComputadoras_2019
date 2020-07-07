`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.06.2020 04:09:15
// Design Name: 
// Module Name: test_bench_Registers
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
//Test parameters
`define CLK_PERIOD      5      //Periodo generador de clk en unidad especificada en timescale 


module test_bench_Registers();
//Test Parameters
    parameter memory_depth = `REGISTERS_DEPTH;
    parameter registers_width = `REGISTERS_WIDTH;

//Test Inputs
	reg clk;
	reg reset;
	reg control_write;
	reg [`REGISTERS_ADDRWIDTH-1:0] read_register1;
	reg [`REGISTERS_ADDRWIDTH-1:0] read_register2;
	reg [`REGISTERS_ADDRWIDTH-1:0] write_register;
	reg [`REGISTERS_WIDTH-1:0]     write_data;

//Test Outputs
	wire [`REGISTERS_WIDTH-1:0] read_data1;
	wire [`REGISTERS_WIDTH-1:0] read_data2;
	
	always #`CLK_PERIOD clk = !clk;
	
	initial
	begin
	   read_register1 = {`REGISTERS_ADDRWIDTH{1'b0}};//set addr del registro para lectura 1 en 0000
	   read_register2 = {`REGISTERS_ADDRWIDTH{1'b0}};//set addr del registro para lectura 2 en 0000
	   clk =           1'b0;
	   reset =         1'b1;
	   
	   repeat(10)                                  //Esperar 10 ciclos de reloj + #1
	   @(posedge clk) #1;                          //Escribir ffff en registro 0000
	   reset =         1'b0 ;
	   write_data =    {`REGISTERS_WIDTH{1'b1}};
	   write_register = {`REGISTERS_ADDRWIDTH{1'b0}};
       control_write = 1'b1 ;
       
	   repeat(10)                                //Esperar 10 clocks mas y desactivar la escritura
	   @(posedge clk) #1;
	   control_write = 1'b0 ;
	   
	   repeat(10)                                //Esperar 10 clocks mas y resetear todo
	   @(posedge clk) #1;
	   reset = 1'b1 ;
	   
	   repeat(10)
	   @(posedge clk) #1;
	   reset = 1'b0 ;
	   
	   repeat(10)
	   @(posedge clk) #1;
	   $finish;
	   
	end

//Module under test Instantiation
	Registers
	#(
	   .memory_depth(`REGISTERS_DEPTH),
	   .registers_width(`REGISTERS_WIDTH)
	)
	uut
	(
		.clk(clk), 
		.reset(reset), 
		.control_write(control_write), 
		.read_register1(read_register1), 
		.read_register2(read_register2), 
		.write_register(write_register), 
		.write_data(write_data), 
		.read_data1(read_data1), 
		.read_data2(read_data2)
    );
endmodule
