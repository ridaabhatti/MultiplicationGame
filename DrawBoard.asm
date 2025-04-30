#Term Project: Multiplication Game
#Author: Ridaa Bhatti
#Date: 04/26/2025
#Location: UTD

.extern board 144						# Reference to external board array
.extern owner 144						# Reference to external owner array

.data								# Begin data section
top_border: .asciiz "+----+----+----+----+----+----+\n"		# Top border of the board
mid_border: .asciiz "+----+----+----+----+----+----+\n"		# Border between rows
bottom_border: .asciiz "+----+----+----+----+----+----+\n"	# Bottom border of the board
left_cell: .asciiz "| "						# Left wall of each row
cell_end: .asciiz "|\n"						# End of row line
space: .asciiz " "						# Single space
two_spaces: .asciiz "  "					# Two spaces
strP: .asciiz "(P)"						# Marker for player's move
strC: .asciiz "(C)"						# Marker for computer's move
newline: .asciiz "\n"						# Newline character

.text								# Begin code section
.globl DrawBoard						# Make DrawBoard globally accessible
DrawBoard:							# Start of the DrawBoard procedure
    la $t0, board						# Load address of board into $t0
    la $t1, owner						# Load address of owner into $t1
    li $t2, 0         						# Initialize row counter

    # Print top border
    li $v0, 4							# Syscall to print string
    la $a0, top_border						# Load address of top border string into $a0
    syscall							# Print top border

row_loop:							# Start of row loop
    li $t3, 0         						# Initialize column counter 

col_loop:							# Start of column loop
    # Print left wall at start of row
    beqz $t3, print_left_wall					# If column is 0, print the left border


skip_left_wall:
    lw $t4, 0($t0)    						# Load current board cell value into $t4
    lw $t5, 0($t1)    						# Load owner value into $t5 

    # Check owner value
    beqz $t5, print_number   					# If owner == 0, print number

    li $t6, 1							# Load 1 into $t6
    beq $t5, $t6, print_player_marker				# If owner == 1, print (P)

    li $t6, 2							# Load 2 into $t6
    beq $t5, $t6, print_computer_marker 			# If owner == 2, print (C)

print_number:							# Print number with appropriate spacing
    # Proper formatting
    blt $t4, 10, one_digit					# If number < 10 → 1 digit
    blt $t4, 100, two_digits					# If number < 100 → 2 digits

one_digit:		 					# Label to print single-digit number
    li $v0, 4							# Syscall to print string
    la $a0, two_spaces						# Load address of "  "
    syscall							# Print two leading spaces

    li $v0, 1							# Syscall to print integer
    move $a0, $t4						# Move number to $a0
    syscall							# Print number

    li $v0, 4							# Syscall to print string
    la $a0, space						# Load address of single space
    syscall							# Print one trailing space
    j after_print						# Jump to after_print to finish cell


two_digits:							# Label to print two-digit number
    li $v0, 4							# Syscall to print string
    la $a0, space						# Load address of " "
    syscall							# Print one leading space

    li $v0, 1							# Syscall to print integer
    move $a0, $t4						# Move number to $a0
    syscall							# Print number

    li $v0, 4							# Syscall to print string
    la $a0, space						# Load address of " "
    syscall							# Print trailing space
    j after_print						# Jump to after_print

print_player_marker:						# Label to print player marker
    li $v0, 4							# Syscall to print string
    la $a0, strP						# Load address of "(P)"
    syscall							# Print player marker
    
    # after (P), print an extra space
    li $v0, 4							# Syscall to print string
    la $a0, space						# Print trailing space for alignment
    syscall 							# Print extra space
    j after_print						# Continue to next cell


print_computer_marker:						# Label to print computer marker
    li $v0, 4							# Syscall to print string
    la $a0, strC						# Load address of "(C)"
    syscall							# Print computer marker
  
    # after (C), print an extra space
    li $v0, 4							# Syscall to print string
    la $a0, space						# Print trailing space for alignment
    syscall 							# Print extra space
    j after_print						# Continue to next cell

after_print:							# Common label after printing a cell
    addi $t0, $t0, 4   						# Move to next board cell
    addi $t1, $t1, 4  						# Move to next owner cell
    addi $t3, $t3, 1   						# Increment column counter

    li $t5, 6							# Load 6 
    blt $t3, $t5, col_loop					# If column < 6, continue column loop

    # End of row
    li $v0, 4							# Syscall to print string
    la $a0, cell_end						# Load address of row-end string
    syscall							# Print closing "|"

    # After row, mid border or bottom border
    addi $t2, $t2, 1						# Increment row counter
    li $t6, 6							# Load total row count
    blt $t2, $t6, print_mid_border				# If not last row, print mid border and loop

    # Last row → bottom border
    li $v0, 4							# Syscall to print string
    la $a0, bottom_border					# Load bottom border string
    syscall							# Print bottom border
    jr $ra							# Return from subroutine

print_mid_border:						# Label to print mid-border between rows
    li $v0, 4							# Syscall to print string
    la $a0, mid_border						# Load mid-border string
    syscall							# Print mid border
    j row_loop							# Jump to start next row

print_left_wall:						# Label to print left wall of row
    li $v0, 4							# Syscall to print string
    la $a0, left_cell						# Load left wall string "| "
    syscall							# Print left wall
    j skip_left_wall						# Continue cell printing
