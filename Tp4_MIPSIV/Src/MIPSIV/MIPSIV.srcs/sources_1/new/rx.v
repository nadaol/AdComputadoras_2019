 `timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Oliva Nahuel - Fede Bosack
// 
// Create Date: 11/02/2019 04:05:38 PM
// Design Name: 
// Module Name: rx
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
`define BIT_RESOLUTION 16   //Number of ticks per bit sample
`define BIT_COUNTER_WIDTH $clog2(WORD_WIDTH)
`define TICK_COUNTER_WIDTH $clog2(STOP_TICK_COUNT)

module Rx
#(	
parameter WORD_WIDTH = 8, //#Data Nbits
parameter STOP_BIT_COUNT = 1 //ticks for STOP bits 
)
( 
input  wire  clk, reset, 
input  wire  rx,  tick, 
output  reg  rx_done, 
output  reg  [WORD_WIDTH-1:0]  rx_out
);
					 
localparam STOP_TICK_COUNT = STOP_BIT_COUNT * `BIT_RESOLUTION;
localparam STATE_WIDTH = 4;
  
// One hot  state  constants
localparam  [STATE_WIDTH:0]
	IDLE  =  4'b0001, 
	START =  4'b0010, 
	DATA  =  4'b0100, 
	STOP  =  4'b1000; 

// Signal  declarations 
reg  [STATE_WIDTH-1:0]  state_reg, state_next;
reg  [`TICK_COUNTER_WIDTH - 1:0]  s_reg, s_next; 
reg  [`BIT_COUNTER_WIDTH:0]  n_reg, n_next; 
reg  [WORD_WIDTH-1:0]  b_reg, b_next; 
reg done_reg;

//  FSMD memory ( states  &  DATA  registers )
always  @(posedge clk) 
	if (reset) 
		begin 
			state_reg  <=  IDLE; //comienzo en IDLE
			s_reg  <=  0; //contador de ticks
			n_reg  <=  0; //contador de bits
			b_reg  <=  0;//byte a recibir
		end 
	else 
		begin 
			state_reg  <=  state_next ; 
			s_reg  <=  s_next; 
			n_reg  <=  n_next; 
			b_reg  <=  b_next; 
		end 

//  FSMD  next-state  logic 
always  @* 
begin 
	state_next  =  state_reg; 
	done_reg  =  1'b0; 
	s_next  =  s_reg; 
	n_next  =  n_reg; 
	b_next  =  b_reg; 

	case (state_reg) 
		IDLE:
			if  (~rx) //si el bit rx = 0 (START)
			begin 
				state_next  =  START; //siguiente estado START
				s_next  =  0; //reseteo contador ticks
			end 
		START:
			if  (tick) 
				if  (s_reg==7) //cuento ticks hasta la mitad del STOP bit
					begin 
						state_next  =  DATA; //sampleo
						s_next  =  0; //reseteo contador de ticks/bits
						n_next  =  0; 
					end 
				else 
					s_next  =  s_reg  +  1;//contador ticks +1
		DATA:
			if  (tick) 
				if  (s_reg==15) //sampleo cada 16 ticks con desfasaje de 8
					begin 
						s_next  =  0; 
						//desplazo byte a la izq y agrego el bit rx al Lsb
						b_next  =  {rx , b_reg  [7 : 1]} ; 
						if  (n_reg==(WORD_WIDTH - 1)) //al recibir DBIT's
							state_next  =  STOP  ; //defino siguiente estado en STOP
						else 
							n_next  =  n_reg  +  1; //contador de bits + 1
					end 
				else 
					s_next  =  s_reg  +  1; //contador de ticks + 1
		STOP: 
			if  (tick) 
				if  (s_reg == (STOP_TICK_COUNT - 1)) //Cuento ticks de bit de STOP
					begin 
						state_next  =  IDLE;//vuelvo al IDLE
						done_reg  = 1'b1;//seteo la flag del buff para cargar nuevo dato
					end 
				else 
					s_next  =  s_reg  +  1;//contador de ticks + 1
	endcase

end

//Output logic
always@(*)
case(state_reg)
    IDLE :
    begin
    rx_out = rx_out;//Mantain rx_out and done flag till start transmiting again
    rx_done = 0;
    end
    START :
    begin
    rx_out = 0;
    rx_done = 0;
    end
    DATA :
    begin
    rx_out = 0;
    rx_done = 0;
    end
    STOP :
    begin
    rx_out = b_reg;//Set rx_out and done flag        
    rx_done = done_reg;
    end
    default :
    rx_out = 0;
endcase

endmodule

