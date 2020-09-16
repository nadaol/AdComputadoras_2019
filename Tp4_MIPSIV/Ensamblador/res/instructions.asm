addi 0,1,2 ; reg[0] = reg[1] + 2 = 2
addi 1,0,2 ; reg[1] = reg[0] + 2 = 4
addi 2,1,3 ; reg[2] = reg[1] + 3 = 7
addi 5,2,2 ; reg[5] = reg[2] + 2 = 9
sw 0,2(5) ; SW rt, offset(base) ; memory[reg[5] + 2] ← rt ; memory[11]  = reg[0] = 2 
lw 3,2(5) ; reg[3] = memory[reg[5] + 2] = 2
add 4,3,5 ; reg[4] = reg[3] + reg[5] = 11