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
    parameter INSTRUCTION_WIDTH = `INST_WIDTH,
    parameter MEMORY_DEPTH = `INST_MEMORY_DEPTH
)
(
    input [WORD_IN_WIDTH -1:0] rx_out,
    input rx_done,clk_in,reset,                                       
    output reg [INSTRUCTION_WIDTH-1:0] loader_inst_out,         //to instruction memory instruction_in
    output reg [`MEMORY_ADDR_WIDTH-1:0] loader_addr_out,   //to instruction memory write_addr
    output reg loader_wea,     
    output reg loader_rea,                                //to instruction memory wea/rea
    output reg clk              //Clock signal (continous or step-by-step)                                      
    );
    
    localparam [3:0]
        IDLE = 'b0001,     // Waiting for instruction
        LOADING = 'b0010,  // Loading instruction (4 bytes)
        DONE =  'b0100,    //Instruction loaded
        STEP_MODE =  'b1000 ;// Set the mode of clk signal (step-by-step or continous)
        
    reg [INSTRUCTION_WIDTH-1:0] loader_inst_next;
    reg [`MEMORY_ADDR_WIDTH-1:0] loader_addr_next ;
    reg loader_wea_next,loader_rea_next ;
    reg  [2:0]  state, state_next;
    reg [INSTRUCTION_WIDTH-1:0] inst_buffer,inst_buffer_next;
    reg [$clog2(INSTRUCTION_WIDTH/WORD_IN_WIDTH):0] word_counter,word_counter_next;
    reg [`INSTRUCTION_ADDR_WIDTH-1:0] inst_addr_counter,inst_addr_counter_next;
    
    //internal vatiables
    reg step_mode;
    reg step_mode_next;
    reg step_flag;
    reg step_flag_next;
    
    //Memory
    always@(posedge clk)
    begin
    if(reset)
        begin
        state <= IDLE;
        inst_buffer <= 0;
        word_counter <= 0;
        inst_addr_counter <= 0;
        loader_inst_out <= 0;
        loader_addr_out <= 0;
        loader_wea <= 0;
        loader_rea <= 0;
        step_flag <= 0;
        end
	else 
		begin 
		state  <=  state_next ; 
		inst_buffer  <= inst_buffer_next; 
		word_counter  <=  word_counter_next; 
		inst_addr_counter <= inst_addr_counter_next;
		loader_inst_out <= loader_inst_next;
        loader_addr_out <= loader_addr_next;
        loader_wea <= loader_wea_next;
        loader_rea <= loader_rea_next;
        step_flag <= step_flag_next;
        step_mode <= step_mode_next;
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
                    if(rx_out == (`STEP_BY_STEP_CODE))
                    begin
                        state_next = STEP_MODE;
                        inst_buffer_next = inst_buffer_next;
                        inst_addr_counter_next = inst_addr_counter_next;
                        word_counter_next = word_counter_next;
                    end

                    else
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
                
             STEP_MODE : //Step-by-Step mode
                begin
                        //state_next = IDLE;
                        state_next = STEP_MODE;
                        inst_buffer_next = inst_buffer_next;
                        inst_addr_counter_next = inst_addr_counter_next;
                        word_counter_next = word_counter_next;       
                end
                
                //Continous mode state
                
        
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
    loader_rea = 1;
    clk = clk_in;
    end
    LOADING :
    begin
    loader_inst_out = 0;
    loader_addr_out = loader_addr_out;
    loader_wea = 0;
    loader_rea = 1;
    clk = clk_in;
    end
    DONE :
    begin
    loader_inst_out = inst_buffer;
    loader_addr_out = inst_addr_counter;
    loader_wea = 1'b1;
    loader_rea = 1;
    clk = clk_in;
    end
    STEP_MODE :
    begin
        loader_inst_out = loader_inst_out;
        loader_addr_out = loader_addr_out;
        loader_wea = loader_wea;
        loader_rea = loader_rea; 
        if(rx_out == (`STEP_BY_STEP_CODE))clk = 1;
        else clk = 0;
        //Ejecutar un ciclo
    end
    default :
    begin
    loader_inst_out = 0;
    loader_addr_out = 0;
    loader_wea = 0;
    loader_rea = 1;
    clk = clk_in;
    end
endcase
   
endmodule
