addi $1, $zero, 5		#$1=5
addi $2, $zero, 3		#$2=3
sll $zero,  $zero, 0
sll $zero,  $zero, 0
sll $zero,  $zero, 0
sll $zero,  $zero, 0
add $9, $1, $2 		#$9=8
addi $3, $zero, 1		#$3=1
addu $4, $zero, $2	#$4=2
addiu $5, $9, 0		#$5=8
sub $4, $1, $2 		#$4=2
subu $9, $zero, $3	#9=-1
mul $5, $1, $2		#$5=15
and $6, $1, $2		#$6=1
andi $7, $1, 15		#$7=101
or $8, $1, $2			#$8= 111
ori $9, $1, 15			#$9=1111
xor $4, $1, $2		#$4= 110
xori $5, $1, 15		#$5=101
nor $6, $1, $2		#$6=??????
lb $4,  0($1)			#$4=mem[1]
lh $5, 0($1)			#$5=mem[1]
lw $6, 0($1)			#$6=mem[1]
lbu $7,0($1)			#$7=mem[1]
lhu $8, 0($1)		#$8=mem[1]
add $5, $zero, $zero 	#$5=0
add $6, $zero, $zero #$6=0
addi $8, $zero, 8 		#$8=8
addi $9, $zero, 12	#$9=12
add $7, $zero, $zero #$7=0
sb $5, 0($1)			#mem[1]=$5
sh $6, 0($8)			#mem[2]=$6
sw $7, 0($9)			#mem[3]=$7
addi $3, $zero, 0xFFFF #$3 = x0000FFFF
slt $4, $2, $1			#$4= 1 
slti $5, $2, 15		#$5=1
sltiu $6, $zero, -1		#$6=0
sltu $7, $zero, $2 	#$7=1
sll $4, $3, 2			#$4= x00FFFF00
addi $4, $zero, 2		#$4=2
srl $5, $3, 2			#$5= x000000FF
sra $6, $3, 2			#$6= x000000FF
sllv $7, $3, $4		#$7= x00FFFF00
add $3, $zero, $zero 	#$3=0
srlv $8, $3, $4		#$8=x000000FF
srav $9, $3, $4		#$9=x000000FF
lui $3, 0xABCD

addi $4, $zero, -1
p0:
bgezal $3, p7
sll $zero, $zero, 0

p1:
j p3
sll $zero, $zero, 0
p2:
bne $1, $zero, p5
sll $zero, $zero, 0

 p3:
bgez $1, p2
sll $zero, $zero, 0

p4:
jal p0
sll $zero, $zero, 0

p5:
blez $zero, p4
sll $zero, $zero, 0

p6: 
 bltz $4, p8
 sll $zero, $zero, 0

p7:
bltzal $zero, p6
sll $zero, $zero, 0

p8:
bgtz $3, p10
sll $zero, $zero, 0

p9:
jalr $3, $2
sll $zero, $zero, 0

p10:
beq $zero, $zero, p9
sll $zero, $zero, 0

p11:
jr $3
sll $zero, $zero, 0

