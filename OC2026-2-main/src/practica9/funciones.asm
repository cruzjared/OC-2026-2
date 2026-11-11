%include "../../lib/pc_io.inc"   ; incluir declaraciones de procedimiento externos

;equivalente a los define en c
section .data
    ;palabra clave bskey equivale a 0x7F o delete
    bskey equ 0x7F
    ;lencadena = 255
    lencadena equ 255
    ;ln = salto de linea \n
    ln equ 0x0A
    ; define byte de mensajes y linea final
    nline db ln,0
    msg1 db ln,'Captura: ', 0
    msg2 db ln,'Numero: ', 0
    msg3 db ln,'Cadena: ', 0
    
section .bss
    ;resb = reservar byte sin inicializar
    ;etiqeuta-resb-cantidad bytes
    cadena resb lencadena
    numero resb lencadena

section .text
    global _start         ; referencia para inicio de programa
    global _minimo
    global _maximo
    global _sumatoria

;----------------------------------------------------------------------------------------    
   
    %macro ENTRADA 0
    push ebp
    mov ebp, esp
    %endmacro


    %macro SALIDA 0 
    mov esp, ebp
    pop ebp
    %endmacro


    %macro WHILE 5

    mov esi, %1

    %%ciclo:
                ;inicializar i en -1, para no duplicar mas abajo
                inc esi
                cmp esi, %2 ;longitd
                jl .%3
                jmp %%final
    .%3:
                ;mueves edx el valor de arreglo[i] y comparas con el minimo 
                mov edx, dword[ebx+esi*4]
                mov eax, dword[ebp-4]
                cmp edx, eax
                %5 .%4
                jmp %%ciclo


    .%4:
                ;actualizas el minimo con el actual
                mov dword[ebp-4],edx
                jmp %%ciclo

    %%final:



    %endmacro

    _minimo:
            ENTRADA
            sub esp, 4
            push ebx
            push ecx
            push edx
            push esi
            mov ebx, dword[ebp+8] ;arreglo
            mov ecx, dword[ebp+12] ; len
            ;mueves el contenido actual del arreglo a edx
            mov edx, dword[ebx]
            ;en el primer espacio reservado en stack, se mueve edx (minimo)
            mov dword[ebp-4], edx 
            ;i = 0
            mov esi,0
    .ciclo:
            cmp esi, ecx
            jl .cuerpo
            jmp .fin

    .cuerpo: 
                ;mueves edx el valor de arreglo[i] y comparas con el minimo 
            mov edx, dword[ebx+esi*4]
            mov eax, dword[ebp-4]
            cmp edx, eax
            inc esi
            jl . cambio
            jmp .ciclo

    .cambio:
            ;actualizas el minimo con el actual
            mov dword[ebp-4],edx
            jmp.ciclo
        

            
    .fin:   
             pop esi
             pop edx
             pop ecx
             pop ebx
            ;el retorno siempre en eax
            mov eax, dword[ebp-4]
            ;restablecer el stack pointer
            add esp, 4
            SALIDA
            RET



;-----------------------------------

_minimo:
            ENTRADA
            sub esp, 4
            push ebx
            push ecx
            push edx
            push esi
            mov ebx, dword[ebp+8] ;arreglo
            mov ecx, dword[ebp+12] ; len
            ;mueves el contenido actual del arreglo a edx
            mov edx, dword[ebx]
            ;en el primer espacio reservado en stack, se mueve edx (minimo)
            mov dword[ebp-4], edx 
            WHILE 0,ecx,cuerpo,cambio,jl
           
             pop esi
             pop edx
             pop ecx
             pop ebx
            ;el retorno siempre en eax
            mov eax, dword[ebp-4]
            ;restablecer el stack pointer
            add esp, 4
            SALIDA
            RET


       

