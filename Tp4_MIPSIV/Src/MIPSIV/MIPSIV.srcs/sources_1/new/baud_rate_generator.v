 `timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Oliva Nahuel - Fede Bosack
// 
// Create Date: 11/02/2019 04:05:17 PM
// Design Name: 
// Module Name: baud_rate_generator
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


module Baud_rate_generator
#(
// Parametros, valores por defecto
parameter BAUD_RATE    = 19200,
parameter FREC_CLOCK_MHZ  = 100
)
(
    input clk, 
    input reset,
    output reg baud_rate_tick
    );

// Local Param
localparam integer MODULO_CONTADOR = (FREC_CLOCK_MHZ * 1000000) / (BAUD_RATE * 16);

// Registros.
reg [ $clog2 (MODULO_CONTADOR) - 1 : 0 ] reg_contador;


always@( posedge clk) begin
     // Se resetean los registros.
    if (reset) begin
        reg_contador <= 0;
    end 

    else begin
        if (reg_contador < MODULO_CONTADOR) begin
            baud_rate_tick <= 0;
            reg_contador <= reg_contador+1;
        end
        else begin
            baud_rate_tick <= 1;
            reg_contador <= 0;
        end
    end
end

endmodule


