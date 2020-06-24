 

`timescale 1ns / 100ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Oliva Nahuel - Fede Bosack
// 
// Create Date: 11/21/2019 13:19:31 PM
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
module test_bench_Data_memory();
       
   // Parametros
   parameter RAM_WIDTH = 16;                       // Specify RAM data width
   parameter RAM_DEPTH = 1024;                     // Specify RAM depth (number of entries)
   parameter RAM_PERFORMANCE = "LOW_LATENCY";      // Select "HIGH_PERFORMANCE" or "LOW_LATENCY"
   parameter INIT_FILE = "";                        // Specify name/location of RAM initialization file if using one (leave blank if not)
   
   //Todo puerto de salida del modulo es un cable.
   //Todo puerto de estimulo o generacion de entrada es un registro.
   
   // Entradas.
   reg clock;                                  // Clock.
   reg [11-1:0] reg_i_addr;
   reg [RAM_WIDTH-1:0] data_in;                                 
   reg reg_wea;
   //reg reg_regcea; 
   wire [RAM_WIDTH-1:0] wire_o_data;
   
   
   
   initial    begin
       
       clock = 1'b0;
       reg_i_addr = 11'b0000000;  //escribo 16 en dir0   
        data_in = 8'b00001111;
       reg_wea = 1'b1;
       #5 
       
       data_in = 8'b00000101; //escribo 5 en dir0
       reg_wea = 1'b1;
       #5  
       
       reg_i_addr = 11'b0000001; //escribo 2 en dir1
       data_in = 8'b00000010; 
       reg_wea = 1'b1; 
       #5 
       
       reg_wea = 0'b0;
       reg_i_addr = 11'b0000000; // Lectura de la dir0 
       #5
       reg_i_addr = 11'b0000001; // Lectura de la dir1   
       #5    
       
       #500000 $finish;
   end
   
   always #2.5 clock=~clock;  // Simulacion de clock.
   


// Modulo para pasarle los estimulos del banco de pruebas.
Data_memory
   #(
        .RAM_WIDTH (RAM_WIDTH),
        .RAM_PERFORMANCE (RAM_PERFORMANCE),
        //.INIT_FILE (INIT_FILE),
        .RAM_DEPTH (RAM_DEPTH)
    ) 
   uut   
   (
     .i_clk (clock),
     .i_addr (reg_i_addr),
     .i_data (data_in),
     .wea (reg_wea),
     //.regcea (reg_regcea),
     .o_data (wire_o_data)
   );
  
endmodule



