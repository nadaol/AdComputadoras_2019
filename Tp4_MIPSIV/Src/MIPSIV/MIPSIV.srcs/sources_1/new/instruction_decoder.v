`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Oliva Nahuel - Fede Bosack
// 
// Create Date: 11/02/2019 05:09:24 PM
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

module Instruction_decoder
#(
  parameter OPCODE_LENGTH = 5   
)

(
  input [OPCODE_LENGTH - 1 : 0] i_opcode,//opcode leido de la mem de programa
  output reg o_wrPC,                    //variables de control para el direccionamiento de señales en el datapath
  output reg o_wrACC,
  output reg [1 : 0] o_selA,
  output reg o_selB,
  output reg [OPCODE_LENGTH - 1 : 0] o_opcode,
  output reg o_wrRAM,
  output reg o_rdRAM
);


  always @(*) begin
    case (i_opcode)

      5'b00000 : begin //inst halt
        o_wrPC = 0;//detengo el program counter
        o_wrACC = 0;//desactivo escritura al registro acc
        o_selA = 0;//no se cambia el reg acc
        o_selB = 0;
        o_opcode = i_opcode;
        o_wrRAM = 0;//no se usa mem de datos
        o_rdRAM = 0;
      end

      5'b00001 : begin //inst store variable
        o_wrPC = 1;//Pc incrementa enable
        o_wrACC = 0;//escritura al registro acc disabled
        o_selA = 0;//no se cambia el reg acc
        o_selB = 0;//no se utiliza la salida de la alu
        o_opcode = i_opcode;
        o_wrRAM = 1;//se escribe en ram de mem de datos
        o_rdRAM = 0;
      end

      5'b00010 : begin //inst load variable
        o_wrPC = 1;//Pc incrementa enable
        o_wrACC = 1;//escribo al registro acc
        o_selA = 0;//escribo al ACC Dato en memoria de datos en la dir especif en la instruccion
        o_selB = 0;//no se utiliza la salida de la alu
        o_opcode = i_opcode;
        o_wrRAM = 0;
        o_rdRAM = 1;//leo de la mem de datos
      end

      5'b00011 : begin //inst load inmidiate
        o_wrPC = 1;//Pc incrementa enable
        o_wrACC = 1;//escribo al registro acc
        o_selA = 1;//escribo al ACC el operando de la mem de programa(instruccion actual)
        o_selB = 0;//no se utiliza la salida de la alu
        o_opcode = i_opcode;
        o_wrRAM = 0;//no se usa mem de datos
        o_rdRAM = 0;
      end

      5'b00100 : begin //inst add variable
        o_wrPC = 1;//Pc incrementa enable
        o_wrACC = 1;//escribo al registro acc
        o_selA = 2;//escribo al ACC la salida de la alu
        o_selB = 0;//2do operando de la alu > salida mem de datos
        o_opcode = i_opcode;//op code suma
        o_wrRAM = 0;
        o_rdRAM = 1;//leo el dato de la mem de datos
      end

      5'b00101 : begin //inst add inmidiate
        o_wrPC = 1;//Pc incrementa enable
        o_wrACC = 1;//escribo al registro acc
        o_selA = 2;//escribo al ACC la salida de la alu
        o_selB = 1;//2do operando de la alu > operando de la mem de programa(instruccion actual)
        o_opcode = i_opcode;
        o_wrRAM = 0;//no se usa mem de datos
        o_rdRAM = 0;
      end

      5'b00110 : begin //inst sub variable
        o_wrPC = 1;//Pc incrementa enable
        o_wrACC = 1;//escribo al registro acc
        o_selA = 2;//escribo al ACC la salida de la alu
        o_selB = 0;//2do operando de la alu > salida mem de datos
        o_opcode = i_opcode;
        o_wrRAM = 0;
        o_rdRAM = 1;//leo de la mem de datos
      end

      5'b00111 : begin //inst sub inmidiate
        o_wrPC = 1;//Pc incrementa enable
        o_wrACC = 1;//escribo al registro acc
        o_selA = 2;//escribo al ACC la salida de la alu
        o_selB = 1;//2do operando de la alu > operando de la mem de programa(instruccion actual)
        o_opcode = i_opcode;
        o_wrRAM = 0;//no se usa mem de datos
        o_rdRAM = 0;
      end

      default begin
        o_wrPC = 0;
        o_wrACC = 0;
        o_selA = 0;
        o_selB = 0;
        o_opcode = i_opcode;
        o_wrRAM = 0;
        o_rdRAM = 0;
      end

    endcase
  end

endmodule
