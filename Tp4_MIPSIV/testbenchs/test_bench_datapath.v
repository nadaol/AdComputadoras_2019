 `timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Oliva Nahuel - Fede Bosack
// 
// Create Date: 11/21/2019 12:58:55 PM
// Design Name: 
// Module Name: test_bench_address_calculator
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

module test_bench_datapath();
	
	parameter OPERANDO_LENGTH = 11;         // Cantidad de bits del operando.
  	parameter OPERANDO_FINAL_LENGHT = 16;   // Cantidad de bits del operando con extension de signo.
  	parameter OPCODE_LENGTH = 5;             // Cantidad de bits del opcode.


	// Entradas.
    reg reg_reset;
	reg reg_clock;
	reg [1 : 0] reg_selA;
	reg reg_selB;
	reg reg_wrACC;
	reg [OPCODE_LENGTH - 1 : 0] reg_i_opcode;
	reg [OPERANDO_LENGTH - 1 : 0] reg_operando;
	reg [OPERANDO_FINAL_LENGHT - 1 : 0] reg_dato_mem;                      
    
	// Salidas.
	wire [OPERANDO_LENGTH - 1 : 0] wire_addr_mem_datos;
	wire [OPERANDO_FINAL_LENGHT - 1 : 0] wire_valor_ACC;
	
	
	initial	begin
		reg_clock = 1'b0;
		reg_reset = 1'b0; 

		reg_dato_mem = 2;
		reg_operando = 5;
		reg_reset = 1'b1; // comienzo el PC.
		
        reg_wrACC = 1;//escribo al registro acc
        reg_selA = 0;//entrada al ACC <- dato en mem 
        reg_selB = 0;//segundo operando alu <- dato en mem 
         reg_i_opcode = 2; //Load variable. (2)
        #5
        
        reg_wrACC = 1;//escribo al registro acc
        reg_selA = 2;//escribo al ACC la salida de la alu
        reg_selB = 0;//2do operando de la alu > salida mem de datos
        reg_i_opcode = 4; //Add variable. (2)
        #5 
        
        reg_wrACC = 1;//escribo al registro acc
        reg_selA = 2;//escribo al ACC la salida de la alu
        reg_selB = 1;//2do operando de la alu > salida mem de datos
        reg_i_opcode = 5; //Add inmidiate
        #5
        
        reg_wrACC = 1;//escribo al registro acc
        reg_selA =2;//escribo al ACC la salida de la alu
        reg_selB = 0;//2do operando de la alu > salida mem de datos
        reg_i_opcode = 6; //Sub variable
        #5
        
        reg_wrACC = 1;//escribo al registro acc
        reg_selA = 2;//escribo al ACC la salida de la alu
        reg_selB = 1;//2do operando de la alu > salida mem de datos
        reg_i_opcode = 5; //Add inmidiate
        #5
        
        reg_wrACC = 1;//escribo al registro acc
        reg_selA = 0;//entrada al ACC <- dato en mem 
        reg_selB = 0;//segundo operando alu <- dato en mem 
         reg_i_opcode = 2; //Load variable. (2)
        #10
        
	       reg_reset = 1'b0; // Reset.
		#50 reg_reset = 1'b1; // Desactivo el reset.

		#1000000 $finish;
	end
	
	always #2.5 reg_clock = ~reg_clock;  // Simulacion de clock.



//Modulo para pasarle los estimulos del banco de pruebas.
datapath
   #(
	   .OPCODE_LENGTH (OPCODE_LENGTH),
	   .OPERANDO_LENGTH (OPERANDO_LENGTH),
	   .OPERANDO_FINAL_LENGHT (OPERANDO_FINAL_LENGHT)
    )
    datapath1
    (
        .i_clock (reg_clock),
        .i_reset (reg_reset),
        .i_selA (reg_selA),
        .i_selB (reg_selB),
        .i_wrACC (reg_wrACC),
        .i_opcode (reg_i_opcode),
        .i_operando (reg_operando),
        .i_outmemdata (reg_dato_mem),
        .o_addr (wire_addr_mem_datos),
        .o_ACC (wire_valor_ACC)            
    );
   
endmodule

 
