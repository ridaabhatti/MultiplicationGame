#Term Project: Multiplication Game
#Author: Ridaa Bhatti
#Date: 04/26/2025
#Location: UTD

.data				# Begin data segment 

board:				# Label for the 6x6 custom game board
    .word 1,2,3,4,5,6		# Row 1
    .word 7,8,9,10,12,14	# Row 2
    .word 15,16,18,20,21,24	# Row 3 
    .word 25,27,28,30,32,35	# Row 4
    .word 36,40,42,45,48,49	# Row 5
    .word 54,56,63,64,72,81	# Row 6

owner:				# Label for array that tracks ownership of each board cell
    .space 144			# Allocate 144 bytes

last_player_val: .word 0	# Stores the last number selected by the player
last_computer_val: .word 0	# Stores the last number selected by the computer

.text				# Begin code segment
InitBoard:			# Procedure to "initialize" board
    jr $ra			# Return from InitBoard subroutine
