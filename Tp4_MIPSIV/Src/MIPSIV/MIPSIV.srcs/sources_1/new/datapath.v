`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Oliva Nahuel - Fede Bosack
// 
// Create Date: 11/02/2019 07:11:41 PM
// Design Name: 
// Module Name: datapath
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

module Datapath
#(
  parameter OPERANDO_LENGTH = 11,         // Cantidad de bits del operando.
  parameter OPERANDO_FINAL_LENGHT = 16,   // Cantidad de bits del operando con extension 
  parameter OPCODE_LENGTH = 5             // Cantidad de bits del opcode.
)

(
  input i_clock,
  input i_reset,
  input [2-1:0] i_selA,//inputs obtenidos del decodif de instr's
  input i_selB,
  input i_wrACC,
  input [OPCODE_LENGTH - 1 : 0] i_opcode,//inputs obtenidos de la mem de progr
  input [OPERANDO_LENGTH - 1 : 0] i_operando,
  input [OPERANDO_FINAL_LENGHT - 1 : 0] i_outmemdata,//para lectura a memoria de datos
  output [OPERANDO_LENGTH - 1 : 0] o_addr,//para escritura a mem de datos
  output [OPERANDO_FINAL_LENGHT - 1 : 0] o_ACC  //registro acumulador
);


  // Registros.

  reg [OPERANDO_FINAL_LENGHT - 1 : 0] reg_ACC;
  reg signed [OPERANDO_FINAL_LENGHT - 1 : 0] reg_signo_extendido;
  reg signed [OPERANDO_FINAL_LENGHT - 1 : 0] reg_out_muxA;
  reg signed [OPERANDO_FINAL_LENGHT - 1 : 0] reg_out_muxB;
  reg signed [OPERANDO_FINAL_LENGHT - 1 : 0] reg_out_ALU;



  always @(posedge i_clock) begin
    if (i_reset) begin // Se resetean los registros.
      reg_ACC <= 0;
    end
    else begin
      if (i_wrACC) begin 
            reg_ACC <= reg_out_muxA;
      end
      else begin
            reg_ACC <= reg_ACC;
      end
    end
  end

  always @(*) begin // Extension 
      reg_signo_extendido = {{5 {i_operando [OPERANDO_LENGTH - 1]}},i_operando}; 
  end

  always @(*) begin // defino salida del muxA al ACC
    case (i_selA) 
      2'b00 : begin
        reg_out_muxA = i_outmemdata;
      end
      2'b01 : begin
        reg_out_muxA = reg_signo_extendido;
      end
      2'b10 : begin
        reg_out_muxA = reg_out_ALU;
      end
      default begin
          reg_out_muxA = 0;
        end
    endcase
  end

  always @(*) begin // defino salida del muxB al segundo operando de la alu 
    case (i_selB)
      1'b0 : begin
        reg_out_muxB = i_outmemdata;
      end
      1'b1 : begin
        reg_out_muxB = reg_signo_extendido;
      end
    endcase
  end


  always@(*) begin  
  // defino operacion aritmetica (ALU)

      case (i_opcode) 

          //ADD
          5'b00100 : begin
              reg_out_ALU = reg_ACC + reg_out_muxB;
          end
          5'b00101 : begin
              reg_out_ALU = reg_ACC + reg_out_muxB;
          end

            //SUB
            5'b00110 : begin
              reg_out_ALU = reg_ACC - reg_out_muxB;
            end
            5'b00111 : begin
              reg_out_ALU = reg_ACC - reg_out_muxB;
            end


          default : begin
              reg_out_ALU = reg_ACC;
          end

      endcase

  end

  assign o_ACC = reg_ACC;
  assign o_addr = i_operando;

endmodule
