`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.07.2020 20:40:50
// Design Name: 
// Module Name: test_bench_Stall_unit
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

module test_bench_Stall_unit();

// Inputs
reg reset;
reg ID_EX_MemRead;
reg [`RS_WIDTH - 1 :0] IF_ID_rs;
reg [`RT_WIDTH - 1 :0] IF_ID_rt;
reg [`RT_WIDTH - 1 :0] ID_EX_rt;//

// Outputs
wire pc_Write;
wire control_enable;
wire IF_ID_write;

	initial	
	
	begin
	    reset = 1;
        ID_EX_MemRead = 1;

        #`ASYNC_WAIT
        IF_ID_rs = 10;
        IF_ID_rt = 20;
        ID_EX_rt = 10;
        reset = 0;
        #`ASYNC_WAIT 
       ID_EX_rt = 20;
        #`ASYNC_WAIT   
        ID_EX_MemRead = 0;
        #`ASYNC_WAIT   
        
         $finish;
	end

Stall_unit uut
    (
        //inputs
        .reset (reset),
        .ID_EX_MemRead (ID_EX_MemRead),
        .IF_ID_rs (IF_ID_rs),
        .IF_ID_rt (IF_ID_rt),
        .ID_EX_rt(ID_EX_rt),
        //outputs
        .pc_Write(pc_Write),
        .control_enable(control_enable),
        .IF_ID_write(IF_ID_write) 
    );

endmodule
