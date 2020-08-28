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
    pcSrc           Selects next program counter value : either pc + 1 , pc + offset + 1 , rs , inst_index
    regDst          Selects the write address to registers memory : either 15-11 bits(rd) or 16-20 bits (rt) of instruction
    AluSrc          Selects second operand of alu : either read_data_2 from register or sign extended 0-15 bits (32 bit immediate) of instruction 
    RegWrite        Selects the write enable of registers memory
    MemtoReg        Selects the write data to registers memory : either data readed from data memory or alu result
    MemRead         Selects read enable of data memory
    MemWrite        Selects write enable of data memory
    Branch          Goes to an and gate along whith zero flag of alu to select the PC next value : either PC+1 (next instruction) or PC+1+(32bit immediate)(branch taken)
    AluOp[2:0]      Selects instruction type codes that goes to alu_control module which then takes care of select respective alu operation to alu module
*/
`include "Parameters.vh"

module Control
(
        //inputs
       input [`OPCODE_WIDTH - 1 : 0] opcode,
       input [`FUNCTION_WIDTH -1 :0] Function,
       //input control signals
       input [`REGISTERS_WIDTH -1 : 0] Alu_result,
       input Zero_in,Branch_in,
       input control_enable,
       //output control signals
       output reg [1:0] regDst,
       output reg Branch,
       output reg RegWrite,
       output reg [1:0]AluSrc,pc_src,
       output reg [`ALUOP_WIDTH - 1 : 0] AluOp,
       output reg MemRead,
       output reg MemWrite,
       output reg [1:0] MemtoReg,
       //To flush ID,EX instructions when branch is taken
       output reg IF_ID_reset,
       output reg ID_EX_reset
    );
    
//Combinational output logic
    always@(*)
    
    //If branch is taken flush  previus ID,EX instructions
    if(Branch_in && Zero_in)
    begin
    IF_ID_reset = 1 ;
    ID_EX_reset = 1 ;
    pc_src = 2'b01;             //IF (PC <= PC + offset + 1)
    RegWrite = 1'b0;            //ID
    AluSrc = 2'b00;             //EX
    AluOp = `RTYPE_ALUCODE ;
    regDst = 2'b00;
    MemRead = 1'b0;             //MEM
    MemWrite = 1'b0;
    Branch = 1'b0;
    MemtoReg = 2'b00;           //WB
    end
   
    else if(control_enable)
    begin
    case(opcode)
    //Register-type instructions
    `R_TYPE_OPCODE : 
    begin
        case(Function)
            `SLL_FUNCTIONCODE  : 
             begin
                pc_src = 2'b00;             //IF
                RegWrite = 1'b1;            //ID
                AluSrc = 2'b11;             //EX
                AluOp = `RTYPE_ALUCODE ;
                regDst = 2'b01;
                MemRead = 1'b0;             //MEM
                MemWrite = 1'b0;
                Branch = 1'b0;
                MemtoReg = 2'b01;           //WB
              end
			`SRL_FUNCTIONCODE  : 
             begin
                pc_src = 2'b00;             //IF
                RegWrite = 1'b1;            //ID
                AluSrc = 2'b00;             //EX
                AluOp = `RTYPE_ALUCODE ;
                regDst = 2'b01;
                MemRead = 1'b0;             //MEM
                MemWrite = 1'b0;
                Branch = 1'b0;
                MemtoReg = 2'b01;           //WB
              end
			`SRA_FUNCTIONCODE  : 
             begin
                pc_src = 2'b00;             //IF
                RegWrite = 1'b1;            //ID
                AluSrc = 2'b00;             //EX
                AluOp = `RTYPE_ALUCODE ;
                regDst = 2'b01;
                MemRead = 1'b0;           //MEM
                MemWrite = 1'b0;
                Branch = 1'b0;
                MemtoReg = 2'b01;           //WB
              end
			`SRLV_FUNCTIONCODE : 
             begin
                pc_src = 2'b00;             //IF
                RegWrite = 1'b1;            //ID
                AluSrc = 2'b00;             //EX
                AluOp = `RTYPE_ALUCODE ;
                regDst = 2'b01;
                MemRead = 1'b0;            //MEM
                MemWrite = 1'b0;
                Branch = 1'b0;
                MemtoReg = 2'b01;           //WB
              end
			`SRAV_FUNCTIONCODE : 
             begin
                pc_src = 2'b00;             //IF
                RegWrite = 1'b1;            //ID
                AluSrc = 2'b00;             //EX
                AluOp = `RTYPE_ALUCODE ;
                regDst = 2'b01;
                MemRead = 1'b0;             //MEM
                MemWrite = 1'b0;
                Branch = 1'b0;
                MemtoReg = 2'b01;           //WB
              end
			`ADD_FUNCTIONCODE  : 
             begin
                pc_src = 2'b00;             //IF
                RegWrite = 1'b1;            //ID
                AluSrc = 2'b00;             //EX
                AluOp = `RTYPE_ALUCODE ;
                regDst = 2'b01;
                MemRead = 1'b0;             //MEM
                MemWrite = 1'b0;
                Branch = 1'b0;
                MemtoReg = 2'b01;           //WB
              end
			`SLLV_FUNCTIONCODE : 
             begin
                pc_src = 2'b00;             //IF
                RegWrite = 1'b1;            //ID
                AluSrc = 2'b00;             //EX
                AluOp = `RTYPE_ALUCODE ;
                regDst = 2'b01;
                MemRead = 1'b0;             //MEM
                MemWrite = 1'b0;
                Branch = 1'b0;
                MemtoReg = 2'b01;           //WB
              end
			`SUB_FUNCTIONCODE  : 
             begin
                pc_src = 2'b00;             //IF
                RegWrite = 1'b1;            //ID
                AluSrc = 2'b00;             //EX
                AluOp = `RTYPE_ALUCODE ;
                regDst = 2'b01;
                MemRead = 1'b0;             //MEM
                MemWrite = 1'b0;
                Branch = 1'b0;
                MemtoReg = 2'b01;           //WB
              end
			`AND_FUNCTIONCODE  : 
             begin
                pc_src = 2'b00;             //IF
                RegWrite = 1'b1;            //ID
                AluSrc = 2'b00;             //EX
                AluOp = `RTYPE_ALUCODE ;
                regDst = 2'b01;
                MemRead = 1'b0;             //MEM
                MemWrite = 1'b0;
                Branch = 1'b0;
                MemtoReg = 2'b01;           //WB
              end
			`OR_FUNCTIONCODE   : 
             begin
                pc_src = 2'b00;             //IF
                RegWrite = 1'b1;            //ID
                AluSrc = 2'b00;             //EX
                AluOp = `RTYPE_ALUCODE ;
                regDst = 2'b01;
                MemRead = 1'b0;             //MEM
                MemWrite = 1'b0;
                Branch = 1'b0;
                MemtoReg = 2'b01;           //WB
              end
			`XOR_FUNCTIONCODE  : 
             begin
                pc_src = 2'b00;             //IF
                RegWrite = 1'b1;            //ID
                AluSrc = 2'b00;             //EX
                AluOp = `RTYPE_ALUCODE ;
                regDst = 2'b01;
                MemRead = 1'b0;             //MEM
                MemWrite = 1'b0;
                Branch = 1'b0;
                MemtoReg = 2'b01;           //WB
              end
			`NOR_FUNCTIONCODE  : 
             begin
                pc_src = 2'b00;             //IF
                RegWrite = 1'b1;            //ID
                AluSrc = 2'b00;             //EX
                AluOp = `RTYPE_ALUCODE ;
                regDst = 2'b01;
                MemRead = 1'b0;             //MEM
                MemWrite = 1'b0;
                Branch = 1'b0;
                MemtoReg = 2'b01;           //WB
              end
			`SLT_FUNCTIONCODE  : 
             begin
                pc_src = 2'b00;             //IF
                RegWrite = 1'b1;            //ID
                AluSrc = 2'b00;             //EX
                AluOp = `RTYPE_ALUCODE ;
                regDst = 2'b01;
                MemRead = 1'b0;             //MEM
                MemWrite = 1'b0;
                Branch = 1'b0;
                MemtoReg = 2'b01;           //WB
              end
 			`JALR_FUNCTIONCODE  : 
             begin
                pc_src = 2'b11;             //IF
                RegWrite = 1'b1;            //ID
                //AluSrc = 2'b11;           //EX
                //AluOp = `RTYPE_ALUCODE ;
                regDst = 2'b01;
                MemRead = 1'b0;             //MEM
                MemWrite = 1'b0;
                Branch = 1'b0;
                MemtoReg = 2'b10;           //WB
              end  
			`JR_FUNCTIONCODE  : 
             begin
                pc_src = 2'b11;             //IF
                RegWrite = 1'b0;            //ID
                //AluSrc = 2'b11;           //EX
                //AluOp = `RTYPE_ALUCODE ;
                //regDst = 2'b01;
                MemRead = 1'b0;             //MEM
                MemWrite = 1'b0;
                Branch = 1'b0;
                //MemtoReg = 2'b01;         //WB
              end                       
        endcase
    end
    //Immediate-type instructions
   `LB_OPCODE  : 
   begin
        pc_src = 2'b00;             //IF
        RegWrite = 1'b1;            //ID
        AluSrc = 2'b10;             //EX
        AluOp = `LOAD_STORE_ADDI_ALUCODE ;
        regDst = 2'b00;
        MemRead = 1'b1;             //MEM
        MemWrite = 1'b0;
        Branch = 1'b0;
       MemtoReg = 2'b00;           //WB
    end
    
   `LH_OPCODE  : 
   begin
        pc_src = 2'b00;             //IF
        RegWrite = 1'b1;            //ID
        AluSrc = 2'b10;             //EX
        AluOp = `LOAD_STORE_ADDI_ALUCODE ;
        regDst = 2'b00;
        MemRead = 1'b1;             //MEM
        MemWrite = 1'b0;
        Branch = 1'b0;
       MemtoReg = 2'b00;           //WB
    end
    
   `LW_OPCODE  : 
   begin
        pc_src = 2'b00;             //IF
        RegWrite = 1'b1;            //ID
        AluSrc = 2'b10;             //EX
        AluOp = `LOAD_STORE_ADDI_ALUCODE ;
        regDst = 2'b00;
        MemRead = 1'b1;             //MEM
        MemWrite = 1'b0;
        Branch = 1'b0;
       MemtoReg = 2'b00;           //WB
    end
    
   `LWU_OPCODE  : 
   begin
        pc_src = 2'b00;             //IF
        RegWrite = 1'b1;            //ID
        AluSrc = 2'b10;             //EX
        AluOp = `LOAD_STORE_ADDI_ALUCODE ;
        regDst = 2'b00;
        MemRead = 1'b1;             //MEM
        MemWrite = 1'b0;
        Branch = 1'b0;
       MemtoReg = 2'b00;           //WB
    end
     
   `LBU_OPCODE  : 
   begin
        pc_src = 2'b00;             //IF
        RegWrite = 1'b1;            //ID
        AluSrc = 2'b10;             //EX
        AluOp = `LOAD_STORE_ADDI_ALUCODE ;
        regDst = 2'b00;
        MemRead = 1'b1;             //MEM
        MemWrite = 1'b0;
        Branch = 1'b0;
        MemtoReg = 2'b00;           //WB 
    end
    
   `LHU_OPCODE  : 
   begin
        pc_src = 2'b00;             //IF
        RegWrite = 1'b1;            //ID
        AluSrc = 2'b10;             //EX
        AluOp = `LOAD_STORE_ADDI_ALUCODE ;
        regDst = 2'b00;
        MemRead = 1'b1;             //MEM
        MemWrite = 1'b0;
        Branch = 1'b0;
        MemtoReg = 2'b00;           //WB
    end
    
   `SB_OPCODE  : 
   begin
        pc_src = 2'b00;             //IF
        RegWrite = 1'b0;            //ID
        AluSrc = 2'b10;             //EX
        AluOp = `LOAD_STORE_ADDI_ALUCODE ;
        //regDst = 2'b00;
        MemRead = 1'b0;             //MEM
        MemWrite = 1'b1;
        Branch = 1'b0;
        //MemtoReg = 2'b01;           //WB
    end
    
   `SH_OPCODE  : 
   begin
        pc_src = 2'b00;             //IF
        RegWrite = 1'b0;            //ID
        AluSrc = 2'b10;             //EX
        AluOp = `LOAD_STORE_ADDI_ALUCODE ;
        //regDst = 2'b00;
        MemRead = 1'b0;             //MEM
        MemWrite = 1'b1;
        Branch = 1'b0;
       // MemtoReg = 2'b01;           //WB
    end
    
   `SW_OPCODE  : 
   begin
        pc_src = 2'b00;             //IF
        RegWrite = 1'b0;            //ID
        AluSrc = 2'b10;             //EX
        AluOp = `LOAD_STORE_ADDI_ALUCODE ;
        //regDst = 2'b00;
        MemRead = 1'b0;             //MEM
        MemWrite = 1'b1;
        Branch = 1'b0;
        //MemtoReg = 2'b01;           //WB
    end
    
   `ADDI_OPCODE  : 
   begin
        pc_src = 2'b00;             //IF
        RegWrite = 1'b1;            //ID
        AluSrc = 2'b10;             //EX
        AluOp = `LOAD_STORE_ADDI_ALUCODE ;
        regDst = 2'b00;
        MemRead = 1'b0;             //MEM
        MemWrite = 1'b0;
        Branch = 1'b0;
        MemtoReg = 2'b01;           //WB
    end
       
   `ANDI_OPCODE  : 
   begin
        pc_src = 2'b00;             //IF
        RegWrite = 1'b1;            //ID
        AluSrc = 2'b10;             //EX
        AluOp = `ANDI_ALUCODE ;
        regDst = 2'b00;
        MemRead = 1'b0;             //MEM
        MemWrite = 1'b0;
        Branch = 1'b0;
        MemtoReg = 2'b01;           //WB
    end
    
   `ORI_OPCODE  : 
   begin
        pc_src = 2'b00;             //IF
        RegWrite = 1'b1;            //ID
        AluSrc = 2'b10;             //EX
        AluOp = `ORI_ALUCODE ;
        regDst = 2'b00;
        MemRead = 1'b0;             //MEM
        MemWrite = 1'b0;
        Branch = 1'b0;
        MemtoReg = 2'b01;           //WB
    end
    
   `XORI_OPCODE : 
   begin
        pc_src = 2'b00;             //IF
        RegWrite = 1'b1;            //ID
        AluSrc = 2'b10;             //EX
        AluOp = `XORI_ALUCODE ;
        regDst = 2'b00;
        MemRead = 1'b0;             //MEM
        MemWrite = 1'b0;
        Branch = 1'b0;
        MemtoReg = 2'b01;           //WB
    end
    
    
   `LUI_OPCODE  : 
   begin
        pc_src = 2'b00;             //IF
        RegWrite = 1'b1;            //ID
        AluSrc = 2'b10;             //EX
        AluOp = `LUI_ALUCODE ;
        regDst = 2'b00;
        MemRead = 1'b0;             //MEM
        MemWrite = 1'b0;
        Branch = 1'b0;
        MemtoReg = 2'b01;           //WB
    end
    
   `SLTI_OPCODE  : 
   begin
        pc_src = 2'b00;             //IF
        RegWrite = 1'b1;            //ID
        AluSrc = 2'b10;             //EX
        AluOp = `SLTI_ALUCODE ;
        regDst = 2'b00;
        MemRead = 1'b0;             //MEM
        MemWrite = 1'b0;
        Branch = 1'b0;
        MemtoReg = 2'b01;           //WB
    end
    
   `BEQ_OPCODE  : 
   begin
        //pc_src = 2'b00;            //IF 
        RegWrite = 1'b0;            //ID
        AluSrc = 2'b00;             //EX
        AluOp = `BEQ_ALUCODE ;
        //regDst = 2'b00;
        MemRead = 1'b0;             //MEM
        MemWrite = 1'b0;
        Branch = 1'b1;
       //MemtoReg = 2'b01;           //WB
    end
    
   `BNE_OPCODE  : 
   begin
        //pc_src = 2'b00;             //IF
        RegWrite = 1'b0;            //ID
        AluSrc = 2'b00;             //EX
        AluOp = `BNE_ALUCODE ;
        //regDst = 2'b00;
        MemRead = 1'b0;             //MEM
        MemWrite = 1'b0;
        Branch = 1'b1;
        //MemtoReg = 2'b01;           //WB
    end

   `J_OPCODE  : 
   begin
        pc_src = 2'b10;             //IF
        RegWrite = 1'b0;            //ID
        //AluSrc = 2'b11;             //EX
        //AluOp = `BRANCH_ALUCODE ;
        //regDst = 2'b00;
        MemRead = 1'b0;             //MEM
        MemWrite = 1'b0;
        Branch = 1'b0;
        //MemtoReg = 2'b01;           //WB
    end
    
   `JAL_OPCODE  : 
   begin
        pc_src = 2'b10;             //IF
        RegWrite = 1'b1;            //ID
        //AluSrc = 2'b11;             //EX
        //AluOp = `BRANCH_ALUCODE ;
        regDst = 2'b10;//register 31
        MemRead = 1'b0;            //MEM
        MemWrite = 1'b0;
        Branch = 1'b0;
        MemtoReg = 2'b10;           //WB
    end

    default :
   begin
        pc_src = 2'b00;             //IF
        RegWrite = 1'b0;            //ID
        AluSrc = 2'b00;             //EX
        AluOp = 'b0 ;
        regDst = 2'b00;
        MemRead = 1'b0;            //MEM
        MemWrite = 1'b0;
        Branch = 1'b0;
        MemtoReg = 2'b00;           //WB
    end  
    endcase
    end
    //Insert stall
    //If control_enable = 0 , all control signals 0's
   else
   begin
        pc_src = 2'b00;             //IF
        RegWrite = 1'b0;            //ID
        AluSrc = 2'b00;             //EX
        AluOp = 'b0 ;
        regDst = 2'b00;
        MemRead = 1'b0;            //MEM
        MemWrite = 1'b0;
        Branch = 1'b0;
        MemtoReg = 2'b00;           //WB
    end        
endmodule
