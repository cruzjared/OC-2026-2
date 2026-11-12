%macro ENTRADA 0
    push ebp
    mov ebp, esp
%endmacro


%macro SALIDA 0 
    mov esp, ebp
    pop ebp
%endmacro



section .text
    
    global set_bit
    global get_bit

;----------------------------------------------------------------------------------------    

set_bit:
            ENTRADA
            push ebx
            push ecx
            push edx
            ;pasar a edx para desreferenciar el puntero
            ;mover puntero a registro de 32 bits NO USAR BYTE
            mov edx, [ebp+8]
            mov cl, byte[ebp+12] ; posicion
            mov bl,0b00000001 
            shl bl, cl
            OR byte[edx], bl
            pop edx
            pop ecx
            pop ebx
            SALIDA
            ret

;-------------------------------------------------------

get_bit:

        ENTRADA
        push ebx
        push ecx
        mov ebx, [ebp+8] ;numero de 8 bits
        mov cl, [ebp+12] ; posicion
        inc cl ;hacer un recorrido posicion +1, para que bit quede en CF
        shr ebx, cl
        jc .uno
        mov eax, 0
        jmp .fin


.uno:   mov eax, 1
       

.fin:   pop ecx
        pop ebx
        SALIDA 
        RET 




