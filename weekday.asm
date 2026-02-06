; ------------------------------------------------------------
; weekday.asm -- Sakamoto weekday algorithm
; Input:
;   ecx = year
;   edx = month (3=March ... 14=February)
;   eax = day
; Output:
;   edx = weekday (0=Sunday ... 6=Saturday)
; ------------------------------------------------------------

include common.inc

.code

Weekday proc
    ; -------------------------------------------
    ; Prologue
    ; -------------------------------------------
    push    rbx
    push    r12
    push    r13

    ; Save volatile inputs into non-volatile registers
    mov     r12d, eax           ; Day
    mov     r13d, edx           ; Month (and implicitly preserves ECX=Year via flow)

    ; Adjust year if month < 3 (i.e., Jan/Feb)
    ; Note: Sakamoto's algorithm treats Jan/Feb as months 13/14 of previous year
    cmp     r13d, 3
    jge     calc_start
    dec     ecx
calc_start:
    mov     r8d, ecx            ; Year (modified)

    ; -------------------------------------------
    ; Calculation
    ; weekday = (y + y/4 - y/100 + y/400 + t[m-1] + day) % 7
    ; -------------------------------------------

    ; y/4
    mov     eax, r8d
    shr     eax, 2              ; DIV 4 -> SHR 2
    mov     r9d, eax            ; y/4

    ; y/100
    mov     eax, r8d
    mov     ebx, 100
    xor     edx, edx
    div     ebx
    mov     r10d, eax           ; y/100

    ; y/400
    mov     eax, r8d
    mov     ebx, 400
    xor     edx, edx
    div     ebx
    mov     r11d, eax           ; y/400

    ; t[m-1]
    lea     rdx, WeekdayOffsetTable
    mov     eax, r13d           ; Restore Month
    dec     eax                 ; Index = Month - 1
    mov     eax, [rdx + rax*4]  ; Load t[m-1]

    ; Summation
    add     eax, r8d            ; + y
    add     eax, r9d            ; + y/4
    sub     eax, r10d           ; - y/100
    add     eax, r11d           ; + y/400
    add     eax, r12d           ; + day

    ; Modulo 7
    mov     ebx, 7
    xor     edx, edx
    div     ebx
    ; Result (remainder) is in EDX, which is the return register.

    ; -------------------------------------------
    ; Epilogue
    ; -------------------------------------------
    pop     r13
    pop     r12
    pop     rbx
    ret
Weekday endp

end
