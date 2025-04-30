#Term Project: Multiplication Game
#Author: Ridaa Bhatti
#Date: 04/26/2025
#Location: UTD

.data					# Begin data segment
last_player_val: .word 0		# Stores the last number selected by the player
last_computer_val: .word 0		# Stores the last number selected by the computer


.text					# Begin text section
.globl ValidateMove			# Make the ValidateMove subroutine globally accessible
ValidateMove:				# Start of ValidateMove subroutine
    li $v0, 1				# Set default return value in $v0 = 1
    blt $a0, 1, invalid			# If selected number < 1, it's invalid → jump to invalid
    bgt $a0, 9, invalid			# If selected number > 9, it's invalid → jump to invalid

    beq $a1, 1, check_vs_computer	# If current player is player 1, go check against computer's last value
    lw $t0, last_player_val		# Load last player move from memory into $t0
    beq $a0, $t0, invalid		# If selected number == last player move, it's invalid
    sw $a0, last_computer_val		# Otherwise, store this as computer's last move
    jr $ra				# Return from subroutine

check_vs_computer:			# Check if player 1 is duplicating computer's last move
    lw $t0, last_computer_val		# Load last computer move into $t0
    beq $a0, $t0, invalid		# If selected number == last computer move, it's invalid
    sw $a0, last_player_val		# Otherwise, store this as player's last move
    jr $ra				# Return from subroutine (move is valid)

invalid:				# Handle invalid move case
    li $v0, 0				# Set return value $v0 = 0 to indicate invalid move
    jr $ra				# Return from subroutine

