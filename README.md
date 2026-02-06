********************************************************************************************************
🕊️ EasterDate: A Narrative of Lineage, Intent, and Mechanism
********************************************************************************************************
Easter is the oldest movable feast in the Christian calendar, and for more
 than a thousand years its date was a matter of astronomy, theology, and authority.
 The Church needed a method that was reproducible across generations, portable
 across regions, and faithful to doctrine. The result was computus: a long evolution
 of tables, cycles, and arithmetic rules that gradually converged into a stable algorithm.
 Gauss’s formulation is one of the clearest expressions of that lineage—an elegant compression
 of centuries of reasoning into a finite sequence of steps.
This program stands inside that tradition. It takes the same intent that guided computus—determine
 the date of Easter for a given year—and expresses it in the language of a modern deterministic machine.
 The algorithm becomes a sequence of state transitions. The stack becomes the ledger of those transitions.
 The calling convention becomes the contract that ensures the mechanism behaves the same way every 
 time it runs.
The program is written in x86-64 assembly for Windows, following the Microsoft ABI. 
It treats the CPU as a state machine whose configurations are encoded in registers and stack frames.
 Each function boundary is a transition. Each stack frame is a snapshot of meaning.
 The computation of Easter becomes a choreography of arithmetic, memory, and control flow—an echo of the
 computists who once encoded the same logic in tables and cycles.
The final output is a sentence such as:
*******************************
Easter 1964 is Sunday March 29
*******************************
This is more than a formatted string. It is the human-readable surface of a deeper structure: 
the traversal of a state machine whose transitions reflect both the historical logic of computus
 and the architectural logic of the x86‑64 stack. The program is a small but complete demonstration
 of how intent becomes mechanism, and how mechanism preserves intent.
 *******************************************************************************************************
With the lineage established, the program’s structure can now be described in precise architectural terms.
 What follows is the mechanical blueprint: the functions, the stack frames, the calling conventions, and 
 the state transitions that turn the historical logic of computus into a deterministic assembly program.
 *******************************************************************************************************
🧭 Architectural Overview
The program consists of three cooperating components:
********************************************************************************************************
• 	main
Establishes the initial stack frame, calls the computation function, constructs the output string, 
and performs console I/O.
********************************************************************************************************
• 	EasterDate(year)
Implements Gauss’s algorithm. Receives the year in  and returns:
• eax	 = day
• ecx	 = month (3 = March, 4 = April)
• edx	 = weekday (0 = Sunday … 6 = Saturday)
********************************************************************************************************
• 	WriteConsoleA
Outputs the formatted string. Called according to the Windows x64 ABI with shadow space
 and alignment rules respected.
The stack is the central organizing structure. Each function call represents a state transition,
 and each stack frame encodes the state at that moment.
***************************************************************************
🧩 State Machine Model
***************************************************************************
State 1 — Program Entry
CRT calls main.
rsp % 16 = 8, return address on stack.
***************************************************************************
State 2 — Main Frame Established
 main reserves:
• 	32 bytes shadow space
• 	16 bytes alignment padding
• 	128‑byte output buffer
• 	optional locals
***************************************************************************
State 3 — Call to EasterDate
rcx = year, shadow space active,  aligned.
***************************************************************************
State 4 — Inside EasterDate
Optional frame pointer.
Gauss intermediates computed.
Outputs placed in eax,ecx,edx.
***************************************************************************
State 5 — Main Receives Result
Registers contain the Easter date.
Main’s frame unchanged.
***************************************************************************
State 6 — String Construction
Buffer pointer walks through the 128‑byte region.
Appends literal fragments, ASCII‑converted year/day,
 and table‑looked‑up month/weekday names.
***************************************************************************
State 7 — Call to WriteConsoleA
Arguments placed in registers.
Shadow space reused.
***************************************************************************
State 8 — Return from WriteConsoleA
Output complete.
***************************************************************************
State 9 — Call to ExitProcess
Terminal state.
***************************************************************************
🧩 Data Flow
***************************************************************************
1. 	Input year loaded into rcx.
2. 	EasterDate computes:
• 	day → eax
• 	month → ecx
• 	weekday → edx
3. 	main constructs the output string in a stack-allocated buffer.
4. 	WriteConsoleA prints the buffer.
5. 	ExitProcess terminates the program.
***************************************************************************
🧩 Stack Layout Summary
main frame (example)
rsp+00  buffer[0] (128 bytes)
rsp+80  buffer end
rsp+20  shadow arg1
rsp+28  shadow arg2
rsp+30  shadow arg3
rsp+38  shadow arg4
***************************************************************************
EasterDate frame (example)
rbp+20  shadow arg1 (home for rcx)
rbp+00  saved rbp
rbp-08  local a
rbp-10  local b
...
rbp-40  local h
****************************************************************************
🧩 Calling Convention Contract
• 	First four arguments in rcx,rdx,r8 ,r9 .
• 	Caller allocates 32 bytes of shadow space before each call.
• 	 rsp must be 16-byte aligned at each call.
• 	Callee returns values in rax,rcx,rdx as defined.
• 	Nonvolatile registers preserved by callee if used.
*****************************************************************************
🧩 String Construction Strategy
• 	Use a stack-allocated buffer as the output workspace.
• 	Maintain a write pointer in a register.
• 	Append literal fragments directly.
• 	Convert integers via divide‑by‑10 loops.
• 	Lookup month and weekday names from static tables.
• 	Null-terminate the final string.
******************************************************************************
🧩 Design Philosophy
The program is structured as a stack‑driven state machine.
 Each function boundary is a state transition, and each stack frame 
 is a complete snapshot of the machine’s configuration. 
 This approach mirrors early computational thinking and provides a 
 disciplined foundation for larger assembly projects.
******************************************************************************