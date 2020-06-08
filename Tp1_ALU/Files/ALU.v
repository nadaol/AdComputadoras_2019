// Design Name: 
// Module Name: Alu
// Project Name: 
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

/*
ALU 
|Op_Code     |   Operation
| 000011(03H)|   Aritmethic Rigth shift
| 000010(02H)|   Logic Rigth shift;
| 100000(20H)|   ADD
| 100010(22H)|   SUB
| 100100(24H)|   AND
| 100101(25H)|   OR
| 100110(26H)|   XOR
| 100111(27H)|   NOR
| Other      |   0
*/

module Alu#(parameter DATA_LENGTH=8)
			 (
			 input wire signed [(DATA_LENGTH-1):0] A,
			 input wire signed [(DATA_LENGTH-1):0] B,
			  input wire [5:0] Op_code,
			  output reg signed [(DATA_LENGTH-1):0] Resultado
			  );

	always @(*)
	begin
		case(Op_code)
			6'b100000: Resultado=A+B;//ADD
			6'b100010: Resultado=A-B;//SUB
			6'b100100: Resultado=A&B;//AND
			6'b100101: Resultado=A|B;//OR
			6'b100110: Resultado=A^B;//XOR
			6'b000011: Resultado=A>>>B;//SRA
			6'b000010: Resultado=A>>B;//SRL
			6'b100111: Resultado=~(A|B);//NOR
			default: Resultado={(DATA_LENGTH){1'b0}};
		endcase
	end
	
endmodule