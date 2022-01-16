#Author: Simon Kotchou
.data 

prompt: .asciiz "Enter a positive integer: "
step: .asciiz "Step: "
N: .asciiz ", N = "
step0: .asciiz "Step: 0"
nLine: .asciiz "\n"

.text
.globl main

main:

li $v0, 4
la $a0, prompt
syscall											#prompting user input

li $v0, 5
syscall											#getting an int into v0

move $a0, $v0										#moving v0 into a0 for argument of binDcmp
jal binDcmp										#jumping and linking into binDcmp

li $v0,10
syscall										#Exiting program

binDcmp:

addi $sp, $sp, -8							#adjusting stack pointer, loading argument into s0 and s0 into stack as well as return address
sw $ra, 4($sp)
move $s0, $a0
sw $s0, 0($sp)

bne $a0, 1, else									#if argument is not 1
	
addi $sp, $sp, 8								#if it is then adjust stack pointer 

move $t1, $a0								#print current step and current N
li $v0, 4
la $a0, step0
syscall

li $v0, 4
la $a0, N
syscall
li $v0,1
move $a0, $t1
syscall
li $v0, 4
la $a0, nLine
syscall

li $v0, 1								#return 1

jr $ra							#jump return

else:

rem $t0, $a0, 2							#puts remainder of a0/2 into t0

bnez $t0, else2							#if the remainder is not 0

srl $a0, $a0, 1								#if it is then divides a0 by 2 and passes that a0 as argument back into binDcmp using jal
jal binDcmp

lw $s0, 0($sp)								#when returned from recursive call, loads the current N and return address from stack
lw $ra, 4($sp)
addi $sp, $sp, 8

move $t0, $v0							#prints current step fron v0 and current N from s0
li $v0, 4
la $a0, step
syscall
li $v0, 1
move $a0, $t0
syscall

li $v0, 4
la $a0, N
syscall
li $v0,1
move $a0, $s0
syscall
li $v0, 4
la $a0, nLine
syscall

move $v0, $t0							#adds 1 to the step, and returns that step in v0
addi $v0, $v0 ,1
jr $ra

else2:

addi $a0, $a0, -1						#adds -1 to current N
jal binDcmp								#uses a0 as argument and jumps to binDcmp

lw $s0, 0($sp)
lw $ra, 4($sp)							#does same as first else above
addi $sp, $sp, 8

move $t0, $v0
li $v0, 4
la $a0, step
syscall
li $v0, 1
move $a0, $t0
syscall

li $v0, 4
la $a0, N
syscall
li $v0,1
move $a0, $s0
syscall
li $v0, 4
la $a0, nLine
syscall

move $v0, $t0
addi $v0, $v0 , 1
jr $ra

