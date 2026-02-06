; ------------------------------------------------------------
; strings.asm -- String Helpers
; Integer -> ASCII, literal append, pointer movement.
; ------------------------------------------------------------

include common.inc

.code

; rdi = write pointer
; rdx = pointer to null-terminated literal
AppendLiteral proc
    xor     rax, rax
next_char:
    mov     al, [rdx]
    test    al, al
    jz      done_literal
    mov     [rdi], al
    inc     rdi
    inc     rdx
    jmp     next_char
done_literal:
    ret
AppendLiteral endp

; rdi = write pointer
; eax = integer to convert
AppendAscii proc
    push    rbx
    mov     ebx, 10
    xor     ecx, ecx    ; digit count

    test    eax, eax
    jnz     divide_loop
    mov     byte ptr [rdi], '0'
    inc     rdi
    pop     rbx
    ret

divide_loop:
    xor     edx, edx
    div     ebx
    push    rdx         ; remainder
    inc     ecx
    test    eax, eax
    jnz     divide_loop

store_digits:
    pop     rax
    add     al, '0'
    mov     [rdi], al
    inc     rdi
    loop    store_digits

    pop     rbx
    ret
AppendAscii endp

; rcx = wide string pointer
; eax = integer result
WideToInt proc
    xor     eax, eax
    xor     edx, edx
w_loop:
    mov     dx, [rcx]
    test    dx, dx
    jz      w_done
    sub     dx, '0'
    imul    eax, 10
    add     eax, edx
    add     rcx, 2      ; wchar_t is 2 bytes
    jmp     w_loop
w_done:
    ret
WideToInt endp

end
