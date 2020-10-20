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
    input rx_done,clk,reset,                                       
    output reg [INSTRUCTION_WIDTH-1:0] loader_inst_out,         //to instruction memory instruction_in
    output reg [`MEMORY_ADDR_WIDTH-1:0] loader_addr_out,   //to instruction memory write_addr
    output reg loader_wea,     
    output reg loader_rea,                                //to instruction memory wea/rea 
    output reg enable                                      //enable processor
    );
    
    localparam [3:0]
        IDLE = 'b0001,     // Waiting for instruction
        LOADING = 'b0010,  // Loading instruction (4 bytes)
        DONE =  'b0100,    //Instruction loaded
        STEP_MODE =  'b1000 ;// Set the mode of clk signal (step-by-step or continous)
        
    reg [INSTRUCTION_WIDTH-1:0] loader_inst_next;
    reg [`MEMORY_ADDR_WIDTH-1:0] loader_addr_next ;
    reg  [3:0]  state, state_next;
    reg [INSTRUCTION_WIDTH-1:0] inst_buffer,inst_buffer_next;
    reg [$clog2(INSTRUCTION_WIDTH/WORD_IN_WIDTH):0] word_counter,word_counter_next;
    reg [`INSTRUCTION_ADDR_WIDTH-1:0] inst_addr_counter,inst_addr_counter_next;
    
    //internal vatiables
    reg enable_next,enable_aux,enable_aux_next;
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
        enable <= 0;
        enable_aux <= 0;
        end
	else 
		begin 
		state  <=  state_next ; 
		inst_buffer  <= inst_buffer_next; 
		word_counter  <=  word_counter_next; 
		inst_addr_counter <= inst_addr_counter_next;
		loader_inst_out <= loader_inst_next;
        loader_addr_out <= loader_addr_next;
        step_flag <= step_flag_next;
        step_mode <= step_mode_next;
        enable <= enable_next;
        enable_aux <= enable_aux_next;
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
                begin // ---------
                    if(rx_out == (`STEP_BY_STEP_CODE))
                    begin
                        state_next = STEP_MODE;
                        inst_buffer_next = inst_buffer_next;
                        inst_addr_counter_next = inst_addr_counter_next;
                        word_counter_next = word_counter_next;
                    end

                    else
                        begin
                            enable_next = 1;
                            state_next = LOADING;
                            inst_buffer_next = {rx_out,inst_buffer[INSTRUCTION_WIDTH-1:WORD_IN_WIDTH]};
                            inst_addr_counter_next = inst_addr_counter;
                            word_counter_next = word_counter + 1;
                        end
                end // ---------------
                else
                    begin
                    enable_next = 1;
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
                        if(rx_out == (`STEP_BY_STEP_CODE))
                        begin
                            if(enable == 1 && enable_aux == 1)
                                begin
                                enable_next = 0;
                                enable_aux_next = enable_aux;
                                end
                            else if(enable == 0 && enable_aux == 0)
                                begin
                                enable_next = 1;
                                enable_aux_next = 1;
                                end
                            else 
                                begin
                                enable_next = enable;
                                enable_aux_next = enable_aux;
                                end    
                         end
                               
                         else
                         begin
                            enable_next = 0;
                            enable_aux_next = 0;
                         end
                            
                        state_next = STEP_MODE;
                        inst_buffer_next = inst_buffer_next;
                        inst_addr_counter_next = inst_addr_counter_next;
                        word_counter_next = word_counter_next;       
                end
                
        
            endcase
        end
        
 //Output logic
always@(*)
case(state)
    IDLE :
    begin   
    loader_inst_out = loader_inst_out;
    loader_addr_out = loader_addr_out;
    loader_wea = 0;//escritura de istrucciones
    loader_rea = 1;//lectura de instrucciones
    end
    LOADING :
    begin
    loader_inst_out = 0;
    loader_addr_out = loader_addr_out;
    loader_wea = 0;
    loader_rea = 1;
    end
    DONE :
    begin
    loader_inst_out = inst_buffer;
    loader_addr_out = inst_addr_counter;
    loader_wea = 1'b1;
    loader_rea = 1;
    end
    STEP_MODE :
    begin
        loader_inst_out = loader_inst_out;
        loader_addr_out = loader_addr_out;
        loader_wea = 0;
        loader_rea = 1; 
    end
    default :
    begin
    loader_inst_out = 0;
    loader_addr_out = 0;
    loader_wea = 0;
    loader_rea = 1;
    end
endcase
   
endmodule


