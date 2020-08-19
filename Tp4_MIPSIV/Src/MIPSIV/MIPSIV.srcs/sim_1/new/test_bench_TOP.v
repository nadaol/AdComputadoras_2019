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

/*
addi 0,1,5 ; reg[0] = reg[1] + 5 
nor 1,1,1 ; reg[1] = reg[1] nor reg[1] (0000 00000 nor 0000 0000 = 1111 1111)
addi 2,2,10 ; reg[2] = reg[2] + 10 
sw 0,10(0) ; memory[reg[0] + 10] = reg[0] 
addi 0,0,5 ; reg[0] = reg[0] + 5
lw 2,10(0); reg[2] = memory[reg[10]+0]
sub 3,0,2 ; reg[3] = reg[0] - reg[2]
srl 4,3,2 ; reg[4] = reg[3] >> 2
sw  0,11(1) ;memory[reg[11] + 1] = reg[0] 
sw  1,12(2) ;memory[reg[12] + 2] = reg[1]
beq 4,3,2 ; if(reg[3]==reg[4])jump pc+2
j 6 ; jump 6
slt 5,3,4 ; reg[5]=(reg[3]<reg[4])
jalr 6,2 ; reg[6] = return address  ; jump reg[2]
srav 7,3,0 ; reg[3] >> reg[0]
xori 8,6,7 ; reg[8] = reg[6] xori reg[7]
sw  2,12(3) ;memory[reg[12] + 3] = reg[2] 
sw  3,12(4) ;memory[reg[12] + 4] = reg[3] 
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
@(posedge clk);//In IF
@(posedge clk);//In ID
@(posedge clk);//In EX
@(posedge clk);//In MEM 
@(posedge clk);//In WB (Write register)
@(posedge clk)
@(posedge clk)//In MEM sw
@(posedge clk)
@(posedge clk)
@(posedge clk)
@(posedge clk)
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
