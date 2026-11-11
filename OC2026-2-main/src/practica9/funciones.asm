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


%macro WHILESUM 3

     mov esi, %1

    %%ciclo:
                ;inicializar i en -1, para no duplicar mas abajo
                inc esi
                cmp esi, %2 ;longitd
                jl .%3
                jmp %%final
    .%3:        
                ;mover el contenido actual del arreglo a edx
                mov edx, dword[ebx+esi*4]
                add [ebp-4], edx
                jmp %%ciclo

    %%final:
%endmacro


section .text
    
    global _minimo
    global _maximo
    global _sumatoria

;----------------------------------------------------------------------------------------    

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
            WHILE -1,ecx,cuerpo,cambio,jl
           
             pop esi
             pop edx
             pop ecx
             pop ebx
            ;el retorno siempre en eax
            mov eax, dword[ebp-4]
            ;restablecer el stack pointer
            SALIDA
            ret

;-----------------------------------------------------------------------
       

_maximo:
            ENTRADA
            sub esp, 4
            push ebx
            push ecx
            push edx
            push esi
            mov ebx, dword[ebp+8] ;arreglo
            mov ecx, dword[ebp+12] ; len
            ;en el primer espacio reservado en stack, se mueve edx (maximo)
            mov dword[ebp-4], edx 
            WHILE -1,ecx,cuerpo,cambio,jg
           
             pop esi
             pop edx
             pop ecx
             pop ebx
            ;el retorno siempre en eax
            mov eax, dword[ebp-4]
            ;restablecer el stack pointer
            SALIDA
            ret


;-----------------------------


_sumatoria:

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
            ;en el primer espacio reservado en stack, se mueve edx (sumatoria)
            mov dword[ebp-4], 0
            WHILESUM -1,ecx,suma
           
             pop esi
             pop edx
             pop ecx
             pop ebx
            ;el retorno siempre en eax
            mov eax, dword[ebp-4]
            ;restablecer el stack pointer
            SALIDA
            ret




