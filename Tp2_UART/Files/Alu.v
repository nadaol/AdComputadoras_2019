`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:53:29 09/28/2019 
// Design Name: 
// Module Name:    Alu 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Alu#(parameter DATA_LENGTH=8)
			 (
			 input signed [(DATA_LENGTH-1):0] A,
			 input signed [(DATA_LENGTH-1):0] B,
			 input [DATA_LENGTH-1:0] Op_code,
			 output reg signed [(DATA_LENGTH-1):0] Resultado_reg
			  );

	always @(*)
	begin
		case(Op_code)
			6'b00100000: Resultado_reg=A+B;//ADD
			6'b00100010: Resultado_reg=A-B;//SUB
			6'b00100100: Resultado_reg=A&B;//AND
			6'b00100101: Resultado_reg=A|B;//OR
			6'b00100110: Resultado_reg=A^B;//XOR
			6'b00000011: Resultado_reg=A>>>B;//SRA
			6'b00000010: Resultado_reg=A>>B;//SRL
			6'b00100111: Resultado_reg=~(A|B);//NOR
			default: Resultado_reg={(DATA_LENGTH){1'b0}};
		endcase
	end
	
endmodule