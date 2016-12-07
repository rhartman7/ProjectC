addi $1, $zero, 5		#$1=5
addi $2, $zero, 3		#$2=3
add $9, $1, $2 		#$9=8
addi $3, $zero, 9		#$3=9
sub $4, $9, $1 		#$4=3
mul $5, $4, $3		#$5=24
addi $1, $zero, 7		#$1=7
addi $2, $zero, 3		#$2=3
and $6, $2, $1		#$6=3
andi $7, $1, 7	  	#$7= 7 !!!!!!!!!!!!!!!!!!!!!!!!!
or $8, $7, $6			#$8= 7
ori $9, $8, 3			#$9=7
addi $1, $zero, 7		#$1=7
addi $2, $zero, 3		#$2=3
xor $4, $1, $2		#$4= 4
xori $5, $4, 3		#$5=7
nor $6, $4, $5		#$6=8
addi $1, $zero, 5		#$1=5
addi $2, $zero, 3		#$2=3
slt $4, $2, $1			#$4= 1 
slti $5, $2, 15		#$5=1
sltiu $6, $5, -1  		#$6=1
sltu $7, $6, $2  		#$7=1
addi $3, $zero, 65535 	#$3 = x0000FFFF
sll $4, $3, 2				#$4= x00FFFF00
addi $5, $zero, 65535 	#$5 = x0000FFFF
srl $6, $5, 2				#$6= x000000FF
addi $7, $zero, 65535 	#$7= x0000FFFF
sra $8, $7, 2				#$8= x000000FF
addi $4, $zero, 2			#$4=2
addi $3, $zero, 65535 	#$3 = x0000FFFF
sllv $7, $3, $4			#$7= x00FFFF00
addi $5, $zero, 65535 	#$5 = x0000FFFF
srlv $8, $5, $4			#$8=x000000FF
addi $7, $zero, 65535 	#$7 = x0000FFFF
srav $9, $7, $4			#$9=x000000FF
add $3, $zero, $zero 		#$3=x00000000
lui $3, 0xABCD 			#$3=xABCD


addi $3, $zero, 5		#$3=5
lb $4,  0($3)			#$4=??????????/
lh $5, 0($3)			#$5=0000000, 00000001
addi $4, $zero, 5	 	#4=5
lw $6, 0($4) 		#$6=0000001
addi $3, $zero, 5		#$3=5
lbu $7,0($3)			#$7=mem[1]
lhu $8, 0($3)		#$8=mem[1]
addi $3, $zero, 5  	#$3=5
sb $5, 0($3)			#mem[1] = $5
addi $4, $zero, 8 		#$4=8
sh $6, 0($4)			#mem[2]=$6
addi $8, $zero, 12	#$8=12
sw $7, 0($8)			#mem[3]=$7


p0:
bgezal $3, p7
sll $zero, $zero, 0

p1:
j p3

p2:
bne $1, $zero, p5
sll $zero, $zero, 0

 p3:
bgez $1, p2
sll $zero, $zero, 0

p4:
jal p0

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

p10:
beq $zero, $zero, p9
sll $zero, $zero, 0

p11:
jr $3

