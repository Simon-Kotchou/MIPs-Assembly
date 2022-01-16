#Author: Simon Kotchou

.data 
prompt1: .asciiz "Enter the first number: "
prompt2: .asciiz "Enter the second number: "
result: .asciiz "Result: "

.text

main:

addi $v0, $zero, 4
la $a0, prompt1
syscall

addi $v0, $zero, 5
syscall

add $t0, $zero, $v0

addi $v0, $zero, 4
la $a0, prompt2
syscall

addi $v0, $zero, 5
syscall

add $t1, $zero, $v0

addi $v0, $zero, 4
la $a0, result
syscall

add $a0, $t0, $t1

addi $v0, $zero, 1
syscall

addi $v0, $zero, 10
syscall

