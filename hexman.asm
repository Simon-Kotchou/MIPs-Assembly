#Author: Simon Kotchou
#Date: 11/6/2019

.data

promptMessage: .asciiz "Enter the input for Hexman: "
invalidInput: .asciiz "Invalid Hexman input! \n"
startStr: .asciiz "Starting Hexman with: "
newLine: .asciiz "\n"
promptDecimal: .asciiz "Enter decimal in range [A,F]hex: "
invalidRange: .asciiz "Number is not in range!\n"
hexStr: .asciiz "Hexstring: "
livesStr: .asciiz "Lives remaining: "
winStr: .asciiz "You won!\n"
loseStr: .asciiz "You lost!\n"
space: .asciiz " "

.text

main:

li $v0, 4				#Printing prompt to console
la $a0, promptMessage
syscall

li $v0, 5
syscall		 	#Reading signed integer from user
move $a0, $v0		#Putting it into argument reg for testValid

move $s0, $a0             #Saving input value into s0 because will be altered in testValid
li $s1, 8		#Counter for testValid

jal testValid			#jumps and links to test if input is valid for hexman
				#returns with 1 or 0 in $v0
beqz $v0, LoopInvalidInput	#if $v0 is 0, test failed and loops back to main

li $v0, 4				#prints message to console			
la $a0, startStr
syscall

li $v0, 34				#prints hex representation of valid input back to user
move $a0, $s0
syscall

li $v0, 4				#prints message to console			
la $a0, newLine
syscall

li $s1, 3                           #holds users number of lives in s1
li $s3, 0                           #initializes the hexstring to be compared with target 
li $s4, 8				#counter for checkHexBit
li $s5, 0				#initial hexnumber that will be added to when user guesses correct bits

j mainGameLoop

testValid:			#loop that tests validity of user input

beqz $s1, testPass		#if counter gets to 0 (tests all 8 hex bits) without test failing, test passed
addi $s1, $s1, -1		#counter - 1
  
andi $t1, $a0, 0xf              #ands with 0xf immediate to get last hex bit in number and saves to temp reg
srl $a0, $a0, 4                #shifts input number to right 4 to get to next hex bit in number

ble $t1, 9, testFail			#if the last hex bit is less than or equal to 9, test fails

j testValid			#loops back to test next hex bit if test doesnt fail

testPass:			#if test passes returns 1 to main in $v0
li $v0, 1
jr $ra

testFail:			#if test fails returns 0 to main in $v0		
li $v0, 0
jr $ra

LoopInvalidInput:
li $v0, 4				#Printing invalid message to console
la $a0, invalidInput
syscall

j main					#loops back to main until input is valid

mainGameLoop:

beqz $s1, gameLost				#if number of lives is 0, the game is lost

li $v0, 4					#prompts unsigned integer from user
la $a0, promptDecimal
syscall

li $v0, 5					#reads integer
syscall

move $a0, $v0					#moves it to arguments reg for testNumRange

move $s2, $a0					#moves it to saved reg s2

jal testNumRange				#jumps and links to testNumRange

beqz $v0, LoopInvalidRange			#testNumRange will return with 1 or 0 in $v0, if 0 the test failed and will loop back to mainGameLoop after printing message

move $a0, $s0					#moves target hexnumber to arguments register to input to checkHexBit

jal checkHexBit						#jumps and links to checkHexBit

beq $s3, $s0, gameWon					#if the target number is equal to the number that is the accumulation of the users guesses, the game is won by the user

j mainGameLoop						#if game is not won, will loop back to mainGameLoop

testNumRange:						
ble $a0, 9, testFail						#tests if the inputted int is less than or equal to 9, and if so the test fails
bgt $a0, 15, testFail						#tests if the inputted int is greater than 15, and if so the test fails
b testPass							#if both tests above pass, then the test has passed

LoopInvalidRange:		
li $v0, 4				#Printing invalid message to console
la $a0, invalidRange
syscall

j mainGameLoop					#loops back to mainGameLoop if invalid input range

checkHexBit:

beqz $s4, testExit				#if counter (originally equal to 8) is 0, then the test exits
addi $s4, $s4, -1				#decrements counter

andi $t0, $a0, 0xf				#gets the first bit in target hexnumber
srl $a0, $a0, 4					#then shifts right 4 bits to next hexbit in target

bne $t0, $s2, checkHexBit			#if the first hexbit in the target is not equal to the user guessed number, will loop back to checkHexBit until all 8 bits are checked

addi $s5, $s5, 1				#if a hexbit matches that of one in the target hexnumber, will add 1 to flag to tell program to not decrement life points later

addi $t2, $s4, -7				#adds -7 to current counter, so that if counter is at 7, will shift left 0 times in hexnumber of user guesses, and other numbers will have negative amount of hexbits to shift to when adding to hexnumber of user guesses
mul $t2, $t2, -4				#multiplies by -4 to calculated number above to get the shift amount 
sllv $t3, $s2, $t2				#shifts user inputted number left by shift amount calculated above to then add to user guessed hexnumber
or $s3, $s3, $t3				#uses bitwise or to add the guessed hexbit in the correct position calculated above

j checkHexBit					#loops back to checkHexBit until all 8 bits are checked

testExit:
beqz $s5, lifeDecrement				#if the flag from checkHexBit is 0, then the guess was wrong, and will branch to lifeDecrement
li $s5, 0					#reinitializes counter and flag to respected immediates
li $s4, 8

li $v0, 4							#prints text to console
la $a0, hexStr
syscall

li $v0, 34						#prints the users current guessed hexnumber to console in hexidecimal representation		
move $a0, $s3
syscall

li $v0, 4							#prints a space to console
la $a0, space
syscall

li $v0, 4						#prints text to console		
la $a0, livesStr
syscall

li $v0, 1						#prints the users current number of lives
move $a0, $s1
syscall

li $v0, 4					#newline
la $a0, newLine
syscall

jr $ra						#returns back to mainGameLoop

lifeDecrement:
addi $s1, $s1, -1				#decrements life points
addi $s5, $s5, 1					#sets flag to 1 so that will not decrement again when jumping back to testExit
j testExit

gameLost:
li $v0, 4						#prints the losing string to console			
la $a0, loseStr
syscall

li $v0, 10						#exits program		
syscall

gameWon:
li $v0, 4					#prints winning string to console		
la $a0, winStr
syscall

li $v0, 10					#exits program			
syscall