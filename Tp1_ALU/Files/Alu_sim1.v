`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2019 09:59:23 AM
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

module Alu_sim1;

//local parameters
localparam DATA_LENGTH = 8;
// Inputs
	reg [5:0] Op;
	reg signed [(DATA_LENGTH-1):0] A;
	reg signed [(DATA_LENGTH-1):0] B;
// Outputs
	wire [(DATA_LENGTH-1):0] Resultado;

// Instancio el módulo a testear
	Alu #(.DATA_LENGTH(DATA_LENGTH))
	uut (
		.Op_code(Op),
		.A(A),
		.B(B),
		.Resultado(Resultado)
	);
integer i=0;
	reg signed [(DATA_LENGTH-1):0]res;
	reg assert;
	
	initial begin
// Inicializacion de registros
		Op = 0;
		A = 0;
		B = 0;
		i=0;
		res=0;
		assert=0;
end

always 
begin
for(i=0;i<3;i=i+1)

//Cargo valores random a A y B
        #10;
		A=$random;
		#2;
		B=$random;
		#2;
		
		Op=6'b100000; //ADD
		#10;
		res=A+B;if(res==Resultado)assert=1;else assert=0;
		#10;
		Op=6'b100010; //SUB
		#10;
		res=A-B;if(res==Resultado)assert=1;else assert=0;
		#10;
		Op=6'b100100; //AND
		#10;
		res=A&B;if(res==Resultado)assert=1;else assert=0;
		#10;
		Op=6'b100101; //OR
		#10;
		res=A|B;if(res==Resultado)assert=1;else assert=0;
		#10;
		Op=6'b100110; //XOR
		#10;
		res=A^B;if(res==Resultado)assert=1;else assert=0;
		#10;
		Op=6'b000011; //SRA
		#10;
		res=A>>>B;if(res==Resultado)assert=1;else assert=0;
		#10;
		Op=6'b000010; //SRL
		#10;
		res=A>>B;if(res==Resultado)assert=1;else assert=0;
		#10;
		Op=6'b100111; //NOR
		#10;
		res=~(A|B);if(res==Resultado)assert=1;else assert=0;
		#10;
		Op=6'b111111; //UNDEFINED
		#10;
		res=0;if(res==Resultado)assert=1;else assert=0;
		#10;

	end
      
endmodule