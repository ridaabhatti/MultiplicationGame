#Term Project: Multiplication Game
#Author: Ridaa Bhatti
#Date: 04/26/2025
#Location: UTD

.include "SysCalls.asm" 					# Include system call definitions
.include "InitBoard.asm" 					# Include board initialization module 

.globl main 							# Declare 'main' as global label
.globl board 							# Make 'board' array globally visible in all files
.globl owner 							# Make 'owner' array globally visible in all files
.globl last_player_val 						# Make 'last_player_val' array globally visible in all files
.globl last_computer_val 					# Make 'last_computer_val' array globally visible in all files
.globl InitBoard 						# Make 'InitBoard' array globally visible in all files

.data
welcomeMessage: .asciiz "Welcome to the Multiplication Game!\n" # Display welcome text

prompt: .asciiz "Choose a number (1-9): "			# Input prompt for player
playerTurnMsg: .asciiz "Your turn!\n"				# Message for player's turn
computerTurnMsg: .asciiz "Computer's turn!\n"			# Message for computer's turn
player_wins: .asciiz "You win!\n"				# Message shown when player wins
computer_wins: .asciiz "Computer wins!\n"			# Message shown when computer wins
invalidMsg: .asciiz "Invalid move! Try again.\n"		# Message for invalid move
computerSelectedMsg: .asciiz "Computer selected: "		# Label for computer's selected number
newline: .asciiz "\n"						# Newline character

.text								# Start of code section   	
main: 								# Main program start
    # Initialize the board
    jal InitBoard						# Call InitBoard to initialize the board 

    # Print welcome
    li $v0, 4		   					# Set syscall to print_string	
    la $a0, welcomeMessage 					# Load address
    syscall		   					# Perform syscall to print 

    # Draw board initially
    jal DrawBoard						# Call DrawBoard to display the initial board

    # Set turn: 1 = Player, 2 = Computer
    li $s7, 1							# Set $s7 = 1 → Player starts first

game_loop:							# Label for the main game loop
    beq $s7, 1, player_turn   					# If $s7 == 1, go to players turn 
    beq $s7, 2, computer_turn 					# If $s7 == 2, go to computers turn

#Player's Turn 
player_turn:							# Start of player turn code
    # Print "Your Turn"
    li $v0, 4							# Syscall to print_string
    la $a0, playerTurnMsg					# Load "Your turn!" message
    syscall							# Print it

player_input_loop:						# Label to prompt player input
    # Prompt player			
    li $v0, 4							# Syscall to print_string
    la $a0, prompt						# Load "Choose a number" prompt
    syscall							# Display prompt

    # Read input
    li $v0, 5							# Syscall to read_int
    syscall							# Read player's input
    move $s0, $v0   				 		# Save input to $s0

    # Validate input
    blt $s0, 1, invalid_input					# If input < 1 → invalid
    bgt $s0, 9, invalid_input 					# If input > 9 → invalid
    j player_input_ok						# Otherwise, input is valid

invalid_input:							# Label to handle invalid input
    li $v0, 4							# Syscall to print_string
    la $a0, invalidMsg						# Load invalid move message
    syscall							# Print it
    j player_input_loop						# Ask again

player_input_ok:						# Valid input path
    # Save player move	
    move $s2, $s0   						# Save valid player move to $s2

    # Update board
    move $a0, $s0       					# Set $a0 = player's number
    move $a1, $s3       					# Set $a1 = computer's last move
    li $a2, 1           					# Player ID = 1
    jal UpdateBoard	 					# Update board state with player's move
    jal beep_sound						# Play beep after move

    jal DrawBoard						# Redraw the board

    # Switch to computer turn
    li $s7, 2							# Switch turn to computer
    j check_win							# Go check for winner

# Computer's Turn 						
computer_turn:							# Start of computer turn
    # Print "Computer's Turn"
    li $v0, 4							# Syscall code for print_string
    la $a0, computerTurnMsg					# Load "Computer's turn!" message
    syscall							# Print message
	
    # Generate computer move (1-9)
    li $a0, 1							# Lower bound for random number
    li $a1, 9							# Upper bound
    li $v0, 42							# Syscall: random int in range
    syscall							# Generate number from 1 to 9
    move $s1, $a0       					# Store result in $s1
    move $s3, $s1      						# Save latest computer move

    # Print Computer's chosen number 
    li $v0, 4							# Syscall code for print_string
    la $a0, computerSelectedMsg					# Load label "Computer selected: "
    syscall							# Print it

    li $v0, 1							# Syscall code for print_int
    move $a0, $s1						# Print the actual number
    syscall							# Print the number

    li $v0, 4							# Syscall code for print_string
    la $a0, newline						# Print a newline
    syscall							# Print a newline

    # Update board
    move $a0, $s1       					# $a0 = computer number
    move $a1, $s2       					# $a1 = last player move
    li $a2, 2           					# 2 = Computer
    jal UpdateBoard						# Update board with computer's move
    jal beep_sound						# Beep

    jal DrawBoard					 	# Redraw board

    # Switch to player turn
    li $s7, 1							# Set turn to player
    j check_win							# Check win status

# Check Win 
check_win:							# Label for checking if anyone has won
    jal CheckWin						# Call CheckWin procedure
    move $t0, $v0						# Store result in $t0
    bnez $t0, someone_won					# If not zero → winner found
    j game_loop							# Otherwise, loop again

# Win Handler
someone_won:							# A player has won
    li $v0, 4							# Set syscall code to print_string 
    li $t1, 1							# Load constant 1 into $t1
    beq $t0, $t1, player_wins_label				# If winner is 1 → player

    li $t2, 2							# Load constant 2 into $t2 
    beq $t0, $t2, computer_wins_label				# If winner is 2 → computer

    j end_game							# Safety jump to end

player_wins_label:						# Label for handling when the player wins
    la $a0, player_wins						# Load address of "You win!" message into $a0
    syscall							# Print the player win message using syscall
    
    jal beep_sound						# Play beep sound
    jal beep_sound						# Play beep sound again
    
    j end_game							# Jump to program end

computer_wins_label:						# Label for handling when the computer wins
    la $a0, computer_wins					# Load address of "Computer wins!" message into $a0
    syscall							# Print the computer win message using syscall
    
    jal beep_sound						# Play beep sound
    jal beep_sound						# Play beep sound again
    
    j end_game							# Jump to program end

end_game:						# Program termination
    li $v0, 10						# Syscall to exit
    syscall						# End the program
    
 # Beep sound subroutine
 beep_sound:						# Subroutine to play sound
 li $v0, 11						# Syscall to print_char
 li $a0, 7 						# ASCII bell character '\a'
 syscall						# Play the beep
 jr $ra   						# Return from subroutine
