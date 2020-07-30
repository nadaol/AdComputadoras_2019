addi 9, 9, 5
addi 9, 9, 15 
sw 9, 0(0)
addi 10, 10, 3
sw 10, 4(0)
lw 1, 0(0)
lw 2, 4(0)
add 11, 1, 2
sub 12, 1, 2
sw 11, 8(0)
sw 12, 12(0)
beq 1,1,3 
lw 3, 8(0)
lw 4, 12(0)
addi 8, 8, 4
lw 5, 0(8)