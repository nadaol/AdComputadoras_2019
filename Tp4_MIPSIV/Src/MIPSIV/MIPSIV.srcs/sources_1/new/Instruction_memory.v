`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Oliva Nahuel - Fede Bosack
// 
// Create Date: 11/02/2019 09:14:44 PM
// Design Name: 
// Module Name: memoria_programa
// Project Name: BIPI
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
`define DATA_ADDRWIDTH $clog2(memory_depth)

//Memoria de programa del procesador
module Instruction_memory
#(
  parameter memory_width = 32,                       //Ancho de entradas,(instruction_width)
  parameter memory_depth = 2048                     //Numero de entradas de la memoria
)
(
  input [`DATA_ADDRWIDTH - 1 : 0] loader_addr,                  //Bus de direccion para escritura
  input [`DATA_ADDRWIDTH - 1 : 0] pc_addr,                       //Bus de direccion para lectura
  input [memory_width - 1 : 0] instruction_memory_in,           //Input para la escritura
  input clk,reset,wea,                                         // Clock
  output reg [memory_width - 1 : 0] instruction_memory_out    //Output para la lectura
);               

  reg [memory_width - 1 : 0] ram_data [memory_depth - 1 : 0] ;
  
  always @(posedge clk)
  begin
		if (reset)
		  reset_all();
        else if (wea)
         ram_data [loader_addr] <= instruction_memory_in;//si esta en modo escritura se escribe en ram el input data
        else if((pc_addr == pc_addr))//check z , x inputs
        instruction_memory_out <= ram_data[pc_addr];
        else
        instruction_memory_out <= {memory_width{1'b0}};
  end


task reset_all;
    begin : resetall
    integer row ;
        for (row = 0 ; row < memory_depth ; row = row + 1)
            ram_data[row] <= {memory_width{1'b0}} ;
    instruction_memory_out <= {memory_width{1'b0}};
    end
endtask

endmodule