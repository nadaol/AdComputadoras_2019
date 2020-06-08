`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:22:34 09/28/2019 
// Design Name: 
// Module Name:    Uart_Interface 
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
module Uart_Interface
#(parameter REG_SIZE=8)
					(  input wire clk, reset, 
						output reg rd_uart, wr_uart, 
						output reg [7:0] w_data , 
						input wire tx_full ,rx_empty, 
						input wire [7:0] r_data,
						
						output reg signed[REG_SIZE-1:0]a,
						output reg signed[REG_SIZE-1:0]b,
						output reg [REG_SIZE-1:0]op,
						input signed [REG_SIZE-1:0]w
					);

//  symbolic state  declaration 
localparam  [2:0]
	num1  =  3'b000, //lectura operando1
	num2  =  3'b001, //lectura operando2
	opr   =  3'b010,//lectura operador
	wr		=  3'b011,//
	send	=	3'b100;//transmito el resultado 
	
//  signal  declaration 
reg [2:0] state, next_state;
reg [REG_SIZE-1:0] a_state, b_state, op_state;

//  FSMD  state  &  data  registers 
always @(posedge clk) 
begin
	if (reset)
		begin
			state <= num1;
		end
	else
		begin
			state <= next_state;
			a <= a_state;
			b <= b_state;
			op <= op_state;
			w_data <= w;
		end
end

always @*
begin
	next_state = state;	
	a_state = a;
	b_state = b;
	op_state = op;
	case(state)
		num1:
			if(~rx_empty)//si el buffer de recepcion esta lleno
				begin
					a_state = r_data;//defino el valor de 'a' para el prox clock
					next_state = num2;//defino siguiente estado para el prox clock
					rd_uart = 1'b1;//bajo el flag del buff_rx (leido)
					wr_uart = 1'b0;//set flag del buff_tx = 0 (todavía no transmito)
				end
			else 
				begin
					rd_uart= 1'b0;//de lo contrario espero en el mismo estado para recibir
					wr_uart = 1'b0;
				end
		num2:
			if(~rx_empty)//idem  para 'b'
				begin
					b_state = r_data;
					next_state = opr;
					rd_uart = 1'b1;
					wr_uart = 1'b0;
				end
			else 
				begin
					rd_uart= 1'b0;
					wr_uart = 1'b0;
				end
		opr:
			if(~rx_empty)//idem para 'op'
				begin
					op_state = r_data;
					next_state = wr;	
					rd_uart = 1'b1;
					wr_uart = 1'b0;
				end
			else 
				begin
					rd_uart= 1'b0;
					wr_uart = 1'b0;
				end
		wr:			
			begin
				wr_uart = 1'b0;
				rd_uart= 1'b0;
				next_state= send;
			end
		send:		//Envio el resultado
			if(~tx_full)//si el buffer de transmision no esta lleno
				begin
					wr_uart = 1'b1;//set flag para cargar el dato al buff y transmitir
					rd_uart= 1'b0;
					next_state= num1;//siguinte estado num1
				end
			else 
				begin
					rd_uart= 1'b0;
					wr_uart = 1'b0;
				end
	   default:
			begin
				wr_uart = 1'b0;
				rd_uart= 1'b0;
			end
	endcase
end

endmodule