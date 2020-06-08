`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2019 03:38:41 PM
// Design Name: 
// Module Name: IO_sim1
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


module IO_sim1;

localparam DATA_LENGTH = 8;
// Inputs
	reg btn_A;
	reg btn_B;
	reg btn_Op;
	reg clk;
	reg signed [(DATA_LENGTH-1):0] dato;
// Outputs
	wire [(DATA_LENGTH-1):0] Resultado;

// Instancio el módulo a testear
	IO uut (
		.clk(clk),
		.btn_A(btn_A),
		.btn_B(btn_B),
		.btn_Op(btn_Op),
		.switches(dato),
		.Leds(Resultado)
	);
	
integer i = 0;
	initial
	 begin
		dato = 0;
		btn_A=0;
		btn_B = 0;
		btn_Op= 0;
		clk = 0;
		end
always
begin
		#1 clk = !clk;
end

always
begin
for(i=0;i<3;i=i+1)
//Cargo valores random a A y B
        #10
        dato=$random;
		#2;
		btn_A=1;
		#2
		btn_A=0;
		#2
		dato=$random;
		#2;
		btn_B=1;
		#2
		btn_B=0;
		
//Realizo todas las Operaciones
		#10  dato = 6'h20;//ADD
		#10  btn_Op= 1;
		#10  btn_Op = 0;
		
		#10  dato = 6'h22;//SUB
		#10  btn_Op = 1;
		#10  btn_Op = 0;
		
		#10  dato = 6'h24;//AND
		#10  btn_Op = 1;
		#10  btn_Op = 0;
		
		#10  dato = 6'h25;//OR
		#10  btn_Op = 1;
		#10  btn_Op = 0;
		
		#10  dato = 6'h26;//XOR
		#10  btn_Op = 1;
		#10  btn_Op = 0;
		
		#10  dato = 6'h27;//NOR
		#10  btn_Op = 1;
		#10  btn_Op = 0;
		
		#10  dato = 6'h02;//SRA
		#10  btn_Op = 1;
		#10  btn_Op = 0;
		
		#10  dato = 6'h03;//SRL
		#10  btn_Op = 1;
		#10  btn_Op = 0;

	end
    
endmodule