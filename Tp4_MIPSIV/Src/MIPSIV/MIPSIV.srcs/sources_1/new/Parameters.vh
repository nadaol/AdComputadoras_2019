
//Default Lengths in bits
//Instruction related
`define INST_WIDTH 32        //Instructions width
`define OPCODE_WIDTH 6              //Instruction opcode segment width
`define FUNCTION_WIDTH 6            //Instruction function segment width
`define RS_WIDTH 5
`define RT_WIDTH 5
`define RD_WIDTH 5
`define OFFSET_WIDTH 16
`define INST_INDEX_WIDTH 26
`define SA_WIDTH 5
`define PC_WIDTH $clog2(`INST_MEMORY_DEPTH)
//registers
`define REGISTERS_WIDTH 32          //Registers memory width
`define REGISTERS_DEPTH 32          //Registers memory depth
//data memory
`define DATA_MEMORY_WIDTH 32          //Registers memory width
`define DATA_MEMORY_DEPTH 256          //Registers memory depth
//instr memory
`define INST_MEMORY_WIDTH 32          //Registers memory width
`define INST_MEMORY_DEPTH 64          //Registers memory depth (clog2(INST_MEMORY_DEPTH) = Pc width = instr_memory_Addr_width)
//alu control
`define ALU_CONTROL_WIDTH 4         //ALUCODE width
`define ALUOP_WIDTH 3               //alu_control_opcode (alu operation code) width 

//Instruction segments,start bits
`define OPCODE_SBIT 26
`define RS_SBIT 21
`define RT_SBIT 16
`define RD_SBIT 11
`define OFFSET_SBIT 0
`define INST_INDEX_SBIT 0
`define FUNCTION_SBIT 0
`define SA_SBIT 6

//Default general values
`define BAUD_RATE   19200          //Frequency of Uart transmition/reception (defined in Baud_rate generator module)
`define FREC_CLOCK_MHZ 100         //Frequency of clock in Mhz for Baud_rate_generator module
`define WORD_WIDTH 8               //Word width for uart transmition/reception in bits
`define STOP_BIT_COUNT  1          //Bit count for stop signal (0)
`define BIT_RESOLUTION  16         //Used to generate correct baudrate and sample bits in 'BIT_RESOLUTION' ticks on tx/rx modules
`define PC_ADDER_VALUE 'b1
`define CLK_PERIOD      10      //Periodo generador de clk en unidad especificada en timescale (100Mhz) para testbenches

//Codes to select operation in Alu module (alu_control_opcode)
`define SLL         'b0000         //Shift left logical (r2<<r1)
`define SRL         'b0001         //Shift right logical (r2>>r1)
`define SRA         'b0010        //Shift right arithmetic (r2>>>r1)
`define ADD         'b0011        //Sum (r1+r2)
`define SUB         'b0100       //Substract (r1-r2)
`define AND         'b0101       //Logical and (r1&r2)
`define OR          'b0110       //Logical or (r1|r2)
`define XOR         'b0111       //Logical xor (r1^r2)
`define NOR         'b1000      //Logical nor ~(r1|r2)
`define SLT         'b1001      //Compare (r1<r2)
`define SLL16       'b1010      //Shift left logical,2 bytes (r2<<16)

//Respective instruction type codes to map I-type & J-type Instructions to 'alu_control_opcode'(alu operation) in Alu_control module
`define RTYPE_ALUCODE                   'b000//for RTYPE instructions ,map to ARITH operation ,specified in function segment of instruction
`define LOAD_STORE_ADDI_ALUCODE         'b001//for load/store and ADDI ,instructions map to ADD operation
`define ANDI_ALUCODE                    'b010//for ANDI instruction ,map to AND operation
`define ORI_ALUCODE                     'b011//for ORI instruction ,map to OR operation
`define XORI_ALUCODE                    'b100//for XORI instruction ,map to XOR operation
`define LUI_ALUCODE                     'b101//for LUI instruction ,map to SLL16 operation
`define SLTI_ALUCODE                    'b110//for SLTI instruction ,map to SLT operation (comparation)
`define BRANCH_ALUCODE                  'b111//for BRANCH instructions ,map to SUB operation

// Respective opCode of instructions to manage control signals in Control module
`define R_TYPE_OPCODE   'b000000   //R-type instructions operations maps to RTYPE_ALUCODE
`define LB_OPCODE       'b100000   //I-type instructions opcodes
`define LH_OPCODE       'b100001   //Loads/stores/Addi maps to LOAD_STORE_ADDI_ALUCODE
`define LW_OPCODE       'b100011
`define LWU_OPCODE      'b100111
`define LBU_OPCODE      'b100100
`define LHU_OPCODE      'b100101
`define SB_OPCODE       'b101000
`define SH_OPCODE       'b101001
`define SW_OPCODE       'b101011
`define ADDI_OPCODE     'b001000
`define ANDI_OPCODE     'b001100    //maps to ANDI_ALUCODE in Control module
`define ORI_OPCODE      'b001101    //maps to ORI_ALUCODE
`define XORI_OPCODE     'b001110    //maps to XORI_ALUCODE
`define LUI_OPCODE      'b001111    //maps to LUI_ALUCODE
`define SLTI_OPCODE     'b001010    //maps to BRANCH_ALUCODE
`define BEQ_OPCODE      'b000100        
`define BNE_OPCODE      'b000101
`define J_OPCODE        'b000010   //J-type instructions opcodes, do not map to any alu operation since alu module is not used
`define JAL_OPCODE      'b000011   

 //Function codes to map R-type instructions to 'alu_control_opcode'(alu operation) in Alu_control module
`define SLL_FUNCTIONCODE   'b000000
`define SRL_FUNCTIONCODE   'b000010
`define SRA_FUNCTIONCODE   'b000011
`define SRLV_FUNCTIONCODE  'b000100
`define SRAV_FUNCTIONCODE  'b000110
`define ADD_FUNCTIONCODE   'b000111
`define SLLV_FUNCTIONCODE  'b100001
`define SUB_FUNCTIONCODE   'b100011
`define AND_FUNCTIONCODE   'b100100
`define OR_FUNCTIONCODE    'b100101
`define XOR_FUNCTIONCODE   'b100110
`define NOR_FUNCTIONCODE   'b100111
`define SLT_FUNCTIONCODE   'b101010