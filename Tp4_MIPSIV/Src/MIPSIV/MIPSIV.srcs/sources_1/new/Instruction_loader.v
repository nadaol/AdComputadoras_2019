`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.06.2020 01:57:36
// Design Name: 
// Module Name: Instruction_loader
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
`define INSTRUCTION_ADDR_WIDTH $clog2(INSTRUCTION_WIDTH)
`define MEMORY_ADDR_WIDTH $clog2(MEMORY_DEPTH)


//Interfaz para la carga de intrucciones , del modulo rx (dato 8bits) a la memoria de programa (instruction 32bits)
module Instruction_loader
#(
    parameter WORD_IN_WIDTH = `WORD_WIDTH ,//#Rx data input width
    parameter INSTRUCTION_WIDTH = `INSTRUCTION_WIDTH,
    parameter MEMORY_DEPTH = `INST_MEMORY_DEPTH
)
(
    input [WORD_IN_WIDTH -1:0] rx_out,
    input rx_done,clk,reset,
    output reg [INSTRUCTION_WIDTH-1:0] loader_inst_out,         //to instruction memory instruction_in
    output reg [`MEMORY_ADDR_WIDTH-1:0] loader_addr_out,   //to instruction memory write_addr
    output reg loader_wea                                       //to instruction memory wea
    );
    
    localparam [2:0]
        IDLE = 3'b001,
        LOADING = 3'b010,
        DONE =  3'b100;
        
    reg  [2:0]  state, state_next;
    reg [INSTRUCTION_WIDTH-1:0] inst_buffer,inst_buffer_next;
    reg [$clog2(INSTRUCTION_WIDTH/WORD_IN_WIDTH):0] word_counter,word_counter_next;
    reg [`INSTRUCTION_ADDR_WIDTH-1:0] inst_addr_counter,inst_addr_counter_next;
    
    //Memory
    always@(posedge clk)
    begin
    if(reset)
        begin
        state = IDLE;
        inst_buffer = 0;
        word_counter = 0;
        inst_addr_counter=0;
        loader_inst_out = 0;
        loader_addr_out = 0;
        loader_wea = 0;
        end
	else 
		begin 
		state  <=  state_next ; 
		inst_buffer  <= inst_buffer_next; 
		word_counter  <=  word_counter_next; 
		inst_addr_counter <= inst_addr_counter_next;
		end 
    end
    
    //Next state logic
    always@(*)
        begin
        state_next = state;
        inst_buffer_next = inst_buffer;
        word_counter = word_counter_next;
        inst_addr_counter_next = inst_addr_counter;
        case(state)
            IDLE :
                begin
                if(rx_done)
                    begin
                    state_next = LOADING;
                    inst_buffer_next = {rx_out,inst_buffer[INSTRUCTION_WIDTH-1:WORD_IN_WIDTH]};
                    inst_addr_counter_next = inst_addr_counter;
                    word_counter_next = word_counter + 1;
                    end
                else
                    begin
                    inst_buffer_next = 0;
                    word_counter_next = 0;
                    inst_addr_counter_next = inst_addr_counter;
                    end
                end
            LOADING:
                if(rx_done)
                    if(word_counter == (INSTRUCTION_WIDTH/WORD_IN_WIDTH))
                        begin
                        state_next = DONE;
                        inst_buffer_next = {rx_out,inst_buffer[INSTRUCTION_WIDTH-1:WORD_IN_WIDTH]};
                        inst_addr_counter_next = inst_addr_counter;
                        word_counter_next = 0;
                        end
                    else
                        begin
                        state_next = LOADING;
                        inst_buffer_next = {rx_out,inst_buffer[INSTRUCTION_WIDTH-1:WORD_IN_WIDTH]};
                        inst_addr_counter_next = inst_addr_counter;
                        word_counter_next = word_counter + 1;
                        end
            DONE:
                begin
                state_next = IDLE;
                inst_buffer_next = inst_buffer_next;
                inst_addr_counter_next = inst_addr_counter + 1;
                word_counter_next = 0;
                end
        
            endcase
        end
        
  //Output logic
always@(*)
case(state)
    IDLE :
    begin   //Mantain addr till end loading new instrucion
    loader_inst_out = loader_inst_out;
    loader_addr_out = loader_addr_out;
    loader_wea = 0;
    end
    LOADING :
    begin
    loader_inst_out = 0;
    loader_addr_out = loader_addr_out;
    loader_wea = 0;
    end
    DONE :
    begin
    loader_inst_out = inst_buffer;
    loader_addr_out = inst_addr_counter;
    loader_wea = 1'b1;

    end
    default :
    begin
    loader_inst_out = 0;
    loader_addr_out = 0;
    loader_wea = 0;
    end
endcase
   
endmodule
