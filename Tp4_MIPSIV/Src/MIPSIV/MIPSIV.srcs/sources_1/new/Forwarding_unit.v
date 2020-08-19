`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.07.2020 16:59:07
// Design Name: 
// Module Name: Forwarding_unit
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

module Forwarding_unit(
//inputs
input [`RT_WIDTH - 1 :0] ID_EX_rt,
input [`RS_WIDTH - 1 :0] ID_EX_rs,
input [`RD_WIDTH - 1 :0] MEM_WB_rd,
input [`RD_WIDTH - 1 :0] EX_MEM_rd,
input MEM_WB_RegWrite,EX_MEM_RegWrite,
//outputs
output reg[1:0] operand1_hazard,
output reg[1:0] operand2_hazard
    );
    
 //Forwarding conditions
 always@(*)
 begin
 
 if((EX_MEM_RegWrite == 0 && MEM_WB_RegWrite == 0))
 begin
        operand1_hazard = 'b0;
        operand2_hazard = 'b0;
 end

/*
    1a. EX/MEM.RegisterRd = ID/EX.RegisterRs
    2a. MEM/WB.RegisterRd = ID/EX.RegisterRs
*/

    if (EX_MEM_rd == ID_EX_rs && EX_MEM_RegWrite)
    begin
        operand1_hazard = 'b1;
    end
    else if (MEM_WB_rd == ID_EX_rs && MEM_WB_RegWrite)
    begin
        operand1_hazard = 'b10;    
    end
    else
    begin
        operand1_hazard = 'b0;    
    end
    
/*
    1b. EX/MEM.RegisterRd = ID/EX.RegisterRt
    2b. MEM/WB.RegisterRd = ID/EX.RegisterRt
*/
    
    if (EX_MEM_rd == ID_EX_rt && EX_MEM_RegWrite)
    begin
       operand2_hazard = 'b0;   // Para probar , cambiar a 1 -----------------
    end
    else if (MEM_WB_rd == ID_EX_rt && MEM_WB_RegWrite) 
    begin
        operand2_hazard = 'b10;       
    end  
    else
    begin
        operand2_hazard = 'b0;    
    end  

end

endmodule
