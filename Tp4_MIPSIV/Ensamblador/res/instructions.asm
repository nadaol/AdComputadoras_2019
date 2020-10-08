addi 11,2,5 ; reg[11] = reg[2] + 5
addi 0,0,1 ; f1 = reg[0] = reg[0] + 1 = 1
addi 1,2,1 ; f2 = reg[1] = reg[2] + 1 = 1
addi 2,0,0;  n = reg[2] = reg[0] + 0 = 1
addi 3,0,8 ; Niter = reg[3] = reg[0] + 8 = 9
beq 2,3,7 ;  if(n==Niter)jump pc+1+7 (i= 62 )
addi 2,2,1 ; n = n+1
add 4,0,1 ; reg[4] = reg[0] + reg[1]
add 0,0,1 ; f1 = f1 + f2
sub 1,0,1 ; f2 = f1 - f2
jalr 10,11 ; pc = reg[11] , reg[10] = 11       reg[2]= 2(10), 3(17), 5(24),8(31),13(38),21(45),34(52),55(59)
nop ; f1 = 55 ; f2
nop