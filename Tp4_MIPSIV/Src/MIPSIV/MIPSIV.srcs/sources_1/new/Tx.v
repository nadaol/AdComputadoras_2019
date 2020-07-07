`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:07:10 09/25/2019 
// Design Name: 
// Module Name:    Uart_Tx 
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

`define BIT_COUNTER_WIDTH $clog2(WORD_WIDTH)
`define TICK_COUNTER_WIDTH $clog2(STOP_TICK_COUNT)

module Tx
#(	
parameter WORD_WIDTH = `WORD_WIDTH, //#Data Nbits
parameter STOP_BIT_COUNT = `STOP_BIT_COUNT, //ticks for STOP bits 
parameter BIT_RESOLUTION = `BIT_RESOLUTION //Number of ticks per bit sample
)
( 
input  clk, reset, tick, tx_start,
input  [WORD_WIDTH-1:0] tx_in, 
output  reg  tx_done,               //Must be checked externally to load new value or disable tx_start
output  reg  tx_out
);
					 
localparam STOP_TICK_COUNT = STOP_BIT_COUNT * BIT_RESOLUTION;
localparam NSTATES = 4;
  
// One hot  state  constants
localparam  [NSTATES-1:0]
	IDLE  =  4'b0001, 
	START =  4'b0010, 
	DATA  =  4'b0100, 
	STOP  =  4'b1000; 

// Signal  declarations 
reg  [NSTATES-1:0]  state_reg, state_next;
reg  [`TICK_COUNTER_WIDTH - 1:0]  s_reg, s_next; 
reg  [`BIT_COUNTER_WIDTH:0]  n_reg, n_next; 
reg  [WORD_WIDTH-1:0]  b_reg, b_next; 
reg tx_done_reg;
reg tx_reg, tx_next;

//  FSMD memory ( states  &  DATA  registers )
always  @(posedge clk) 
	if (reset) 
		begin 
			state_reg  <=  IDLE; //comienzo en IDLE
			s_reg  <=  0; //contador de ticks
			n_reg  <=  0; //contador de bits
			b_reg  <=  0;//byte a transmitir
			tx_reg <= 0;
		end 
	else 
		begin 
			state_reg  <=  state_next ; 
			s_reg  <=  s_next; 
			n_reg  <=  n_next; 
			b_reg  <=  b_next; 
			tx_reg <= tx_next;
		end 

//  FSMD  next-state  logic 
always  @* 
begin 
	state_next  =  state_reg; 
	tx_done_reg  =  1'b0; 
	s_next  =  s_reg; 
	n_next  =  n_reg; 
	b_next  =  b_reg; 
	tx_next = tx_reg;

	case (state_reg) 
		IDLE:
			begin
				if  (tx_start) //si el bit de start = 1 ,comienza la transmision
					begin 
						state_next  =  START; //siguiente estado START
						s_next  =  0; //reseteo contador ticks
						b_next = tx_in;
					end 
			end
		START:
			begin
				if  (tick) 
					if  (s_reg==BIT_RESOLUTION-1) //cuento ticks hasta el final del STOP bit
						begin 
							state_next  =  DATA; //sampleo
							s_next  =  0; //reseteo contador de ticks/bits
							n_next  =  0; 
						end 
					else 
						s_next  =  s_reg  +  1;//contador ticks +1
			end
		DATA:
			begin
				tx_next = b_reg[0]; //Transmito el bit menos significativo
				if  (tick) 
					if  (s_reg==BIT_RESOLUTION-1) //sampleo cada 16 ticks
						begin 
							s_next  =  0; //Reseteo contador de ticks
							b_next  =  b_reg >> 1 ; //desplazo byte a la derecha
							if  (n_reg==(WORD_WIDTH - 1)) //al transmitir DBIT's
								state_next  =  STOP  ; //defino siguiente estado en STOP
							else 
								n_next  =  n_reg  +  1; //contador de bits + 1
						end 
					else 
						s_next  =  s_reg  +  1; //contador de ticks + 1
			end
		STOP: 
			begin
				if  (tick) 
					if  (s_reg == (STOP_TICK_COUNT - 1)) //Mantengo el bit de stop hasta 'stop_tick_count' ticks
						begin 
							state_next  =  IDLE;//vuelvo al IDLE
							tx_done_reg  = 1'b1;//seteo la flag del buff para cargar nuevo dato
						end 
				else 
					s_next  =  s_reg  +  1;//contador de ticks + 1
			end
	endcase

end

//Output logic
always@(*)
case(state_reg)
    IDLE :
    begin
    	tx_out =  1'b1;//Genero bit de stop/idle (1) , Idle transmision signal hasta q se indique el comienzo de la transmision
    	tx_done = 0;
    end
    START :
    begin
    	tx_out = 1'b0;//Genero bit de start (0) durante la etapa del start
    	tx_done = 0;
    end
    DATA :
    begin
    	tx_out = tx_reg;//Transmitiendo bits del buffer (8)
    	tx_done = 0;
    end
    STOP :
    begin
    	tx_out = 1'b1;//Genero bit de stop/idle (1) lo que dure etapa stop   
    	tx_done = tx_done_reg;//Al finalizar se setea la flag
    end
    default :
	begin
    	tx_out = 0;
		tx_done = 0;
	end
endcase

endmodule
