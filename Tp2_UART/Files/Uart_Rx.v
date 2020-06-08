`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:54:13 09/25/2019 
// Design Name: 
// Module Name:    Uart_Rx 
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
module Uart_Rx
#(	parameter DBIT = 8, //#data bits
						parameter SB_TICK = 16 //ticks for stop bits 
					 )
					 ( input  wire  clk, reset, 
						input  wire  rx,  s_tick, 
						output  reg  rx_done_tick, 
						output  wire  [7:0]  dout 
					 );
 
//  symbolic  state  declaration 
localparam  [1:0]
	idle  =  2'b00, 
	start =  2'b01, 
	data  =  2'b10, 
	stop  =  2'b11; 

//  signal  declaration 
reg  [1:0]  state_reg, state_next;
reg  [3:0]  s_reg, s_next; 
reg  [2:0]  n_reg, n_next; 
reg  [7:0]  b_reg, b_next; 

//  bod,v 
//  FSMD  state  &  data  registers 
always  @(posedge clk) 
	if (reset) 
		begin 
			state_reg  <=  idle; //comienzo en idle
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
	rx_done_tick  =  1'b0; 
	s_next  =  s_reg; 
	n_next  =  n_reg; 
	b_next  =  b_reg; 

	case (state_reg) 
		idle:
			if  (~rx) //si el bit rx = 0 (start)
			begin 
				state_next  =  start; //siguiente estado start
				s_next  =  0; //reseteo contador ticks
			end 
		start:
			if  (s_tick) 
				if  (s_reg==7) //cuento ticks hasta la mitad del stop bit
					begin 
						state_next  =  data; //sampleo
						s_next  =  0; //reseteo contador de ticks/bits
						n_next  =  0; 
					end 
				else 
					s_next  =  s_reg  +  1;//contador ticks +1
		data:
			if  (s_tick) 
				if  (s_reg==15) //sampleo cada 16 ticks con desfasaje de 8
					begin 
						s_next  =  0; 
						//desplazo byte a la izq y agrego el bit rx al Lsb
						b_next  =  {rx , b_reg  [7 : 1]} ; 
						if  (n_reg==(DBIT - 1)) //al recibir DBIT's
							state_next  =  stop  ; //defino siguiente estado en stop
						else 
							n_next  =  n_reg  +  1; //contador de bits + 1
					end 
				else 
					s_next  =  s_reg  +  1; //contador de ticks + 1
		stop: 
			if  (s_tick) 
				if  (s_reg == (SB_TICK - 1)) //Cuento ticks de bit de stop
					begin 
						state_next  =  idle;//vuelvo al idle
						rx_done_tick  = 1'b1;//seteo la flag del buff para cargar nuevo dato
					end 
				else 
					s_next  =  s_reg  +  1;//contador de ticks + 1
	endcase

end

//  output 
assign  dout  =  b_reg; 

endmodule