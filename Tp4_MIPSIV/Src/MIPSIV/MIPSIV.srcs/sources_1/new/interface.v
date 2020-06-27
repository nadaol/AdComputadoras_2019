`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Oliva Nahuel - Fede Bosack
// 
// Create Date: 11/02/2019 04:04:45 PM
// Design Name: 
// Module Name: interface_circuit
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

module Interface
 #(
   parameter CANT_BITS_OPCODE = 5,      //  Cantidad de bits del opcode.
   parameter CC_LENGTH = 11,            //  Cantidad de bits del contador de ciclos.
   parameter ACC_LENGTH = 16,           //  Cantidad de bits del acumulador.
   parameter OUTPUT_WORD_LENGTH = 8   //  Cantidad de bits de la palabra a transmitir.
 )
 (
   input i_clock,
   input i_reset,                                       // HW reset
   input i_rx_done,                            
   input [CANT_BITS_OPCODE - 1 : 0] i_opcode,
   input [OUTPUT_WORD_LENGTH - 1 : 0] i_data_rx,        //datos recibidos (start) 
   output reg o_soft_reset                          //conexion del reset para el resto de los modulos
  );

//output reg o_prueba;

// Registros.
reg [ 5 : 0 ] reg_state;
reg [ 5 : 0 ] reg_next_state;


reg [1 : 0] reg_start_counter;   
reg [1 : 0] reg_next_start_counter;
reg registro_rx_done;


always@( posedge i_clock ) begin //Memory
   // Se resetean los registros.
  if (i_reset) begin
      reg_state <= 1;
      registro_rx_done <= 0;
      reg_start_counter <= 0;
      o_soft_reset <= 0; 
  end

  else begin
      registro_rx_done <= i_rx_done;
      reg_state <= reg_next_state;
      reg_start_counter <= reg_next_start_counter;
      if (reg_start_counter < 2'b10) begin
        o_soft_reset <= 0; 
      end
      else begin 
        o_soft_reset <= 1;//al detectar señal de start comienza a contar el PC 
      end
  end
end


always@(*) begin 
    if (~i_rx_done & registro_rx_done) begin  //al recibir un dato
        if (((reg_start_counter == 0) && //detecto señal de START ff ff
            (i_data_rx == 8'hff)) ||
            ((reg_start_counter == 1) && 
            (i_data_rx == 8'hff))) begin  
            
            reg_next_start_counter = reg_start_counter + 1;
        
        end
        else begin
            reg_next_start_counter = reg_start_counter;
        end
    end    
    else begin
        reg_next_start_counter = reg_start_counter;
    end
end


endmodule
