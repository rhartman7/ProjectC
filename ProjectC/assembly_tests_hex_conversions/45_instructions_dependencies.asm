addi $1, $zero, 5		#$1=5
addi $2, $zero, 3		#$2=3
add $9, $1, $2 		#$9=8
addi $3, $zero, 9		#$3=9
sub $4, $9, $1 		#$4=3
mul $5, $4, $3		#$5=24
addi $1, $zero, 7		#$1=7
addi $2, $zero, 3		#$2=3
and $6, $2, $1		#$6=3
andi $7, $1, 7	  		#$7= 7
or $8, $7, $6			#$8= 7
ori $9, $8, 3			#$9=15
addi $1, $zero, 7		#$1=7
addi $2, $zero, 3		#$2=3
xor $4, $1, $2			#$4= 4
xori $5, $4, 3			#$5=7
nor $6, $4, $5		#$6=8
addi $1, $zero, 5		#$1=5
addi $2, $zero, 3		#$2=3
slt $4, $2, $1		#$4= 1 
slti $5, $2, 15		#$5=1
sltiu $6, $5, -1  #$6=0
sltu $7, $6, $2  #$7=0
addi $3, $zero, 0xFFFF #$3 = x0000FFFF
sll $4, $3, 2		#$4= x00FFFFFF
addi $3, $zero, 0xFFFF #$3 = x0000FFFF
srl $5, $3, 2		#$5= xFFFFFF00
addi $3, $zero, 0xFFFF #$3 = x0000FFFF
sra $6, $3, 2		#$6= x11FFFFFF
addi $4, $zero, 2	#$4=2
addi $3, $zero, 0xFFFF #$3 = x0000FFFF
sllv $7, $3, $4		#$7= x00FFFFFF
srlv $8, $3, $4	#$8=xFFFFFF00
srav $9, $3, $4	#$9=x11FFFFFF
add $3, $zero, $zero #$1=x00000000
lui $3, 0xABCD

add $5, $zero, $zero 	#$5=0
add $6, $zero, $zero #$6=0
add $7, $zero, $zero #$7=0
addi $3, $zero, x1234 #$1=xABCD1234
lb $4,  0($3)
lh $5, 0($3)
lw $6, 0($3)
addi $3, $zero, -1		#$3=-1
lbu $7,0($3)			
lhu $8, 0($3)
sb $5, 0($3)		#$5=x00000034
sh $6, 0($3)		#$6=x00001234
sw $7, 0($3)		#$7=xABCD1234


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

