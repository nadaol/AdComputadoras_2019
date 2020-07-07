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

`define INST_MEMORY_ADDR_WIDTH $clog2(`INST_MEMORY_WIDTH)

module Pc
#(
  parameter PC_CANT_BITS = `INST_MEMORY_ADDR_WIDTH,  // Cantidad de bits del PC (Instruction memory addr width)
  parameter SUM_DIR = 1         // Cantidad a sumar al PC para obtener la direccion siguiente.
)

(
  input i_clock,
  input i_reset,
  input i_wrPC,
  output [PC_CANT_BITS-1:0] o_addr
);

  reg [PC_CANT_BITS-1:0] reg_PC;




  always @(negedge i_clock) begin// actualizacion del pc por flanco de bajada
    if (~i_reset) begin
      reg_PC <= 0;

    end
    else begin

      if (i_wrPC) begin  
        reg_PC <= reg_PC + SUM_DIR;
      end
      else begin
        reg_PC <= reg_PC;
      end
    end
 end
    assign o_addr = reg_PC;

endmodule
