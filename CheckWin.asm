#Term Project: Multiplication Game
#Author: Ridaa Bhatti
#Date: 04/26/2025
#Location: UTD

.data					# Begin data section
.extern owner 144			# Reference external owner array

.text					# Begin code section
.globl CheckWin				# Make the CheckWin subroutine accessible from other files
CheckWin:				# Entry point for win condition check
    la $s0, owner  			# Load base address of owner array into $s0

    # Check rows horizontal
    li $t0, 0     			# Initialize row index to 0

check_row_loop:				# Loop label for row-wise checking
    li $t1, 0     			# Initialize column index to 0

row_col_loop:				# Inner loop to check sets of 4 horizontally
    lw $t2, 0($s0)			# Load first cell in current row chunk
    beqz $t2, next_row_col		# If first cell is unclaimed, skip

    lw $t3, 4($s0)			# Load second cell in chunk
    lw $t4, 8($s0)			# Load third cell
    lw $t5, 12($s0)			# Load fourth cell

    bne $t2, $t3, next_row_col		# If not all equal, skip
    bne $t2, $t4, next_row_col		# If not all equal, skip
    bne $t2, $t5, next_row_col		# If not all equal, skip

    # Found 4 in a row horizontally
    move $v0, $t2			# Winner found horizontally → move ID to $v0
    jr $ra				# Return with winner ID

next_row_col:				# Skip to next set of 4 columns
    addi $s0, $s0, 4			# Move pointer to next column
    addi $t1, $t1, 1			# Increment column index
    blt $t1, 3, row_col_loop		# Repeat 3 times for each row

    addi $s0, $s0, 12  			#  Move pointer to start of next row
    addi $t0, $t0, 1			# Increment row counter
    blt $t0, 6, check_row_loop		# Repeat for 6 rows

    # Reset pointer
    la $s0, owner			# Reset pointer for next check

    # Check columns vertical
    li $t0, 0  				# Initialize column index to 0

check_col_loop:				# Outer loop for columns
    li $t1, 0  				# Initialize row index to 0

col_row_loop:				# Inner loop to check 4 vertical cells
    lw $t2, 0($s0)			# Load top cell
    beqz $t2, next_col_row		# If unclaimed, skip

    lw $t3, 24($s0)  			# Load 2nd cell 
    lw $t4, 48($s0)			# Load 3rd cell
    lw $t5, 72($s0)			# Load 4th cell


    bne $t2, $t3, next_col_row		# If any don't match, skip
    bne $t2, $t4, next_col_row		# If any don't match, skip
    bne $t2, $t5, next_col_row		# If any don't match, skip

    # Found 4 in a column vertically
    move $v0, $t2			# Winner found vertically → move ID to $v0
    jr $ra				# Return with winner ID

next_col_row:				# Skip to next row block
    addi $s0, $s0, 4			# Move pointer one cell down
    addi $t1, $t1, 1			# Increment row index
    blt $t1, 3, col_row_loop		# Check first 3 rows only

    addi $t0, $t0, 1			# Increment column counter
    blt $t0, 6, check_col_loop		# Repeat for 6 columns

    # Reset pointer
    la $s0, owner			# Reset pointer for next check

    # Check diagonal down-right 
    li $t0, 0  				# Initialize row index to 0

check_diagdr_loop:			# Outer loop for diagonals down-right
    li $t1, 0  				# Initialize column index to 0

diagdr_inner_loop:			# Inner loop to check diagonal down-right
    lw $t2, 0($s0)			# Load starting cell
    beqz $t2, next_diagdr		# If unclaimed, skip

    lw $t3, 28($s0)  			# Load next diagonal cell
    lw $t4, 56($s0)			# Load 3rd cell 
    lw $t5, 84($s0)	 		# Load 4th cell

    bne $t2, $t3, next_diagdr		# If any mismatch, skip
    bne $t2, $t4, next_diagdr		# If any mismatch, skip
    bne $t2, $t5, next_diagdr		# If any mismatch, skip

    # Found 4 in diagonal down-right
    move $v0, $t2			# Winner found diagonally → move ID to $v0
    jr $ra				# Return with winner ID

next_diagdr:				# Move to next diagonal set
    addi $s0, $s0, 4			# Move to next column
    addi $t1, $t1, 1			# Increment column index
    blt $t1, 3, diagdr_inner_loop	# Check only columns 0–2

    addi $s0, $s0, 12			# Move to next row
    addi $t0, $t0, 1			# Increment row counter
    blt $t0, 3, check_diagdr_loop	# Check only rows 0–2

    # Reset pointer
    la $s0, owner			# Reset pointer for next check

    # Check diagonal down-left 
    li $t0, 0				# Initialize row index

check_diagdl_loop:			# Outer loop for down-left diagonals
    li $t1, 3				# Start at column index 3 for down-left

diagdl_inner_loop:			# Inner loop to check diagonal down-left
    lw $t2, 0($s0)			# Load starting cell
    beqz $t2, next_diagdl		# If unclaimed, skip

    lw $t3, 20($s0)  			# Load 2nd cell
    lw $t4, 40($s0)			# Load 3rd cell
    lw $t5, 60($s0)			# Load 4th cell


    bne $t2, $t3, next_diagdl		# If any mismatch, skip
    bne $t2, $t4, next_diagdl		# If any mismatch, skip
    bne $t2, $t5, next_diagdl		# If any mismatch, skip

    # Found 4 in diagonal down-left
    move $v0, $t2			# Winner found diagonally → move ID to $v0
    jr $ra				# Return with winner ID

next_diagdl:				# Move to next diagonal left set
    addi $s0, $s0, 4			# Advance to next column
    addi $t1, $t1, 1			# Increment column counter
    blt $t1, 6, diagdl_inner_loop	# Only columns 3–5 are valid starting points

    addi $t0, $t0, 1			# Increment row index
    blt $t0, 3, check_diagdl_loop	# Check rows 0–2

    # No winner found
    li $v0, 0				# No winner found → set return value to 0
    jr $ra				# Return
		