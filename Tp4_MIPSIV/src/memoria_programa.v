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

module memoria_programa
#(
  parameter RAM_WIDTH = 16,                       //ancho de entradas
  parameter RAM_DEPTH = 2048,                     //numero de entradas de la memoria
  parameter RAM_PERFORMANCE = "HIGH_PERFORMANCE", 
  parameter INIT_FILE = ""             // direccion del archivo txt de inicializacion de la memoria
)
(
  input [clogb2(RAM_DEPTH) - 2 : 0] i_addr,   //Bus de direccion
  input i_clk,                            // Clock
  output [RAM_WIDTH - 1 : 0] o_data       //Output para la lectura
);
        
  wire wea = 0 ;                 
  wire [RAM_WIDTH - 1 : 0] dina = 0;  // RAM input data

  reg [RAM_WIDTH - 1 : 0] BRAM [RAM_DEPTH - 1 : 0];
  reg [RAM_WIDTH - 1 : 0] ram_data = {RAM_WIDTH {1'b0}};

  // Inicializacion de la memoria ,en 0's si el archivo es nulo
  generate
    if (INIT_FILE != "") begin: use_init_file
      initial
        $readmemb(INIT_FILE, BRAM, 0, RAM_DEPTH - 1);
    end else begin: init_bram_to_zero
      integer ram_index;
      initial
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
          BRAM[ram_index] = {RAM_WIDTH {1'b0}};
    end
  endgenerate

  always @(posedge i_clk)
      if (wea)
        BRAM [i_addr] <= dina;//si esta en modo escritura se escribe en bram el input data
      else
        ram_data <= BRAM [i_addr];//lectura en flaco descendente para la mem datos

  //  modo HIGH_PERFORMANCE (flanco ascendente) o LOW_LATENCY (flanco descendente)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register


       assign o_data = ram_data;//lectura en flaco descendente para la mem datos

    end else begin: output_register


      reg [RAM_WIDTH - 1 : 0] reg_data_out = {RAM_WIDTH {1'b0}};

      always @(posedge i_clk)
          reg_data_out <= ram_data;     

      assign o_data = reg_data_out;//lectura en flaco ascendente para la mem de programa

    end
  endgenerate

  //funcion para el calculo de la direccion en base a la ram_depth
  function integer clogb2;
    input integer depth;
      for (clogb2 = 0; depth > 0; clogb2 = clogb2+1)
        depth = depth >> 1;
  endfunction

endmodule