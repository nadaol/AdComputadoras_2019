addi 0,1,5 ; reg[0] = reg[1] + 5 
addi 1,2,4 ; reg[1] = reg[2] + 4
addi 2,3,3 ; reg[2] = reg[3] + 3
addi 3,4,2 ; reg[3] = reg[4] + 2
addi 4,5,1 ; reg[4] = reg[5] + 1	(reg[0]=5)
nop
nop
nop	
nop	
nop
sw 1,3(5);SW rt, offset(base) ; memory[base+offset] ← rt ; memory[3] =  reg[1] = 4
nop
nop
nop
nop	
nop
lw 6,3(5);LW rt, offset(base) ; rt ← memory[base+offset] ; reg[6] = memory[3] = 4
add 7,6,2 ; reg[7] = reg[6] + reg[2] = 7