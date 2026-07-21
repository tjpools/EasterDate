; ------------------------------------------------------------
; main.asm -- Orchestrator
; Establishes initial state, calls EasterDate, builds output,
; and performs console I.O.
; ------------------------------------------------------------

include common.inc

.data
EasterLiteral        db "Easter ",0
IsLiteral            db " is ",0
SpaceLiteral         db " ",0
NewlineLiteral       db 13,10,0
InvalidYearLiteral   db "Gauss Easter is for years 1583 to 9999",13,10,0

.code

main proc
    ; --------------------------------------------------------
    ; Stack frame Design:
    ;   [RSP+00] Shadow Space (32 bytes) - Reused for calls
    ;   [RSP+20] Arg 5 Space (8 bytes)   - Needed for WriteConsoleA
    ;   [RSP+28] Output Buffer (128 bytes) - [RSP+28] to [RSP+A7]
    ;   [RSP+A8] argc (4 bytes, int)
    ;   [RSP+AC] Scratch / Safety padding (12 bytes)
    ;   [RSP+B8] Return Address (Pushed by Call)
    ;
    ; Allocation needed: 184 bytes (0xB8)
    ; Alignment check: 
    ;   Entry RSP ends in 8. 
    ;   Sub 184 (ends in 8). 
    ;   New RSP ends in 0. (Correct for Calls)
    ; --------------------------------------------------------
    sub     rsp, 0B8h

    ; --------------------------------------------------------
    ; Parse command-line year
    ; --------------------------------------------------------
    call    GetCommandLineW          ; RAX = lpCmdLine
    mov     rcx, rax                 ; RCX = lpCmdLine

    lea     rdx, [rsp+0A8h]          ; RDX = &argc (int in scratch area)
    call    CommandLineToArgvW       ; RAX = argv**, [rsp+0A8h] = argc

    mov     r8, rax                  ; R8  = argv**
    mov     r9d, [rsp+0A8h]          ; R9D = argc

    cmp     r9d, 1
    jle     use_default_year

    mov     rcx, [r8+8]              ; RCX = argv[1] (wide string)
    call    WideToInt
    mov     r12d, eax
    jmp     year_ready

use_default_year:
    mov     r12d, 1964

year_ready:

    ; --------------------------------------------------------
    ; Validate Gregorian year range
    ; --------------------------------------------------------
    mov     eax, r12d

    cmp     eax, 1583
    jl      invalid_year

    cmp     eax, 9999
    jg      invalid_year

    jmp     year_ok

invalid_year:
    lea     rdi, [rsp+28h]      ; Buffer start
    lea     rdx, InvalidYearLiteral
    call    AppendLiteral
    jmp     do_print

year_ok:

    ; --------------------------------------------------------
    ; Compute Easter date
    ; --------------------------------------------------------
    mov     ecx, r12d
    call    EasterDate
    mov     r13d, eax          ; day
    mov     r14d, ecx          ; month

    ; --------------------------------------------------------
    ; Compute weekday
    ; --------------------------------------------------------
    mov     ecx, r12d          ; year
    mov     edx, r14d          ; month
    mov     eax, r13d          ; day
    call    Weekday
    mov     r15d, edx          ; weekday index

    ; --------------------------------------------------------
    ; rdi = write pointer into stack buffer
    ; --------------------------------------------------------
    lea     rdi, [rsp+28h]     ; Buffer start

    ; --------------------------------------------------------
    ; Build output string
    ; --------------------------------------------------------
    lea     rdx, EasterLiteral
    call    AppendLiteral

    mov     eax, r12d
    call    AppendAscii

    lea     rdx, IsLiteral
    call    AppendLiteral

    mov     eax, r15d
    lea     rdx, WeekdayNameTable
    mov     rdx, [rdx + rax*8]
    call    AppendLiteral

    lea     rdx, SpaceLiteral
    call    AppendLiteral

    mov     eax, r14d
    sub     eax, 3
    lea     rdx, MonthNameTable
    mov     rdx, [rdx + rax*8]
    call    AppendLiteral

    lea     rdx, SpaceLiteral
    call    AppendLiteral

    mov     eax, r13d
    call    AppendAscii

    lea     rdx, NewlineLiteral
    call    AppendLiteral

do_print:
    ; --------------------------------------------------------
    ; Console output
    ; --------------------------------------------------------
    mov     ecx, STD_OUTPUT_HANDLE
    call    GetStdHandle

    ; Calculate length (RDI - Start)
    lea     rdx, [rsp+28h]     ; Buffer Start
    mov     r8, rdi
    sub     r8, rdx            ; r8 = Current Ptr - Start Ptr = Length

    ; WriteConsoleA(
    ;   RCX = Handle, 
    ;   RDX = Buffer, 
    ;   R8 = CharsToWrite, 
    ;   R9 = &CharsWritten, 
    ;   Stack = Reserved
    ; )
    mov     rcx, rax            ; Handle
    lea     r9, [rsp+28h+80h]   ; Dump 'written count' somewhere safe
    
    mov     qword ptr [rsp+20h], 0 ; 5th Arg: lpReserved (Must be NULL)

    call    WriteConsoleA

    xor     ecx, ecx
    call    ExitProcess

main endp
end
