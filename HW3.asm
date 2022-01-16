#Author: Simon Kotchou
#Date 10/9/2019

.data

prompt: .asciiz "Please enter an integer from 1 to 10: "
message: .asciiz "Max sum in the interval above is: "
arr: .word 7, 25, 12, -1, 25, 18, 15, -17, 34, 15

.text
.globl main

main:

li $a1, 10	# size
la $s0, arr	# base address

li $v0, 4
la $a0, prompt		#Prints prompt to console
syscall

li $v0, 5
syscall			#Obtains user inputted integer
move $s1, $v0

li $t0, 0
li $t2,0
li $t3, 0			#initializing registers to be used in loops
li $s2, -100000
li $t5, -100000

loop1:
bgt $t5, $s2, updateMax		#if the sum calculated from loop2 is greater than max, branches

li $t4, 0			#resets t4 to 0
sll $t1, $t0, 2			#sets starting offset	
bge $t0, $a1, exit		#if t0 (i) greater than length, exits
add $t4, $s1, $t0		#calculates inputted int + i
bgt $t4, $a1, exit		#if inputted int + i greater than length, exits

li $t5, 0			#resets t5 to zero
move $t6, $t0			#initializes t6 (j) to t0 (i)
addi $t0, $t0, 1		#increments i
j loop2				#jumps to inner loop

loop2:
bge $t6, $t4, loop1		#if j >= inputted int + i
add $t2, $t1, $s0		#calculating starting address in array
lw $t3, 0($t2)			#loading value from that address
add $t5, $t5, $t3		#adding to sum
addi $t1, $t1, 4		#adding 4 to offset to go to next element in array
addi $t6, $t6, 1		#incrementing j
j loop2				#looping back until branched

updateMax:
add $s2, $0, $t5		#sets t5 to new max
j loop1				#jumps to loop1
	
exit:

li $v0, 4
la $a0, message			#displays message
syscall

li $v0, 1
move $a0, $s2		#displays calculated max
syscall

li $v0, 10
syscall			#exits program
