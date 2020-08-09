`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.07.2020 20:52:17
// Design Name: 
// Module Name: test_bench_Forwarding_unit
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

module test_bench_Forwarding_unit();

//inputs
reg [`RT_WIDTH - 1 :0] ID_EX_rt;
reg [`RS_WIDTH - 1 :0] ID_EX_rs;
reg [`RD_WIDTH - 1 :0] MEM_WB_rd;
reg [`RD_WIDTH - 1 :0] EX_MEM_rd;
reg MEM_WB_RegWrite,EX_MEM_RegWrite;
//outputs
wire [1:0] operand1_hazard;
wire [1:0] operand2_hazard;

initial
begin                   //No data hazard
    ID_EX_rt = 10;
    ID_EX_rs = 20;
    MEM_WB_rd = 30;
    EX_MEM_rd = 40;
    MEM_WB_RegWrite = 0;
    EX_MEM_RegWrite = 1;
    
    #`ASYNC_WAIT        //1a. EX/MEM.RegisterRd = ID/EX.RegisterRs
    ID_EX_rt = 10;  
    ID_EX_rs = 20;
    MEM_WB_rd = 30;
    EX_MEM_rd = 20;
    
    #`ASYNC_WAIT        //1b. EX/MEM.RegisterRd = ID/EX.RegisterRt
    ID_EX_rt = 10;
    ID_EX_rs = 20;
    MEM_WB_rd = 30;
    EX_MEM_rd = 10;
    
    #`ASYNC_WAIT        //2a. MEM/WB.RegisterRd = ID/EX.RegisterRs
    ID_EX_rt = 10;
    ID_EX_rs = 20;
    MEM_WB_rd = 20;
    EX_MEM_rd = 40;
    MEM_WB_RegWrite = 1;
    EX_MEM_RegWrite = 0;
    
    #`ASYNC_WAIT        //2b. MEM/WB.RegisterRd = ID/EX.RegisterRt
    ID_EX_rt = 10;
    ID_EX_rs = 20;
    MEM_WB_rd = 10;
    EX_MEM_rd = 40;
    #`ASYNC_WAIT
    $finish;
end

Forwarding_unit uut
(
    .ID_EX_rt(ID_EX_rt),
    .ID_EX_rs(ID_EX_rs),
    .MEM_WB_rd(MEM_WB_rd),
    .EX_MEM_rd(EX_MEM_rd),
    .MEM_WB_RegWrite(MEM_WB_RegWrite),
    .EX_MEM_RegWrite(EX_MEM_RegWrite),
    //outputs
    .operand1_hazard(operand1_hazard),
    .operand2_hazard(operand2_hazard)
);

endmodule
