`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2020 20:54:26
// Design Name: 
// Module Name: test_bench_WB
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

module test_bench_WB();

//inputs
reg [`REGISTERS_WIDTH - 1 : 0] Read_data,Alu_result;
reg [`REGISTERS_WIDTH - 1 : 0] Return_Addr;
    //control signals in
reg [1:0] MemtoReg;
   
    //outputs
wire [`REGISTERS_WIDTH -1 :0] Write_data;

//test variables
integer i;

initial
begin
i = 0;
while(i < 4)
    begin
        Read_data = i+10;
        Alu_result = i+15;
        Return_Addr = i + 20;
        MemtoReg = i;               //10,16,22 
        i = i + 1;
        #`CLK_PERIOD;
    end
$finish;
end

WB_top wb_top(
//inputs
    .Read_data(Read_data),
    .Alu_result(Alu_result),
    .Return_Addr(Return_Addr),
    //control signals in
    .MemtoReg(MemtoReg),
    //outputs
    .Write_data(Write_data)
    );

endmodule
