#Author: Simon Kotchou
#Date: 11/19/2019

.data

prompt: .asciiz "Enter a positive number (0 to quit) : "
result: .asciiz "List of prime numbers: "
space: .asciiz " "

.text
main:

li $s1, 0					#Counter for how many numbers in stack
li $s2, 1					#Flag to print result prompt

j mainLoop

mainLoop:

li $v0, 4					#prompts user for input
la $a0, prompt
syscall

li $v0, 5					#takes in an integer
syscall

beqz $v0, exitPrint				#if the integer is 0 then will exit loop

addi $sp, $sp, -4				#adjusts sp
sw $v0, 0($sp)					#stores the int in the stack
addi $s1, $s1, 1				#increments counter

j mainLoop					#loops back

exitPrint:

beqz $s2, exitLoop				#if the flag is not 1, will go to next loop

li $v0, 4
la $a0, result					#if it is then will print result string
syscall 

addi $s2, $s2, -1				#will adjust flag to be 0

j exitPrint					#loops back

exitLoop:

beqz $s1, exit					#if counter is 0, means no more ints in stack
	
addi $s1, $s1, -1				#decrements counter
	
li $s0, 2					#sets s0 to be 2 for starting i (counter) in psuedofor loop

lw $a0, 0($sp)					#pops int off stack onto a0 reg
addi $sp, $sp, 4				#adjusts sp

mtc1 $a0, $f1					#moves the int to coprocessor
cvt.s.w $f1, $f1				#in coprocessor, converts the int into a single precision float val
sqrt.s $f2, $f1					#stores the sqrt of that float val into f2 reg
cvt.w.s $f2, $f2				#converts float to an single precision int
mfc1 $a1, $f2					#moves the int from the coprocessor into a1 reg

jal primeCheck					#jump and link to primeCheck

beq $v0, -1, exitLoop				#if the returned value in v0 is -1, will loop back to exitLoop

move $a0, $v0					#if not will move v0 to a0 and print the integer, because it is prime
li $v0, 1
syscall

li $v0, 4					#prints a space in console
la $a0, space
syscall 

j exitLoop					#loops back to exitLoop

primeCheck:

bgt $s0, $a1, exitPrime				#if the counter s0 which is initially 2, is greater than the calculated sqrt of the integer, then it is prime

rem $t0, $a0, $s0					#does integer mod the counter and stores into t0 reg

beqz $t0, exitNotPrime				#if the calculated value above is equal to 0, then number is not prime

addi $s0, $s0, 1				#increments counter

j primeCheck					#loops back to primeCheck

exitPrime:

move $v0, $a0				#if the number is prime will return the int in v0 reg
jr $ra

exitNotPrime:

li $v0, -1				#if number is not prime will return -1 in v0 reg
jr $ra	

exit:

li $v0, 10				#exits program
syscall
