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
    input [`DATA_MEMORY_WIDTH -1 : 0] Write_Data_in,
    input [`REGISTERS_ADDR_WIDTH -1 :0] Write_addr_in,
    input [`PC_WIDTH - 1 :0] pc_adder_in,
    input [`RD_WIDTH - 1 : 0] rd_in,
    //control signals in
    input MemWrite_in,MemRead_in,RegWrite_in,
    input [1:0] MemtoReg_in,
    input MEM_write,
    
    //outputs
    output reg [`DATA_MEMORY_WIDTH -1 : 0] Read_data,Alu_result,
    output reg [`REGISTERS_ADDR_WIDTH - 1 : 0] Write_addr,
    //control signals out
    output reg [`PC_WIDTH - 1 :0] pc_adder,
    output reg [1:0] MemtoReg,
    output reg RegWrite,
    output reg [`RD_WIDTH - 1 : 0] rd
);

//modules ouputs ,MEM/WB register inputs
wire [`DATA_MEMORY_WIDTH -1 : 0] Read_data_out;

//MEM Reg output to data memory for write operations
reg MemWrite;
reg [`DATA_MEMORY_WIDTH -1 : 0] Write_data;

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
            Write_data <= 0;
            //rd <= 0;
        end
    else if(MEM_write)
        begin
            Read_data <= Read_data_out;
            pc_adder <= pc_adder_in ;
            Alu_result <= Addr;
            Write_addr <= Write_addr_in;
            MemtoReg <= MemtoReg_in;
            RegWrite <= RegWrite_in;
            MemWrite <= MemWrite_in;
            Write_data <= Write_Data_in;
            rd <= rd_in;
        end
        
      else
        begin
            Read_data <= Read_data;
            pc_adder <= pc_adder ;
            Alu_result <=Alu_result;
            Write_addr <= Write_addr;
            MemtoReg <=MemtoReg;
            RegWrite <= RegWrite;
            MemWrite <= MemWrite;
            Write_data <= Write_data;
            rd <= rd;
        end
        
    end

Memory
#(
    .memory_width(`DATA_MEMORY_WIDTH),
    .memory_depth(`DATA_MEMORY_DEPTH)
)
 Data_memory
(
		.clk(clk), 
		.reset(reset), 
		.wea(MemWrite), 
		.rea(MemRead_in),
		.write_data(Write_data), 
		.read_data(Read_data_out), 
		.read_addr(Addr),
		.write_addr(Alu_result)
);

endmodule
