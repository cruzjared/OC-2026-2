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
            push ecx
            mov cl, byte[ebp+12] ; posicion
            ;aplicar corrimiento a la derecha el numero de posiciones
            shr byte[ebp+8], cl
            OR byte[ebp+8], 0b00000001
            pop ecx
            ;el retorno siempre en eax
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




