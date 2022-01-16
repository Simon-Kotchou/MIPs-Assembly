#Author: Simon Kotchou
#Date: 9/25/2019

.data
	
	prompt1: .asciiz "Enter an integer: "
	result0s: .asciiz "Number of 0's: "
	result1s: .asciiz "Number of 1's: "
	newLine: .asciiz "\n"

.text

	main:
	
	addi $v0, $zero, 4
	la $a0, prompt1
	syscall
	
	addi $v0, $zero, 5
	syscall
	
	addi $t0, $zero, 0			#For counter
	addi $t1, $zero, 32			#For maximum
	move $a0, $v0				#moving inputted value into a0
	li $s0, 0				#0's counter
	li $s1, 0				#1's counter

loop:
	andi $t2, $a0, 1			#getting the first bit
	srl $a0, $a0, 1				#shifting to the right one bit
	beq $t2, 1, if1				#if first bit is 1 then jump to if1
	beqz $t2, if0				#if 0 jump to if0
return:
	addi $t0, $t0, 1			#increment counter
	beq $t0, $t1, exit			#once loop has run 32 times exits
	j loop

if0:   
	addi $s0, $s0, 1			#increments 0's counter 
	j return
if1:   
	addi $s1, $s1, 1			#increments 1's counter
	j return	
	
exit: 
	addi $v0, $zero, 4
	la $a0, result0s
	syscall
	
	addi $v0, $zero, 1
	move $a0, $s0
	syscall
	
	addi $v0, $zero, 4
	la $a0, newLine
	syscall
	
	la $a0, result1s
	syscall
	
	addi $v0, $zero, 1
	move $a0, $s1
	syscall
	
	addi $v0, $zero, 10
	syscall