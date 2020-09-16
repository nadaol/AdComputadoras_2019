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
addi 0,1,2 ; reg[0] = reg[1] + 2 = 2
addi 1,0,2 ; reg[1] = reg[0] + 2 = 4
addi 2,1,3 ; reg[2] = reg[1] + 3 = 7
addi 5,2,2 ; reg[5] = reg[2] + 2 = 9
sw 0,2(5) ; SW rt, offset(base) ; memory[reg[5] + 2] ? rt ; memory[11]  = reg[0] = 2 
lw 3,2(5) ; reg[3] = memory[reg[5] + 2] = 2
add 4,3,5 ; reg[4] = reg[3] + reg[5] = 11
*/
//
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
//
 
//Start processor, end of instruction loader
//clk_exec();
tx_start = 1'b0;
start = 1'b1;
@(posedge clk);
@(posedge clk);
i=1;
while(i<120)
    begin
        //clk_exec();
        @(posedge clk);
        i = i + 1;
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

//Sends a step_code by uart for a clk execution
task clk_exec;
    begin : clk_exec
        tx_in = `STEP_BY_STEP_CODE;
         tx_start = 1'b1;
         @(negedge tx_done)tx_start = 1'b0;
         #10000;
         tx_in = 'h00;
         tx_start = 1'b1;
         @(negedge tx_done)tx_start = 1'b0;
         #10000;
    end
endtask


endmodule
