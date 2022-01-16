#Author: Simon Kotchou
#Date: 12/4/2019

.data

PromptA: .asciiz "Enter a: "
PromptB: .asciiz "Enter b: "
PromptC: .asciiz "Enter c: "
ResultX: .asciiz "X: "
ResultY: .asciiz "Y: "
NoSol: .asciiz "No possible solutions"
newLine: .asciiz "\n"

.text

main:

li $v0, 4			#printing prompt for a
la $a0, PromptA
syscall

li $v0, 5			#getting int from console
syscall
move $s0, $v0

li $v0, 4
la $a0, PromptB			#printing prompt for b
syscall

li $v0, 5			#getting int from console
syscall
move $s1, $v0

li $v0, 4
la $a0, PromptC			#printing prompt for c
syscall

li $v0, 5
syscall
move $s2, $v0				#Now have a = s0, b = s1, c = s2

li $s3, 0				#X
li $s4, 0				#Y

j findSolutions				#jumps to find solutions

findSolutions:

move $a0, $s0				#puts a and b into argument registers
move $a1, $s1

abs $a0, $a0				#a = a0
abs $a1, $a1				#b = a1
					#takes absolute values of both arguments
jal GCD					#jal to GCD label

lw $s3, 0($sp)				#loads X and Y into s3 and s4 from stack
lw $s4, 4($sp)
addi $sp, $sp, 8			#adjusts sp

rem $t0, $s2, $v0			#Modulus c % g 

bnez $t0, false				#if the result of mod is not zero, will branch to false

div $t0, $s2, $v0			#calculating c / g

mul $s3, $s3, $t0			#multiplying X and Y by result above
mul $s4, $s4, $t0

bltz $s0, xNeg				#Checking if x needs to be negative

bltz $s1, yNeg				#Checking if y needs to be negative

j true					#jumps to true if neither will be converted to negative

GCD:

addi $sp, $sp, -4		#adjusts sp
sw $ra, 0($sp)			#pushes ra

beqz $a0, ExitGCD		#if argument a is 0, will exit. Is recursive base case

addi $sp, $sp, -8		#adjusts sp
sw $a0, 4($sp)			#pushes a and b to stack 
sw $a1, 0($sp)

move $t0, $a0			#moves a to temp reg
rem $a0, $a1, $a0		#modulus b%a into argument reg a
move $a1, $t0			#previous a into argument reg b

jal GCD				#jal back to GCD until hits base case

lw $t1, 0($sp)			#When returning from recursive call...
lw $t2, 4($sp)			#will pop x,y,a,b, and ra from stack
lw $t3, 8($sp)
lw $t4, 12($sp)
lw $ra, 16($sp)
addi $sp, $sp, 20		#adjusts sp

div $t0, $t3, $t4		#calculating new X by first dividing b by a
mul $t0, $t0, $t1		#then multiplying by X0 from stack
sub $t0, $t2, $t0		#then subtracting y0 from stack by the number	

addi $sp, $sp, -8		#adjusts sp
sw $t0, 0($sp)			#pushes X and Y to stack
sw $t1, 4($sp)

jr $ra				#returns with v0 from jal return as v0

ExitGCD:

li $t0, 0			#x = 0, y = 1
li $t1, 1

lw $ra, 0($sp)			#pop the ra from stack
addi $sp, $sp, 4		#adjust sp

addi $sp, $sp, -8		#adjust sp
sw $t0, 0($sp)			#store x and y onto stack
sw $t1, 4($sp)

move $v0, $a1			#return b in v0

jr $ra				#jump return


xNeg:

mul $s3, $s3, -1		#makes x negative, and checks if y needs to be negative as well
bltz $s1, yNeg
j true				#else will branch to true

yNeg:

mul $s4, $s4, -1		#makes y negative then branches to true
j true

true:

li $v0, 4			#prints result X string
la $a0, ResultX
syscall

li $v0, 1			#prints X 
move $a0, $s3
syscall

li $v0, 4			#\n
la $a0, newLine
syscall

li $v0, 4			#prints result Y string
la $a0, ResultY
syscall

li $v0, 1			#prints Y
move $a0, $s4
syscall

li $v0, 10			#Exits program
syscall

false:

li $v0, 4			#prints no solution string
la $a0, NoSol
syscall

li $v0, 10			#Exits program
syscall


