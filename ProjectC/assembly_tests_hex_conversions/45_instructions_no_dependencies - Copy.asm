addi $1, $zero, 5		#$1=5
addi $2, $zero, 3		#$2=3
sll $zero,  $zero, 0
sll $zero,  $zero, 0
sll $zero,  $zero, 0
sll $zero,  $zero, 0
add $9, $1, $2 		#$9=8
addi $3, $zero, 1		#$3=1
addu $4, $zero, $2	#$4=3
addiu $5, $9, 0		#$5=8
sub $4, $1, $2 		#$4=2
subu $9, $zero, $3		#9=-1
mul $5, $1, $2		#$5=15
and $6, $1, $2		#$6=1
andi $7, $1, 15		#$7=101
or $8, $1, $2			#$8= 111
ori $9, $1, 15			#$9=1111
xor $4, $1, $2			#$4= 110
xori $5, $1, 15		#$5=101
nor $6, $1, $2		#$6=??????
addi $3, $zero, 2882343476 #$1=xABCD1234
lb $4,  0($3)
lh $5, 0($3)
lw $6, 0($3)
addi $3, $zero, -1		#$3=-1
lbu $7,0($3)			
lhu $8, 0($3)
add $5, $zero, $zero 	#$5=0
add $6, $zero, $zero #$6=0
add $7, $zero, $zero #$7=0
sb $5, 0($3)		#$5=x00000034
sh $6, 0($3)		#$6=x00001234
sw $7, 0($3)		#$7=xABCD1234
slt $4, $2, $1		#$4= 1 
slti $5, $2, 15		#$5=1
sltiu $6, $zero, -1
sltu $7, $zero, $3 
addi $3, $zero, 0xFFFFFFFF #$3 = xFFFFFFFF
sll $4, $3, 2		#$4= x00FFFFFF
srl $5, $3, 2		#$5= xFFFFFF00
sra $6, $3, 2		#$6= x11FFFFFF
addi $4, $zero, 2	#$4=2
sllv $7, $3, $4		#$7= x00FFFFFF
srlv $8, $3, $4	#$8=xFFFFFF00
srav $9, $3, $4	#$9=x11FFFFFF
add $3, $zero, $zero #$1=x00000000
lui $3, 0xABCD

addi $4, $zero, -1
p0:
bgezal $3, p7

p1:
j p3

p2:
bne $1, $zero, p5

 p3:
bgez $1, p2

p4:
jal p0

p5:
blez $zero, p4

p6: 
 bltz $4, p8

p7:
bltzal $zero, p6

p8:
bgtz $3, p10

p9:
jalr $3, $2

p10:
beq $zero, $zero, p9

p11:
jr $3

