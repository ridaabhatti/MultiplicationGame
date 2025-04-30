#Term Project: Multiplication Game
#Author: Ridaa Bhatti
#Date: 04/26/2025
#Location: UTD

.include "SysCalls.asm"		# Include syscall definitions

.text				# Begin code section

.globl PrintStr			# Make PrintStr globally accessible
.globl PrintInt			# Make PrintInt globally accessible
.globl Multiply			# Make Multiply subroutine globally accessible
.globl Rand1to9			# Make Rand1to9 subroutine globally accessible

PrintStr:			# PrintStr: Print a null-terminated string in $a0
    li $v0, SysPrintString	# Load syscall code for printing a string
    syscall			# Perform syscall: print the string 
    jr $ra			# Return to caller

PrintInt:			# Print an integer value in $a0 
    li $v0, SysPrintInt		# Load syscall code for printing an integer
    syscall			# Perform syscall: print the integer
    jr $ra			# Return to caller

Multiply:			# Multiply two integers in $a0 and $a1
    mul $v0, $a0, $a1		# Multiply $a0 * $a1, store result in $v0
    jr $ra			# Return to caller with result in $v0

Rand1to9:			# Generate a random integer between 1 and 9
    li $v0, SysRandIntRange	# Load syscall code for random int in range
    li $a0, 1			# Set lower bound 
    li $a1, 9			# Set upper bound
    syscall			# Perform syscall: result stored in $a0
    jr $ra			# Return to caller with result in $a0

