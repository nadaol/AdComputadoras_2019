`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.07.2020 16:12:59
// Design Name: 
// Module Name: MEM_top
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
`include "Parameters.vh"

module MEM_top(
    //inputs
    input clk,reset,
    input [`DATA_MEMORY_ADDR_WIDTH - 1 : 0] Addr,
    input [`REGISTERS_WIDTH -1 : 0] Write_Data,
    input [`REGISTERS_ADDR_WIDTH -1 :0] Write_addr_in,
    input [`PC_WIDTH - 1 :0] pc_adder_in,
    input [`REGISTERS_WIDTH - 1 : 0] rd_in,
    //control signals in
    input MemWrite_in,MemRead_in,RegWrite_in,
    input [1:0] MemtoReg_in,
    
    //outputs
    output reg [`REGISTERS_WIDTH -1 : 0] Read_data,Alu_result,
    output reg [`REGISTERS_ADDR_WIDTH -1 :0] Write_addr,
    //control signals out
    output reg [`PC_WIDTH - 1 :0] pc_adder,
    output reg [1:0] MemtoReg,
    output reg RegWrite,
    output reg [`REGISTERS_WIDTH - 1 : 0] rd
);

//modules ouputs ,MEM/WB register inputs
wire [`REGISTERS_WIDTH -1 : 0] Read_data_out;

reg MemWrite;
reg MemRead;

  //MEM/WB Memory register
    always@(posedge clk)
    begin
    if(reset)
        begin
            Read_data <= 0;
            Alu_result <= 0;
            MemtoReg <= 0;
            Write_addr <= 0;
            RegWrite <= 0;
        end
    else
        begin
            Read_data <= Read_data_out;
            pc_adder <= pc_adder_in ;
            Alu_result <= Addr;
            Write_addr <= Write_addr_in;
            MemtoReg <= MemtoReg_in;
            RegWrite <= RegWrite_in;
            MemWrite <= MemWrite_in;
            MemRead <= MemRead_in;
        end
        
    end

Memory Data_memory
(
		.clk(clk), 
		.reset(reset), 
		.wea(MemWrite), 
		.rea(MemRead),
		.write_data(Write_Data), 
		.read_data(Read_data_out), 
		.read_addr(Addr),
		.write_addr(Addr)
);

endmodule
