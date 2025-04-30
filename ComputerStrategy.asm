#Term Project: Multiplication Game
#Author: Ridaa Bhatti
#Date: 04/26/2025
#Location: UTD

.data				# Begin data section
board: .space 144		# Reserve 144 bytes 
last_player_val: .word 0	# Store the last number selected by the player

.text				# Begin code section
.globl ComputerMove		# Make the ComputerMove subroutine globally accessible
ComputerMove:			# Start of ComputerMove subroutine
    lw $t0, last_player_val  	# Load the player's last selected number into $t0
    li $t1, 1                	# Initialize computer candidate number ($t1 = 1)

try_loop:			# Start of loop to try values 1 to 9
    beq $t1, $t0, skip       	# If $t1 == player's number, skip it 

    # product = $t1 * $t0
    mul $t2, $t1, $t0		# Multiply computer's number and player's number → $t2 = product
    addi $t2, $t2, -1		# Convert to 0-based index (product - 1)

    # row = product / 6
    # col = product % 6
    li $t3, 6			# Load divisor 6
    div $t2, $t3		# Divide product index by 6
    mflo $t4    		# Move quotient to $t4 → row index
    mfhi $t5    		# Move remainder to $t5 → column index

# Calculate board index: index = row * 6 + col
    mul $t6, $t4, 6		# $t6 = row * 6
    add $t6, $t6, $t5		# $t6 = index = row*6 + col
    mul $t6, $t6, 4		# Multiply index by 4 to convert to byte offset

    la $t7, board		# Load base address of board array into $t7
    add $t7, $t7, $t6		# Add offset to get address of target cell
    lw $t8, 0($t7)		# Load value at that cell into $t8

    beqz $t8, found_move     	# If empty, accept this move

skip:				# Skip current value
    addi $t1, $t1, 1		# Increment computer's candidate number
    ble $t1, 9, try_loop	# If still in range (1–9), repeat loop

    li $v0, 1  			# If no move found, fallback default move is 1
    jr $ra			# Return from subroutine with result in $v0

found_move:			# Label for successful move
    move $v0, $t1		# Move selected computer number into return value $v0
    jr $ra			# Return from subroutine
