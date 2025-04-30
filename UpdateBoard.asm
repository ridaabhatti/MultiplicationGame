#Term Project: Multiplication Game
#Author: Ridaa Bhatti
#Date: 04/26/2025
#Location: UTD

.extern board 144				# Reference external array 'board'
.extern owner 144				# Reference external array 'owner' 
.extern last_player_val 4			# Reference external word to store last player number
.extern last_computer_val 4			# Reference external word to store last computer number

.data						# Begin data segment
debug_msg: .asciiz "Captured product!\n" 	# Message to print when a product is successfully captured


.text						# Begin code section
.globl UpdateBoard				# Make UpdateBoard subroutine accessible to other files
UpdateBoard:					# Start of UpdateBoard subroutine
    # Arguments:
    # $a0 = first selected number
    # $a1 = second selected number
    # $a2 = player ID (1 = player, 2 = computer)

    # Calculate product = a0 * a1
    mul $t0, $a0, $a1   			# $t0 = product

    # Save last move values (optional for strategies later)
    li $t7, 1					# Load 1 into $t7
    beq $a2, $t7, save_player_move		# If $a2 == 1 (player), jump to save_player_move

    li $t7, 2					# Load 2 into $t7
    beq $a2, $t7, save_computer_move		# If $a2 == 2 (computer), jump to save_computer_move

continue_search:				# Label to continue search for the product in the board array
    # Search for product in board array
    la $t1, board      				# Load address of board into $t1
    la $t2, owner     				# Load address of owner into $t2
    li $t3, 0          				# Initialize index counter to 0

search_loop:					# Loop to search for product match in board

    lw $t4, 0($t1)    				# Load current board[i] value into $t4

    beq $t0, $t4, found_match   		# If product matches board[i], go to found_match

    addi $t1, $t1, 4    			# Move to next element in board
    addi $t2, $t2, 4    			# Move to corresponding next element in owner
    addi $t3, $t3, 1    			# Increment index

    li $t5, 36          			# Load 36 cells
    blt $t3, $t5, search_loop			# If index < 36, continue loop

    jr $ra					# If no match found, return from subroutine

found_match:					# Label if product is found in board
    sw $a2, 0($t2)      			# Set owner[i] = player ID
    li $v0, 4					# Load syscall code for print_string
    la $a0, debug_msg				# Load address of "Captured product!" message
    syscall					# Print the message to console
    jr $ra					# Return from subroutine

save_player_move:				# Label to store player's selected numbers
    la $t8, last_player_val			# Load address of last_player_val
    sw $a0, 0($t8)				# Store player’s number ($a0)
    la $t8, last_computer_val			# Load address of last_computer_val
    sw $a1, 0($t8)				# Store computer’s number ($a1)

    j continue_search				# Continue to product search

save_computer_move:				# Label to store computer's selected numbers
    la $t8, last_player_val			# Load address of last_player_val
    sw $a1, 0($t8)				# Store player’s number ($a1)
    la $t8, last_computer_val			# Load address of last_computer_val
    sw $a0, 0($t8)				# Store computer’s number ($a0)
    j continue_search				# Continue to product search
