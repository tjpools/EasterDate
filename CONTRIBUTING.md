*******************************************************************************************
This project implements the Easter computation algorithm using x86‑64 assembly for Windows.
All contributions must preserve the program’s state‑machine architecture and adhere strictly
to the Microsoft x64 ABI.
Architectural Principles
********************************************************************************************
The program is a stack‑driven state machine.
• 	State Transitions — Every function call represents a transition.
• 	State Snapshots — Every stack frame encodes the machine’s configuration.
• 	Deterministic Behavior — The mechanism must preserve the intent of Gauss’s algorithm.
Calling Convention Contract
All functions must follow the Microsoft x64 calling convention.
• 	Argument Registers — RCX,RDX,R8,R9 for the first four arguments 
• 	Return Registers — RAX,RCX,RDX for return values 
• 	Non‑Volatile Registers — RBX, RBP, RDI, RSI,R12-R15  must be preserved
• 	Shadow Space — Caller allocates 32 bytes before each call
• 	Alignment — RSP  must be 16‑byte aligned at every CALL instruction
EasterDate Function Contract
 EasterDate(year) must follow this interface:
• 	Input — RCX = year
• 	Output
• 	EAX = day
• 	ECX = month (3 = March, 4 = April)
• 	EDX = weekday (0 = Sunday … 6 = Saturday)
String Construction
• 	Use stack‑allocated buffers (128 bytes recommended)
• 	No heap allocation unless unavoidable
• 	Manual integer‑to‑ASCII conversion
• 	Month and weekday names via static lookup tables
Code Style
• 	Comments must explain intent, not instruction semantics
• 	Keep prologue, body, and epilogue visually distinct
• 	Maintain consistent indentation and register naming
**********************************************************************************