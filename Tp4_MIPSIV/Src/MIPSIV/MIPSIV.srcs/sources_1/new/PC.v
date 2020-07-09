`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Oliva Nahuel - Fede Bosack
// 
// Create Date: 11/02/2019 05:37:22 PM
// Design Name: 
// Module Name: top_arquitectura
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

`define INST_MEMORY_ADDR_WIDTH $clog2(`INST_MEMORY_DEPTH)

module Pc
#(
  parameter PC_CANT_BITS = `INST_MEMORY_ADDR_WIDTH  // Cantidad de bits del PC (Instruction memory addr width)
)

(
  input clk,
  input reset,
  input enable,
  input [PC_CANT_BITS-1:0] i_addr,
  output reg [PC_CANT_BITS-1:0] o_addr
);

  always @(posedge clk) 
  begin
    if (reset) begin
      o_addr <= 0;

    end
    else if (enable)
    begin
    o_addr <= i_addr;
    end
    else
    o_addr <= o_addr;
   end
   
endmodule
