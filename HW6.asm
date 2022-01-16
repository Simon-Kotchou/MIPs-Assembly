#Author: Simon Kotchou
#Date: 11/13/2019

.data

prompt: .asciiz "Enter the number: "
result: .asciiz "The number of unique digits: "
.space 3							#Aligning the array so it is word aligned
numList: .space 40						#Setting 40 bytes of space in data segment, so can store 10 integers

.text

main:

li $v0, 4
la $a0, prompt						#prompts user for input
syscall

li $v0, 5
syscall 						#takes in user input
move $a0, $v0						#puts input into argument reg

li $s2, 0						#Counter
li $s3, 0							#Num unique integers counter
la $s4, numList						#base address for array
li $s5, 0              				 #array size
li $s6, 0						#temp array size

j loop1						#main jumps to first loop

loop1:

beqz $a0, loop2					#if the inputted word goes to 0 branches to next loop

addi $sp, $sp, -4				#adjusts stack ptr
rem $s1, $a0, 10				#takes the remainder of devision from inputted value and 10 to get a single digit
sw $s1, 0($sp)					#puts the digit into stack

div $a0, $a0, 10				#divides inputted int by 10 using integer division

addi $s2, $s2, 1				#increments counter

j loop1						#loops back to loop1

loop2:

blez $s2, exitProg			#if counter is 0, branches to the end of the program

lw $s1, 0($sp)				#loads a single digit from stack
addi $sp, $sp, 4				#adjusts stack ptr

jal loop3				#jal to loop3

addi $s2, $s2, -1			#decrements counter

j loop2					#loops back to loop2

loop3:

move $s6, $s5				#sets temp counter equal to size of array

j loop4					#jumps to loop4

loop4:

beqz $s6, addNum			#if counter is zero, branches to addNum

lw $t1, 0($s4)				#loads word off array
addi $s4, $s4, 4			#adjusts base address of array
	
addi $s6, $s6, -1			#decrements counter

beq $t1, $s1, exit			#if the int popped off array is equal to digit popped off stack will exit

j loop4					#if not will loop back to loop4

exit:

la $s4, numList				#resets s4 to base address of array

jr $ra					#returns to loop2

addNum:

sw $s1, 0($s4)				#stores the unique digit into the array

la $s4, numList				#resets s4 to the base address of the array

addi $s5, $s5, 1				#increments array size

addi $s3, $s3, 1				#increments counter for amount of unique digits

jr $ra					#returns to loop2

exitProg:

li $v0, 4				#prints text to console
la $a0, result
syscall

li $v0, 1				#prints the amount of unique digits
move $a0, $s3
syscall

li $v0, 10				#exits program
syscall
