%include "../../lib/pc_io.inc"   ; incluir declaraciones de procedimiento externos

section .text
    global _start         ; referencia para inicio de programa
    
_start:   
    ; --- IMPRIMIR CADENA COMPLETA ---
    mov edx, msg          ; edx = dirección de la cadena msg
    call puts             ; imprime cadena
    
            mov eax, 2
            xor ecx,ecx
            add ecx, 3
            ;se multiplica eax (2) *3
    .mul:   lea eax, [eax +eax*2]
            cmp eax, 6
            ;mientras la comparacion de 0 o ecx !=0
            ;loope decrementa ecx siempre, aunque no se haga otra iteracion
            loope .mul

    ;eax acaba en 18 o letra
    mov byte[edx+eax], 'S'
    mov edx, msg
    call puts

    mov byte[edx+ecx], 'B'
    mov edx, msg
    call puts


    ;pruebas con mascara, recorridos y test
    xor eax, eax
    xor ecx, ecx

    add eax, 00001011b
    ;ecx mascara
    add ecx, 00010000b
    and eax, ecx
    shr eax,4
    ;00000001b
    test eax, 00000001b
    jz .es_zero
    jmp .fin

    .es_zero:   mov byte[edx], '0'
                mov edx, msg
                call puts

    ; --- FIN DE PROGRAMA ---
    .fin:   mov eax, 1            ; Llamada sys_exit
            xor ebx, ebx          ; return 0
            int 0x80              ; Fin de programa

section .data
    msg db 'abcdefghijklmnopqrstuvwxyz0123456789', 0xa, 0
    salto db 0xa
    uno db 'Z'  