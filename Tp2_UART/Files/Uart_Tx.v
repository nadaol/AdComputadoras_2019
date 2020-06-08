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
module Uart_Tx
#( parameter DBIT = 8, //#data bits
						parameter SB_TICK = 16 //ticks for stop bits (16*Nbits_parada)
					 )
					 ( input wire clk, reset, 
						input wire tx_start, s_tick , 
						input wire [7:0] din, 
						output reg tx_done_tick , 
						output wire tx 
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
reg tx_reg , tx_next; 

//  FSMD  state  &  data  registers 
always  @(posedge clk) 
	if (reset) 
		begin 
			state_reg  <=  idle; //comienzo en idle
			s_reg  <=  0; //contador de ticks
			n_reg  <=  0; //contador de bits
			b_reg  <=  0;//byte a transmitir
			tx_reg <=  1'b1; //bit en transmision
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
	tx_done_tick  =  1'b0; 
	s_next  =  s_reg; 
	n_next  =  n_reg; 
	b_next  =  b_reg;
	tx_next = tx_reg;

	case (state_reg) 
		idle : 
			begin 
				tx_next = 1'b1;//idle tx (1) 
				if (tx_start) //si  el buffer esta lleno
					begin 
						state_next = start ; //defino proximo estado en start
						s_next = 0; 
						b_next = din; //defino proximo dato a transferir
					end 
			end 
		start:
			begin 
				tx_next=1'b0; //defino bit de start (0)
				if (s_tick) 
					if(s_reg == 15) //cuento 15 ticks
						begin 
							state_next = data; //defino siguiente estado en data
							s_next = 0;
							n_next = 0; 
						end 
					else 
						s_next = s_reg + 1; //contador de ticks del start + 1
			end 
		data:
			begin //comienzo a transmitir el byte
				tx_next = b_reg[0]; //transmito el bit menos significativo
				if (s_tick) 
					if (s_reg==15) //al contar 15 ticks
						begin 
							s_next = 0; //reseteo contador de ticks
							b_next = b_reg >> 1; //desplazo byte a la derecha
							if (n_reg==(DBIT-1)) //si los bits transmitidos = DBIT-1(7)
								state_next = stop; //defino siguiente estado en stop
							else 
								n_next = n_reg + 1; //contador de bits transmitidos
						end 
					else 
						s_next = s_reg + 1;  //contador de ticks en transmision + 1
			end 
		stop:
			begin 
				tx_next = 1'b1; //defino bit de stop (1)
				if (s_tick) 
					if (s_reg==(SB_TICK -1)) //si s_reg == N°Ticks de parada
						begin 
							state_next = idle; //vuelvo al ldle
							tx_done_tick = 1'b1; //levanto bandera
						end 
					else 
						s_next = s_reg + 1; //contador de ticks de parada + 1
			end 
	endcase

end

//  output 
assign  tx  =  tx_reg; 

endmodule
