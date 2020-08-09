addi 0,1,5 ; reg[0] = reg[1] + 5 
sw 0,10(0) ; memory[reg[10] + 0] = reg[0] 
addi 0,0,5 ; reg[0] = reg[0] + 5
lw 2,10(0); reg[2] = memory[reg[10]+0]
sub 3,0,2 ; reg[3] = reg[0] - reg[2]
srl 4,3,2 ; reg[4] = reg[3] >> 2
beq 4,3,2 ; if(reg[3]==reg[4])jump pc+2
j 6 ; jump 6
slt 5,3,4 ; reg[5]=(reg[3]<reg[4])
jalr 6,2 ; reg[6] = return address  ; jump reg[2]
srav 7,3,0 ; reg[3] >> reg[0]
xori 8,6,7 ; reg[8] = reg[6] xori reg[7]