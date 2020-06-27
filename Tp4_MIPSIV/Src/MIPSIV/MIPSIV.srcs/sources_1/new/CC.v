 `timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Oliva Nahuel - Fede Bosack
// 
// Create Date: 11/02/2019 06:15:33 PM
// Design Name: 
// Module Name: contador_ciclos
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


module Cc
    #(
        parameter CONTADOR_LENGTH = 11,
        parameter OPCODE_LENGTH =5
    )
    (
        input i_clock, 
        input i_reset,
        input [OPCODE_LENGTH-1:0] i_opcode,//entrada opcode del deco
        output reg [CONTADOR_LENGTH - 1 : 0] o_cuenta   //contador
    );



always@( posedge i_clock) begin
     // Se resetea el contador
    if (i_reset) begin
        o_cuenta <= 0;
    end 
    else if (i_opcode!=0) begin
        o_cuenta <= o_cuenta + 1;
    end
    else begin
        o_cuenta <= o_cuenta;
    end
end

endmodule


