`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Oliva Nahuel - Fede Bosack
// 
// Create Date: 11/02/2019 05:03:11 PM
// Design Name: 
// Module Name: control
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

module Control 
    #(
        parameter PC_CANT_BITS = 11,  // Cantidad de bits del PC.
        parameter SUM_DIR = 1,         // Cantidad a sumar al PC para obtener la direccion siguiente.
        parameter OPCODE_LENGTH = 5   // Cantidad de bits del codigo de operacion
    )
    (
        input i_clock,
        input i_soft_reset,
        input [OPCODE_LENGTH - 1 : 0] i_mem_data_opcode,
        output [PC_CANT_BITS - 1 : 0] o_addr_mem,
        output [1 : 0] o_selA,
        output o_selB,
        output o_wrAcc,
        output [OPCODE_LENGTH - 1 : 0] o_opCode,
        output o_wr_rd_mem
    );

    wire wire_wrPC;
    wire wire_rd_mem;
    wire wire_wr_mem;
    assign o_wr_rd_mem = (wire_rd_mem & 1'b0) | wire_wr_mem;

    Pc
    #(
         .PC_CANT_BITS (PC_CANT_BITS),
         .SUM_DIR (SUM_DIR)
     ) 
   PC1   
   (
   .i_clock (i_clock),
   .i_reset (i_soft_reset),
   .i_wrPC (wire_wrPC),
   .o_addr (o_addr_mem)
   );


   Instruction_decoder
   #(
       .OPCODE_LENGTH (OPCODE_LENGTH)
   )
   instruction_decoder1
   (
        .i_opcode (i_mem_data_opcode),
        .o_wrPC (wire_wrPC),
        .o_wrACC (o_wrAcc),
        .o_selA (o_selA),
        .o_selB (o_selB),
        .o_opcode (o_opCode),
        .o_wrRAM (wire_wr_mem),
        .o_rdRAM (wire_rd_mem)
   );


endmodule