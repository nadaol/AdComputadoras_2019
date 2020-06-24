`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  Oliva Nahuel - Fede Bosack
// 
// Create Date: 11/21/2019 11:15:39 PM
// Design Name: 
// Module Name: test_bench_top_arquitectura
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

`define WIDTH_WORD_TOP          8       // Tamano de palabra.    
`define FREC_CLK_MHZ        100.0       // Frecuencia del clock en MHZ.
`define BAUD_RATE_TOP        19200       // Baud rate.
`define CANT_BIT_STOP_TOP       1       // Cantidad de bits de parada en trama uart.     
`define PC_CANT_BITS           11       // Cantidad de bits del PC.
`define SUM_DIR                 1       // Cantidad a sumar al PC para obtener la direccion siguiente.
`define OPCODE_LENGTH           5       // Cantidad de bits del codigo de operacion.
`define CC_LENGTH              11       //  Cantidad de bits del contador de ciclos.
`define ACC_LENGTH             16       //  Cantidad de bits del acumulador.
`define HALT_OPCODE             0       //  Opcode de la instruccion HALT.
`define OPERANDO_LENGTH        11
`define OPERANDO_FINAL_LENGHT  16
`define RAM_WIDTH_DATOS        16
`define RAM_WIDTH_PROGRAMA     16
`define RAM_PERFORMANCE_DATOS    "LOW_LATENCY"
`define RAM_PERFORMANCE_PROGRAMA "HIGH_PERFORMANCE"
`define INIT_FILE_DATOS        ""
`define INIT_FILE_PROGRAMA     "/home/nadaol/Desktop/Untitled/Src/PROGRAM_DATA.txt"      
`define RAM_DEPTH_DATOS      1024
`define RAM_DEPTH_PROGRAMA   2048     

module test_bench_top();
   
   // Entradas.
   reg clock;                                  // Clock.
   reg hard_reset;                             // Reset.
   reg uart_txd_in_reg;                        // Tx de PC.
      // Salidas.
   wire uart_rxd_out_wire;                     // Rx de PC.
   wire [`ACC_LENGTH - 1 : 0] led;                     // ACC
   
   
   initial    begin
		clock = 1'b0;
		hard_reset = 1'b0; // Reset en 0. (Normal cerrado el boton del reset).
		uart_txd_in_reg = 1'b1;

		#2000 hard_reset = 1'b1; // Desactivo la accion del reset.
		
        
        //bit de inicio
		#52083 uart_txd_in_reg = 1'b0;
		
		//primer dato 00
		#52083 uart_txd_in_reg = 1'b1;
		#52083 uart_txd_in_reg = 1'b1;
		#52083 uart_txd_in_reg = 1'b1;
		#52083 uart_txd_in_reg = 1'b1;
		
		#52083 uart_txd_in_reg = 1'b1;
		#52083 uart_txd_in_reg = 1'b1;
		#52083 uart_txd_in_reg = 1'b1;
		#52083 uart_txd_in_reg = 1'b1;
		
		//bits de stop
		#52083 uart_txd_in_reg = 1'b1;

		#52083 uart_txd_in_reg = 1'b1;

             //bit de inicio
		#52083 uart_txd_in_reg = 1'b0;
		
		//2do dato 40
		#52083 uart_txd_in_reg = 1'b1;
		#52083 uart_txd_in_reg = 1'b1;
		#52083 uart_txd_in_reg = 1'b1;
		#52083 uart_txd_in_reg = 1'b1;
		
		#52083 uart_txd_in_reg = 1'b1;
		#52083 uart_txd_in_reg = 1'b1;
		#52083 uart_txd_in_reg = 1'b1;
		#52083 uart_txd_in_reg = 1'b1;
		
		//bits de stop
		#52083 uart_txd_in_reg = 1'b1;
		
		#52083 uart_txd_in_reg = 1'b1;

		// Test 4: Prueba reset.
		#9000000 hard_reset = 1'b0; // Reset.
		#3000000 hard_reset = 1'b1; // Desactivo el reset.


		#5000000 $finish;
   end
   
   always #5 clock=~clock;  // Simulacion de clock.



//Modulo para pasarle los estimulos del banco de pruebas.
TOP
   #(
       .WIDTH_WORD_TOP  (`WIDTH_WORD_TOP),
       .FREC_CLK_MHZ    (`FREC_CLK_MHZ),
       .BAUD_RATE_TOP   (`BAUD_RATE_TOP),
       .CANT_BIT_STOP_TOP (`CANT_BIT_STOP_TOP),
       .PC_CANT_BITS  (`PC_CANT_BITS),
       .SUM_DIR   (`SUM_DIR),
       .OPCODE_LENGTH  (`OPCODE_LENGTH),
       .CC_LENGTH     (`CC_LENGTH),
       .ACC_LENGTH  (`ACC_LENGTH),
       .HALT_OPCODE     (`HALT_OPCODE),
       .OPERANDO_LENGTH   (`OPERANDO_LENGTH),
       .OPERANDO_FINAL_LENGHT      (`OPERANDO_FINAL_LENGHT),    
       .RAM_WIDTH_DATOS            (`RAM_WIDTH_DATOS),
       .RAM_WIDTH_PROGRAMA         (`RAM_WIDTH_PROGRAMA),
       .RAM_PERFORMANCE_DATOS      (`RAM_PERFORMANCE_DATOS),
       .RAM_PERFORMANCE_PROGRAMA   (`RAM_PERFORMANCE_PROGRAMA),
       .INIT_FILE_DATOS            (`INIT_FILE_DATOS),
       .INIT_FILE_PROGRAMA         (`INIT_FILE_PROGRAMA),  
       .RAM_DEPTH_DATOS            (`RAM_DEPTH_DATOS),
       .RAM_DEPTH_PROGRAMA         (`RAM_DEPTH_PROGRAMA)
    ) 
   top_arquitectura_1
   (
     .i_clock (clock),
     .i_reset (hard_reset),
     .uart_txd_in (uart_txd_in_reg),
     .uart_rxd_out (uart_rxd_out_wire),
     .led(led)
   );
  
endmodule
