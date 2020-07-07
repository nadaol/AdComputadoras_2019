`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.07.2020 20:12:09
// Design Name: 
// Module Name: Control
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

/*Control signals
    regDst          Selects the write address to registers memory : either 15-11 bits(rd) or 16-20 bits (rt) of instruction
    ALUsrc          Selects second operand of alu : either read_data_2 from register or sign extended 0-15 bits (32 bit immediate) of instruction 
    RegWrite        Selects the write enable of registers memory
    MemtoReg        Selects the write data to registers memory : either data readed from data memory or alu result
    MemRead         Selects read enable of data memory
    MemWrite        Selects write enable of data memory
    Branch          Goes to an and gate along whith zero flag of alu to select the PC next value : either PC+1 (next instruction) or PC+1+(32bit immediate)(branch taken)
    AluOp[2:0]      Selects instruction type codes that goes to alu_control module which then takes care of select respective alu operation to alu module
*/

module Control
(
       input [`OPCODE_WIDTH - 1 : 0] opcode,
       output reg regDst,
       output reg Branch,
       output reg RegWrite,
       output reg ALUSrc,
       output reg [`ALU_CONTROL_WIDTH - 1 : 0] AluOp,
       output reg MemRead,
       output reg MemWrite,
       output reg MemtoReg   
    );
    
//Combinational output logic
    always@(*)
    begin
    case(opcode)
    //Register-type instructions
    `R_TYPE_OPCODE : 
    begin
        regDst = 1;
        ALUSrc = 0;
        RegWrite = 1;
        MemtoReg = 0;
        MemRead = 0;
        MemWrite = 0;
        Branch = 0;
        AluOp = `RTYPE_ALUCODE ;
    end
    //Immediate-type instructions
   `LB_OPCODE  : 
   begin
        regDst =0;
        ALUSrc = 1;
        MemtoReg = 1;
        RegWrite = 1;
        MemRead = 1;
        MemWrite = 0;
        Branch = 0;
        AluOp = `LOAD_STORE_ADDI_ALUCODE ; 
    end
    
   `LH_OPCODE  : 
   begin
        regDst =0;
        ALUSrc = 1;
        MemtoReg = 1;
        RegWrite = 1;
        MemRead = 1;
        MemWrite = 0;
        Branch = 0;
        AluOp = `LOAD_STORE_ADDI_ALUCODE ; 
    end
    
   `LW_OPCODE  : 
   begin
        regDst =0;
        ALUSrc = 1;
        MemtoReg = 1;
        RegWrite = 1;
        MemRead = 1;
        MemWrite = 0;
        Branch = 0;
        AluOp = `LOAD_STORE_ADDI_ALUCODE ; 
    end
    
   `LWU_OPCODE  : 
   begin
        regDst =0;
        ALUSrc = 1;
        MemtoReg = 1;
        RegWrite = 1;
        MemRead = 1;
        MemWrite = 0;
        Branch = 0;
        AluOp = `LOAD_STORE_ADDI_ALUCODE ; 
    end
     
   `LBU_OPCODE  : 
   begin
        regDst =0;
        ALUSrc = 1;
        MemtoReg = 1;
        RegWrite = 1;
        MemRead = 1;
        MemWrite = 0;
        Branch = 0;
        AluOp = `LOAD_STORE_ADDI_ALUCODE ; 
    end
    
   `LHU_OPCODE  : 
   begin
        regDst =0;
        ALUSrc = 1;
        MemtoReg = 1;
        RegWrite = 1;
        MemRead = 1;
        MemWrite = 0;
        Branch = 0;
        AluOp = `LOAD_STORE_ADDI_ALUCODE ; 
    end
    
   `SB_OPCODE  : 
   begin
        regDst = 0;
        ALUSrc = 1;
        MemtoReg = 0;
        RegWrite = 0;
        MemRead = 0;
        MemWrite = 1;
        Branch = 0;
        AluOp = `LOAD_STORE_ADDI_ALUCODE ; 
    end
    
   `SW_OPCODE  : 
   begin
        regDst = 0;
        ALUSrc = 1;
        MemtoReg = 0;
        RegWrite = 0;
        MemRead = 0;
        MemWrite = 1;
        Branch = 0;
        AluOp = `LOAD_STORE_ADDI_ALUCODE ; 
    end
    
   `ADDI_OPCODE  : 
   begin
        regDst = 0;
        ALUSrc = 1;
        MemtoReg = 0;
        RegWrite = 1;
        MemRead = 0;
        MemWrite = 0;
        Branch = 0;
        AluOp = `LOAD_STORE_ADDI_ALUCODE ; 
    end
       
   `ANDI_OPCODE  : 
   begin
        regDst = 0;
        ALUSrc = 1;
        MemtoReg = 0;
        RegWrite = 1;
        MemRead = 0;
        MemWrite = 0;
        Branch = 0;
        AluOp = `ANDI_ALUCODE ; 
    end
    
   `ORI_OPCODE  : 
   begin
        regDst = 0;
        ALUSrc = 1;
        MemtoReg = 0;
        RegWrite = 1;
        MemRead = 0;
        MemWrite = 0;
        Branch = 0;
        AluOp = `ORI_ALUCODE ; 
    end
    
   `XORI_OPCODE : 
   begin
        regDst = 0;
        ALUSrc = 1;
        MemtoReg = 0;
        RegWrite = 1;
        MemRead = 0;
        MemWrite = 0;
        Branch = 0;
        AluOp = `XORI_ALUCODE ; 
    end
    
    
   `LUI_OPCODE  : 
   begin
        regDst = 0;
        ALUSrc = 1;
        MemtoReg = 0;
        RegWrite = 1;
        MemRead = 0;
        MemWrite = 0;
        Branch = 0;
        AluOp = `LUI_ALUCODE ; 
    end
    
   `SLTI_OPCODE  : 
   begin
        regDst = 0;
        ALUSrc = 1;
        MemtoReg = 0;
        RegWrite = 1;
        MemRead = 0;
        MemWrite = 0;
        Branch = 0;
        AluOp = `SLTI_ALUCODE ; 
    end
    
   `BEQ_OPCODE  : 
   begin
        regDst = 0;
        ALUSrc = 1;
        MemtoReg = 0;
        RegWrite = 1;
        MemRead = 0;
        MemWrite = 0;
        Branch = 0;
        AluOp = `BRANCH_ALUCODE ; 
    end
    
   `BNE_OPCODE  : 
   begin
        regDst = 0;
        ALUSrc = 1;
        MemtoReg = 0;
        RegWrite = 0;
        MemRead = 0;
        MemWrite = 0;
        Branch = 0;
        AluOp = `BRANCH_ALUCODE ; 
    end

   `J_OPCODE  : 
   begin
        regDst = 0;
        ALUSrc = 0;
        MemtoReg = 0;
        RegWrite = 0;
        MemRead = 0;
        MemWrite = 0;
        Branch = 0;
    end
    
   `JAL_OPCODE  : 
   begin
        regDst = 1;
        ALUSrc = 0;
        MemtoReg = 0;
        RegWrite = 1;
        MemRead = 0;
        MemWrite = 0;
        Branch = 0;
    end
    
    default :
    begin
        regDst = 0;
        ALUSrc = 0;
        MemtoReg = 0;
        RegWrite = 0;
        MemRead = 0;
        MemWrite = 0;
        Branch = 0;
    end        
    endcase
    end
endmodule
