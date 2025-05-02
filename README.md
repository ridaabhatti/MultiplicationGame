# MultiplicationGame - MIPS
A terminal based player vs. computer multiplication game
# Overview
This project is based on 6x6 grid in which the player and computer take turns. 
The games involves taking turns selecting a number from 1-9.
The product of each pair of selections correlates to the position on the board.
The goal of the game is to capture 4 products in a row on the board, wether it be horizomtal, vertical or diagonal. 
# GamePlay 
- Gamboard prefilled wth unique multiplication products
- A product is created from players chosen product and computers last chosen number
- Products are marked with (P) for Player and (C) for Computer
- First to claim for in a row wins
- Board updates in real time including sound feedback for moves and wins
# Structure
-  Main.asm: Main game loop and control flow
-  DrawBoard.asm:  ASCII display logic for the game board 
-  UpdateBoard.asm: Updates board and ownership state 
-  MoveValidation.asm:  Ensures valid player and computer moves
-  CheckWin.asm: Detects 4-in-a-row wins 
-  ComputerStrategy.asm: AI logic for the computer's move 
-  InitBoard.asm: Initializes board data and state 
-  Utils.asm: Helper functions (random, multiply, print) 
-  SysCalls.asm: Syscall definitions and macros
  
#  How to Run

1. Download the [MARS MIPS Simulator]
2. Clone this repository or download the source files.
3. Open all `.asm` files in MARS.
4. Set `Main.asm` as the active tab.
5. Go to `Settings > Assemble All Files` or press `F3`.
6. Run the program with `F5`.

# Features

- Real-time ASCII board rendering
- Sound feedback after moves and at game conclusion
- Move validation (range check and conflict check)
- Simple but strategic AI to avoid repeated values
- Modularized code across reusable `.asm` files

# Educational Value

This project demonstrates how low-level concepts like memory, branching, and system calls can be combined to simulate interactive gameplay, providing valuable experience in:
- MIPS Assembly programming
- Manual memory management
- Modular software architecture
- Game logic implementation

# Demo

You can view a short demo of the game within the files

# License

This project is for educational use. Feel free to fork or adapt for personal or classroom purposes.

---

