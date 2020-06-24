 `timescale 1ns / 100ps

module test_bench_interface();
		
	// Parametros
    parameter CANT_BITS_OPCODE = 5;      //  Cantidad de bits del opcode.
    parameter CC_LENGTH = 11;            //  Cantidad de bits del contador de ciclos.
    parameter ACC_LENGTH = 16;           //  Cantidad de bits del acumulador.
    parameter OUTPUT_WORD_LENGTH = 8;    //  Cantidad de bits de la palabra a transmitir.
    parameter HALT_OPCODE = 0;            //  Opcode de la instruccion HALT.
	
	
	// Entradas.
    reg reg_reset;
	reg [CANT_BITS_OPCODE - 1 : 0] reg_i_opcode;
	
	reg reg_rx_done;                     
	reg reg_clock;
	 reg [OUTPUT_WORD_LENGTH - 1 : 0] i_data;                      
    
	// Salidas.
	wire wire_soft_reset;
	
	
	initial	begin
		reg_clock = 1'b0;
		reg_reset = 1'b0; // Reset en 0. (Normal cerrado el boton del reset).
		reg_i_opcode = 1'b1;
		reg_rx_done = 1'b0;
		#10 reg_reset = 1'b1; // Desactivo la accion del reset.
		
		i_data = 8'hff;
		#10 reg_rx_done = 1'b1;//mando los dos codigos de start
        #10 reg_rx_done = 1'b0;
        		#10 reg_rx_done = 1'b1;//mando los dos codigos de start
        #10 reg_rx_done = 1'b0;

		//reseteo el sistema 
		#40 reg_reset = 1'b0;
		#40 reg_reset = 1'b1; 

		#1000000 $finish;
	end
	
	always #2.5 reg_clock = ~reg_clock;


interface
    #(
         .CANT_BITS_OPCODE (CANT_BITS_OPCODE),
         .CC_LENGTH (CC_LENGTH),
		 .ACC_LENGTH (ACC_LENGTH),
		 .OUTPUT_WORD_LENGTH (OUTPUT_WORD_LENGTH),
		 .HALT_OPCODE (HALT_OPCODE)
     ) 
    uut  
    (
      	.i_clock (reg_clock),
      	.i_reset (reg_reset),
      	.i_rx_done (reg_rx_done),
        .i_opcode(reg_i_opcode),
        .i_data_rx(i_data),
		.o_soft_reset (wire_soft_reset)
    );
   
endmodule

 
