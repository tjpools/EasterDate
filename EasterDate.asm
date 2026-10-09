; ------------------------------------------------------------
; EasterDate.asm -- Pure Computation
; Implements Gauss's algorithm.
; Input:  RCX = year
; Output: EAX = day, ECX = month, EDX = weekday
; ------------------------------------------------------------

include common.inc

.code

EasterDate proc
    ; -------------------------------------------
    ; Prologue: preserve non-volatile state
    ; -------------------------------------------
    push    rbx
    push    r12
    push    r13
    push    r14
    push    r15

    ; -------------------------------------------
    ; Compute the Gregorian Easter state
    ; -------------------------------------------

    ; a = year % 19
    mov     eax, ecx
    xor     edx, edx
    mov     ebx, 19
    div     ebx
    mov     r8d, edx                ; a

    ; b = year / 100
    ; c = year % 100
    mov     eax, ecx
    xor     edx, edx
    mov     ebx, 100
    div     ebx
    mov     r9d, eax                ; b
    mov     r10d, edx               ; c

    ; d = b / 4
    mov     eax, r9d
    shr     eax, 2
    mov     r11d, eax               ; d

    ; e = b % 4
    mov     eax, r9d
    and     eax, 3
    mov     r12d, eax               ; e

    ; f = (b + 8) / 25
    mov     eax, r9d
    add     eax, 8
    xor     edx, edx
    mov     ebx, 25
    div     ebx
    mov     r13d, eax               ; f

    ; g = (b - f + 1) / 3
    mov     eax, r9d
    sub     eax, r13d
    inc     eax
    xor     edx, edx
    mov     ebx, 3
    div     ebx
    mov     r14d, eax               ; g

    ; h = (19a + b - d - g + 15) % 30
    mov     eax, r8d
    imul    eax, 19
    add     eax, r9d
    sub     eax, r11d
    sub     eax, r14d
    add     eax, 15
    xor     edx, edx
    mov     ebx, 30
    div     ebx
    mov     r15d, edx               ; h

    ; f is no longer needed, so R13D becomes i.
    ; i = c / 4
    mov     eax, r10d
    shr     eax, 2
    mov     r13d, eax               ; i

    ; b is no longer needed, so R9D becomes k.
    ; k = c % 4
    mov     eax, r10d
    and     eax, 3
    mov     r9d, eax                ; k

    ; l = (32 + 2e + 2i - h - k) % 7
    mov     eax, 32
    add     eax, r12d
    add     eax, r12d
    add     eax, r13d
    add     eax, r13d
    sub     eax, r15d
    sub     eax, r9d
    xor     edx, edx
    mov     ebx, 7
    div     ebx
    mov     r10d, edx               ; l

    ; m = (a + 11h + 22l) / 451
    imul    eax, r15d, 11
    imul    ebx, r10d, 22
    add     eax, ebx
    add     eax, r8d
    xor     edx, edx
    mov     ebx, 451
    div     ebx
    mov     r11d, eax               ; m

    ; q = h + l - 7m + 114
    mov     eax, r15d
    add     eax, r10d
    imul    ebx, r11d, 7
    sub     eax, ebx
    add     eax, 114

    ; month = q / 31
    ; day = (q % 31) + 1
    xor     edx, edx
    mov     ebx, 31
    div     ebx
    mov     ecx, eax                ; month
    mov     eax, edx
    inc     eax                     ; day

    ; Gregorian Easter is always Sunday.
    xor     edx, edx                ; weekday

    ; -------------------------------------------
    ; Epilogue: restore non-volatile state
    ; -------------------------------------------
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    ret
EasterDate endp

end