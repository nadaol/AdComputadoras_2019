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

`define CLK_PERIOD      5      //Periodo generador de clk en unidad especificada en timescale 
//`define BAUD_RATE       19200
//`define FREC_CLOCK_MHZ 100
`define STOP_BIT_COUNT          1          // Cantidad de bits de parada de trama UART.
//`define WORD_WIDTH                8          // Tamanio de palabra util enviada por trama UART.
//`define INSTRUCTION_WIDTH 32 //WORD_IN_WIDTH * 4
`define MEMORY_DEPTH 128 //instruction memory depth

module test_bench_rx();

    parameter MEMORY_DEPTH = `MEMORY_DEPTH;
    
//Test Inputs
	reg clk;
	reg reset;
	reg rx;
	reg rea;

//Test Outputs
    //baud rate generator output
	wire tick;
	//rx outputs
	wire rx_done;
	wire [`WORD_WIDTH-1:0] rx_out;
	//loader outputs
	wire [`INSTRUCTION_WIDTH-1:0] loader_inst_out;
	wire [`MEMORY_ADDR_WIDTH-1:0] loader_addr_out;
	wire loader_wea;
	//instr memory out
	wire [`INSTRUCTION_WIDTH-1:0] instruction_memory_read;

//Test Variables
    reg [`WORD_WIDTH-1:0] rx_word_input;
    reg [`INSTRUCTION_WIDTH-1:0] ram [`MEMORY_DEPTH-1:0]  ;
    integer i;
    integer j;
	
	always #`CLK_PERIOD clk = !clk;
	
	initial
	begin
	   $readmemh("out.coe",ram,0);
	   clk =           1'b0;
	   rx =            1'b1;
	   rx_word_input = {`WORD_WIDTH{1'b0}};
	   @(posedge clk) #1;   
	   reset =         1'b1;
       rea = 1'b0;
	   repeat(10)                                  //Resetear y esperar 10 ciclos de reloj
	   @(posedge clk) #1;                   
        reset= 0;
        i = 0;
        j = 0;
        
        //Enviar las intrucciones (out.coe)por bytes al modulo rx para cargarlas en memoria de instruccion
        while(rx_word_input == rx_word_input)
        begin
 	       while (j < `INSTRUCTION_WIDTH/`WORD_WIDTH )
            begin 
	          rx_word_input = ( ram[i] >> (j*`WORD_WIDTH) );
	          if(rx_word_input == rx_word_input)
	          send(rx_word_input);
	          repeat(20)
	          @(posedge tick) #1;
	          j = j + 1;
            end
            i = i + 1;
            j = 0;
	      end
   
/*	   repeat(10)                          //Resetear modulo
	   @(posedge clk) #1;
	   reset = 1'b1 ;
	   
	   repeat(10)
	   @(posedge clk) #1;
	   reset = 1'b0;*/
	   
	   repeat(10)
	   @(posedge clk) #1;
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
	Rx
	#(
	   .WORD_WIDTH(`WORD_WIDTH),
	   .STOP_BIT_COUNT(`STOP_BIT_COUNT)
	)
	uut2
	(
		.clk(clk), 
		.tick(tick),
		.rx(rx),
		.reset(reset), 
		.rx_out(rx_out),
		.rx_done(rx_done)
    );
    
    Instruction_loader
	#(
	   .INSTRUCTION_WIDTH(`INSTRUCTION_WIDTH),
	   .MEMORY_DEPTH(`MEMORY_DEPTH)
	)
	uut3
	(
		.clk(clk), 
		.reset(reset), 
		.rx_out(rx_out),
		.rx_done(rx_done),
		.loader_inst_out(loader_inst_out),
		.loader_addr_out(loader_addr_out),
		.loader_wea(loader_wea)
    );
    
    //Module under test Instantiation
	Memory
	#(
	   .memory_depth(`MEMORY_DEPTH),
	   .memory_width(`INSTRUCTION_WIDTH)
	)
	uut4
	(
		.clk(clk), 
		.reset(reset), 
		.wea(loader_wea),                         //to write instruction  
		.write_data(loader_inst_out),     
		.write_addr(loader_addr_out),
	 	.rea(rea),                               //to read instruction
	 	.read_data(instruction_memory_read)
    );

    task send;
	input [`WORD_WIDTH-1:0]data;
	integer i;
	begin
		   rx_word_input = data ;
		   rx= 1'b0;//start bit
		   repeat(16)
		   @(posedge tick) #1;
	   for (i = 0 ; i < `WORD_WIDTH ;i = i + 1)
	       begin 
	          rx = rx_word_input[i];
	          repeat(16)
	          @(posedge tick) #1;
	      end
	       rx= 1'b1;//stop bit
	       repeat(`STOP_BIT_COUNT*16)
		   @(posedge tick) #1;
	end
	endtask    
     
endmodule   	
