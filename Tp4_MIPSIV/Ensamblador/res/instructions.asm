addi 0,1,5 ; reg[0] = reg[1] + 5 
addi 1,2,4 ; reg[1] = reg[2] + 4
addi 2,3,3 ; reg[2] = reg[3] + 3
addi 3,4,2 ; reg[3] = reg[4] + 2
addi 4,5,1 ; reg[4] = reg[5] + 1
nop
nop
nop
nop
nop
add 0,0,1; add rd,rs,rt ; rd = rs + rt = reg[0] = reg[0] + reg[1] = 9
add 1,0,1; add rd,rs,rt ; rd = rs + rt = reg[1] = reg[0] + reg[1] = 9 + 4 = 13      (caso 1a)
add 2,0,2; add rd,rs,rt ; rd = rs + rt = reg[2] = reg[0] + reg[2] = 9 + 3 = 12      (caso 2a)
add 3,3,2; add rd,rs,rt ; rd = rs + rt = reg[3] = reg[3] + reg[2] = 2 + 12 = 14     (caso 1b)
add 4,4,2; add rd,rs,rt ; rd = rs + rt = reg[4] = reg[4] + reg[2] = 1 + 12 = 13     (caso 2b)
nop
nop
nop
nop
nop
nop
