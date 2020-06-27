`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Oliva Nahuel - Fede Bosack
// 
// Create Date: 11/02/2019 04:04:32 PM
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

`define WIDTH_WORD_TOP          8       // Tamaño de palabra.    
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

module TOP
#(
// Parametros
parameter OPCODE_LENGTH     = `OPCODE_LENGTH,
parameter CC_LENGTH         = `CC_LENGTH,
parameter ACC_LENGTH        = `ACC_LENGTH,
parameter WIDTH_WORD_TOP    = `WIDTH_WORD_TOP,
parameter FREC_CLK_MHZ      = `FREC_CLK_MHZ,
parameter BAUD_RATE_TOP     = `BAUD_RATE_TOP,
parameter CANT_BIT_STOP_TOP = `CANT_BIT_STOP_TOP,
parameter PC_CANT_BITS      = `PC_CANT_BITS,
parameter SUM_DIR           = `SUM_DIR,
parameter OPERANDO_LENGTH   = `OPERANDO_LENGTH,         
parameter OPERANDO_FINAL_LENGHT     = `OPERANDO_FINAL_LENGHT,    
parameter RAM_WIDTH_DATOS           = `RAM_WIDTH_DATOS,
parameter RAM_WIDTH_PROGRAMA        =  `RAM_WIDTH_PROGRAMA,
parameter RAM_PERFORMANCE_DATOS     =  `RAM_PERFORMANCE_DATOS,
parameter RAM_PERFORMANCE_PROGRAMA  = `RAM_PERFORMANCE_PROGRAMA,
parameter INIT_FILE_DATOS           =   `INIT_FILE_DATOS,
parameter INIT_FILE_PROGRAMA        =  `INIT_FILE_PROGRAMA,     
parameter RAM_DEPTH_DATOS           =  `RAM_DEPTH_DATOS,
parameter RAM_DEPTH_PROGRAMA        =  `RAM_DEPTH_PROGRAMA
)
(
  input i_clock, 
  input i_reset,
  input uart_txd_in,
  output uart_rxd_out,
  output [ACC_LENGTH - 1 : 0] led 
  );

//conexiones internas
wire [WIDTH_WORD_TOP - 1 : 0]   wire_data_rx;
wire [WIDTH_WORD_TOP - 1 : 0]   wire_data_tx;
wire wire_tx_done;
wire wire_rx_done;
wire wire_tx_start;
wire wire_rate_baud_generator;
wire wire_soft_reset;
wire [PC_CANT_BITS - 1 : 0] wire_addr_mem_programa;
wire [RAM_WIDTH_PROGRAMA - 1 : 0] wire_data_mem_programa;
wire [1 : 0]  wire_selA;
wire wire_selB;
wire wire_wrACC;
wire [OPCODE_LENGTH - 1 : 0] wire_opcode_instruction_decoder;
wire wire_wr_rd_mem;
wire [PC_CANT_BITS - 1 : 0] wire_cuenta_ciclos;
wire [ACC_LENGTH - 1 : 0] wire_valor_ACC;
wire [RAM_WIDTH_DATOS - 1 : 0] wire_datos_out_mem_data;
wire [PC_CANT_BITS - 1 : 0] wire_addr_mem_datos;

//asignacion leds parte baja del ACC y Del CC
assign led[ACC_LENGTH/2 - 1 : 0] = wire_valor_ACC[7 : 0];
assign led[ACC_LENGTH - 1 : ACC_LENGTH/2 ] = wire_cuenta_ciclos[7 : 0];

// Modulo interface_circuit.

Interface
    #(
        .CANT_BITS_OPCODE (OPCODE_LENGTH),      //  Cantidad de bits del opcode.
        .CC_LENGTH (CC_LENGTH),                 //  Cantidad de bits del contador de ciclos.
        .ACC_LENGTH (ACC_LENGTH),               //  Cantidad de bits del acumulador.
        .OUTPUT_WORD_LENGTH (WIDTH_WORD_TOP)  //  Cantidad de bits de la palabra a transmitir.
     ) 
   interface1    
   (
    .i_clock (i_clock),
    .i_reset (i_reset),
    .i_rx_done (wire_rx_done),
    .i_data_rx (wire_data_rx),
    .i_opcode (wire_opcode_instruction_decoder),
    .o_soft_reset (wire_soft_reset)
   );
   

// Modulo baud_rate_generator  
Baud_rate_generator
    #(
        .BAUD_RATE (BAUD_RATE_TOP),
        .FREC_CLOCK_MHZ (FREC_CLK_MHZ)
    ) 
    baud_rate_generator1  
    (
    .i_clock (i_clock),
    .i_reset (i_reset),
    .o_rate (wire_rate_baud_generator)
    );
      
// Modulo receptor      
Rx
    #(
        .WIDTH_WORD (WIDTH_WORD_TOP),
        .CANT_BIT_STOP (CANT_BIT_STOP_TOP)
    ) 
    rx1    // Una sola instancia de este modulo
    (
    .i_clock (i_clock),
    .i_rate (wire_rate_baud_generator),
    .i_bit_rx (uart_txd_in),
    .i_reset (i_reset),
    .o_rx_done (wire_rx_done),
    .o_data_out (wire_data_rx)
    );



// Modulo ALU.

Control
    #(
        .PC_CANT_BITS (PC_CANT_BITS),   // Cantidad de bits del PC.
        .SUM_DIR (SUM_DIR),             // Cantidad a sumar al PC para obtener la direccion siguiente.
        .OPCODE_LENGTH (OPCODE_LENGTH)  // Cantidad de bits del codigo de operacion
    )
    control1    
    (
        .i_clock (i_clock),
        .i_soft_reset (wire_soft_reset),
        .i_mem_data_opcode (wire_data_mem_programa [RAM_WIDTH_PROGRAMA - 1 : RAM_WIDTH_PROGRAMA - OPCODE_LENGTH]),
        .o_addr_mem (wire_addr_mem_programa),
        .o_selA (wire_selA),
        .o_selB (wire_selB),
        .o_wrAcc (wire_wrACC),
        .o_opCode (wire_opcode_instruction_decoder),
        .o_wr_rd_mem (wire_wr_rd_mem)
    );
    

Datapath
    #(
        .OPERANDO_LENGTH (OPERANDO_LENGTH),                 // Cantidad de bits del operando.
        .OPERANDO_FINAL_LENGHT (OPERANDO_FINAL_LENGHT),     // Cantidad de bits del operando con extension 
        .OPCODE_LENGTH (OPCODE_LENGTH)                      // Cantidad de bits del opcode.
    )
    datapath1
    (
        .i_clock (i_clock),
        .i_reset (wire_soft_reset),
        .i_selA (wire_selA),
        .i_selB (wire_selB),
        .i_wrACC (wire_wrACC),
        .i_opcode (wire_opcode_instruction_decoder),
        .i_operando (wire_data_mem_programa [RAM_WIDTH_PROGRAMA - OPCODE_LENGTH - 1 : 0]),
        .i_outmemdata (wire_datos_out_mem_data),
        .o_addr (wire_addr_mem_datos),
        .o_ACC (wire_valor_ACC)            
    );

Data_memory
   #(
        .RAM_WIDTH (RAM_WIDTH_DATOS),
        .RAM_PERFORMANCE (RAM_PERFORMANCE_DATOS),
        .INIT_FILE (INIT_FILE_DATOS),
        .RAM_DEPTH (RAM_DEPTH_DATOS)
    ) 
  Data_memory1
   (
     .i_clk (i_clock),
     .i_addr (wire_addr_mem_datos),
     .i_data (wire_valor_ACC),
     .wea (wire_wr_rd_mem),
     .o_data (wire_datos_out_mem_data)
   );

Instruction_memory
    #(
        .RAM_WIDTH (RAM_WIDTH_PROGRAMA),
        .RAM_PERFORMANCE (RAM_PERFORMANCE_PROGRAMA),
        .INIT_FILE (INIT_FILE_PROGRAMA),
        .RAM_DEPTH (RAM_DEPTH_PROGRAMA)
    )
  Instruction_memory1
    (
        .i_clk (i_clock),
        .i_addr (wire_addr_mem_programa),
        .o_data (wire_data_mem_programa)  
    );


Cc
    #(
        .CONTADOR_LENGTH (PC_CANT_BITS),
        .OPCODE_LENGTH(OPCODE_LENGTH)
    )
    CC1
    (
        .i_clock (i_clock),
        .i_reset (wire_soft_reset),
        .i_opcode(wire_opcode_instruction_decoder),
        .o_cuenta (wire_cuenta_ciclos)
    );

endmodule
