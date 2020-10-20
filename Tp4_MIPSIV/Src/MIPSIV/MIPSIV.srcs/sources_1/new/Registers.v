`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.06.2020 02:23:09
// Design Name: 
// Module Name: Registers
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
`define REGISTERS_ADDRWIDTH $clog2(memory_depth)

//Registros del procesador
module Registers
#(
    parameter registers_width = `REGISTERS_WIDTH,
    parameter memory_depth = `REGISTERS_DEPTH
 )
(
    input clk,reset,
    input control_write,enable,
    input [`REGISTERS_ADDRWIDTH-1:0] read_register1,
    input [`REGISTERS_ADDRWIDTH-1:0] read_register2,
    input [`REGISTERS_ADDRWIDTH-1:0] write_register,
    input [registers_width-1:0] write_data,
    output reg [registers_width-1:0] read_data1,
    output reg [registers_width-1:0] read_data2
 );
 
 reg [memory_depth-1:0] registers [registers_width-1:0] ;          
 
	always @(negedge clk)  // Write&Read Same clock edge
	begin
	
		if (reset)
		begin
            reset_all();
		end
		
		if(enable)
	    begin
                if (control_write)  //Write data to register
		          begin
			         registers[write_register] <= write_data;
		          end
		      if(write_register == read_register1) //If read address (read1 or read2) is the write addr ,forward write data(to avoid Wb instr dependencies)
		          begin
		              read_data1<=write_data;
		              read_data2 <= registers[read_register2];
		          end
		      else if(write_register == read_register2)
		          begin
		              read_data1 <= registers[read_register1];  
		              read_data2<=write_data;
		          end                                           // Else read corresponding register
		          else
		               begin
		                  read_data1 <= registers[read_register1];
		                  read_data2 <= registers[read_register2];
		               end
		  end
		  
	   else // Memory disabled
	   begin
	       read_data1 <= read_data1;
		   read_data2<=read_data2;
	   end
	   
	end
	
task reset_all;
    begin : resetall
    integer row ;
        for (row = 0 ; row < memory_depth ; row = row + 1)
            registers[row] <= {registers_width{1'b0}} ;
    read_data1 <= {registers_width{1'b0}};
    read_data2 <= {registers_width{1'b0}};
    end
endtask
 
endmodule
