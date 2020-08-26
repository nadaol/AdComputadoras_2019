`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.08.2020 19:49:59
// Design Name: 
// Module Name: test_bench_TOP
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

//Dependencia en primer instrucción, EX_MEM_RegWrite= 1 , 1b. EX/MEM.RegisterRd = ID/EX.RegisterRt.
/*
addi 0,0,1 ; f1 = reg[0] = reg[0] + 0 = 1
addi 1,2,1 ; f2 = reg[1] = reg[2] + 1 = 1
addi 2,0,0;  n = reg[0] + 0 = 0
addi 3,0,8 ; Niter = reg[3] = reg[0] + 8 = 8
nop
nop
nop
nop
nop
nop
j 6     (i = 11)
nop 
nop
nop
nop
nop
addi 4,0,10 
nop
nop
*/

`include "Parameters.vh"

module test_bench_TOP();

//TOP Inputs
reg clk,reset,start,tx_start;
reg [`WORD_WIDTH-1:0] tx_in;
//TOP Output
wire tx_done ;     //Flag to know when to load next instruction

//TOP variable
reg [`INST_WIDTH-1:0] ram [`INST_MEMORY_DEPTH-1:0]  ;
integer i;
integer j;

always #`CLK_PERIOD clk = !clk;

initial
begin

reset = 1'b1;       //Reset processor
clk = 1'b0;
tx_start = 1'b0;
start = 1'b0;

@(posedge clk) #1;
reset = 1'b0;
@(posedge clk) #1;

$readmemh("out.coe",ram,0);         
i = 0;
j=0 ;

while(ram[i] == ram[i])                 //Load out.coe instructions to instruction memory
    begin
        while(j<`INST_WIDTH/`WORD_WIDTH)
             begin
             tx_in = ( ram[i] >> (j*`WORD_WIDTH) );
             tx_start = 1'b1;
             @(negedge tx_done)tx_start = 1'b0;
             #10000;
             j = j + 1;
             end
              i = i + 1 ;
              j = 0;
          end

//Start processor, end of instruction loader
tx_start = 1'b0;
start = 1'b1;
@(posedge clk);
@(posedge clk);
i=1;
while(i<24)
    begin
        @(posedge clk);
        i = i+1 ;
    end
    
$finish;
end

TOP top_top
(
    .clk(clk),
    .reset(reset),
    .start(start),
    .tx_start(tx_start),
    .tx_in(tx_in),
    .tx_done(tx_done)
);


endmodule
