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
`include "Parameters.vh"
`define ADDRWIDTH $clog2(memory_depth)

//Memoria de programa del procesador (first write at negedge then read/reset)
module Memory
#(
  parameter memory_width = `INST_MEMORY_WIDTH,                       //Ancho de entradas,(instruction_width)
  parameter memory_depth = `INST_MEMORY_DEPTH,                     //Numero de entradas de la memoria
  parameter init_value  = 'b0
)
(
  input [`ADDRWIDTH - 1 : 0] write_addr,                  //Bus de direccion para escritura
  input [`ADDRWIDTH - 1 : 0] read_addr,                       //Bus de direccion para lectura
  input [memory_width - 1 : 0] write_data,           //Input para la escritura
  input clk,reset,wea,rea,                                         // Clock,reset,write/read enable
  output reg [memory_width - 1 : 0] read_data    //Output para la lectura
);
//

  reg [memory_width - 1 : 0] ram_data [memory_depth - 1 : 0] ;//Memoria
 /* 
 always @(posedge clk) // posedge
    begin
         if (wea && !reset)
         begin
         if((write_addr == write_addr) && write_data == write_data)//check z, x inputs
            ram_data [write_addr] <= write_data;//write data
         end
         else
            read_data <= read_data;
    end
  */
  
  always @(negedge clk)
  begin
  
    begin 
        if (wea && !reset)
            begin
                if((write_addr == write_addr) && write_data == write_data)//check z, x inputs
                    ram_data [write_addr] <= write_data;//write previous instruction (Wb instruction) data
            end
        else
            read_data <= read_data;
    end
  
		if (reset)
		  reset_all();
	    else if (rea)
		begin
            if((read_addr == read_addr) && (ram_data[read_addr] == ram_data[read_addr]))//check z , x inputs
                begin
                    if(wea && ((write_addr == write_addr) && write_data == write_data))
                        read_data <= write_data;//read data (Mem stage instruction)
                    else
                        read_data <= ram_data[read_addr];//read data
                end
                
        end
        else
            read_data <= read_data;
  end

task reset_all;
    begin : resetall
    integer row ;
        for (row = 0 ; row < memory_depth ; row = row + 1)
            ram_data[row] <= {init_value} ;
    read_data <= {init_value};
    end
endtask

endmodule