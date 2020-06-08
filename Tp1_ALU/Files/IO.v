`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2019 12:40:40 AM
// Design Name: 
// Module Name: main
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


module IO#(parameter DATA_LENGTH=8)
		     (input wire [(DATA_LENGTH-1):0] switches, 
				input wire btn_A, btn_B, btn_Op, clk, reset,
				output wire [(DATA_LENGTH-1):0] Leds
    );
	 
	reg [(DATA_LENGTH-1):0] A;
	reg [(DATA_LENGTH-1):0] B;
	reg [5:0] Op_code;
	

	Alu #(.DATA_LENGTH(DATA_LENGTH)) Alu(.A(A),.B(B),.Op_code(Op_code),.Resultado(Leds));
	
	always @(posedge clk)
	
	begin
		if(reset==1)
		begin
		A<=0;
		B<=0;
		Op_code<=6'b000000;
		end	

case({btn_A,btn_B,btn_Op})
			3'b100: A<=switches;//Cargo Operando A
			3'b010: B<=switches;//Cargo Operando B
			3'b001: Op_code<=switches[5:0];//Cargo codigo de operacion
	endcase
	end
endmodule
