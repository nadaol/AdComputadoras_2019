`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2020 19:00:44
// Design Name: 
// Module Name: test_bench_Instruction_memory
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


//Module under test parameters
`define MEMORY_WIDTH 32       // Tamano de los registros    
`define MEMORY_ADDRWIDTH $clog2(memory_depth)
//Test parameters
`define CLK_PERIOD      10      //Periodo generador de clk en unidad especificada en timescale 


module test_bench_Instruction_memory();
//Test Parameters
    parameter memory_depth = `DATA_MEMORY_DEPTH;
    parameter memory_width = `DATA_MEMORY_WIDTH;

//Test Inputs
	reg clk;
	reg reset;
	reg wea;
	reg rea;
	reg [`MEMORY_WIDTH-1:0] instruction_memory_in;
	reg [`MEMORY_ADDRWIDTH-1:0] pc_addr;
	

//Test Outputs
	wire [`MEMORY_WIDTH-1:0] instruction_memory_out;
//Test Variables	
		   integer i = 0;
		   
	always #`CLK_PERIOD clk = !clk;
	
	initial
	begin
	   //Initialize inputs and reset
	   instruction_memory_in = 0;
	   pc_addr =  0;
	   clk =           1'b0;
	   reset =         1'b1;
	   wea = 1'b0;
	   repeat(10)                                  //Esperar 10 ciclos de reloj + #1
	   @(posedge clk) #1;                          
	   reset =         1'b0 ;
	   wea = 1'b1;
	   rea = 1'b1;
        //Sequential write & read in memory
	   repeat(10)                               
	   @(posedge clk) #1;
	   for (i = 0 ; i < memory_depth-1 ; i = i + 1)
	       begin
	       pc_addr = i;
           instruction_memory_in = i ;                      
	       @(posedge clk) #1;  //write
	       @(negedge clk) # 1; //read
           end

/*	  	   //reset and finish
	   repeat(10)
	   @(posedge clk) #1;
	   reset = 1'b1 ;

	   repeat(10)
	   @(posedge clk) #1;
	   reset = 0;
	   repeat(10)
	   @(posedge clk) #1;*/
	   $finish;
	   
	end

//Module under test Instantiation
	Memory
	#(
	   .memory_depth(`DATA_MEMORY_DEPTH),
	   .memory_width(`DATA_MEMORY_WIDTH)
	)
	uut
	(
		.clk(clk), 
		.reset(reset), 
		.wea(wea), 
		.rea(rea),
		.write_data(instruction_memory_in), 
		.read_data(instruction_memory_out), 
		.read_addr(pc_addr),
		.write_addr(pc_addr)
    );
endmodule

