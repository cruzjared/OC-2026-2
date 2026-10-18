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

;----------------------------------------------------------------------------------------    
_start:   
   
    ; --- IMPRIMIR CADENA  ---
    mov edx, msg1       
    call puts   
    
    mov edx, cadena 
    mov ax, lencadena
    call captura 

    ;llamar ATOI
    mov edx,cadena
    call ATOI
    mov ebx, eax

    mov eax, 1           ; Syscall 1 = sys_exit
    int 0x80


       
    jmp .fin_programa  
    
    
    

    .fin_programa: 
        mov edx, nline    
        call puts     
        call puts     
        mov eax, 1            ; Llamada sys_exit
	    xor ebx, ebx          ; return 0
        int 0x80              ; Fin de programa

;-----------------------------------------------------------------------------------------
    captura:

            ;i = ebx
            push eax
            push ebx
            push ecx
            mov ebx,0
            ;copiar la longitud a cx
            mov ecx,0
            mov cx, ax
            sub ecx,1
            
           
            
    ;si lencadena - i = 0, terminar, si no continuar
    .comparacion:   cmp ecx,ebx
                    je .terminar

                    ;leer tecla presionada
                    call getch
                    ;si lo leido por getch es \n, terminar
                    cmp al,ln
                    je .terminar
                    ;si lo leido es igual a borrar, evaluar
                    cmp al, bskey
                    je .evaluar
                    jmp .guardar
                    ; i < 1, no se puede borrar
    .evaluar:       cmp ebx,0
                    jg .borrar
                    jmp .comparacion

                    ;si no se tuvo que borrar, guardar la letra en la direccion de memoria
    .guardar:       mov [edx], al
                    add edx,1
                    call putchar
                  
                    ;i++
                    add ebx,1
                    jmp .comparacion
                    
                    ;agregar caracter nulo
    .terminar:      mov byte[edx], 0
                    pop ecx
                    pop ebx
                    pop eax
                    ret
                    
    .borrar:        sub ebx,1
                    sub edx,1
                    call borrar
                    jmp .comparacion
             

;-----------------------------------------------------------------------------------------

borrar:
        push ax 
        ;0x8 en ascii es backspace
        mov al,0x8
        call putchar    
        mov al,' '
        call putchar
        mov al,0x8
        call putchar   
        pop ax
        ret 

;-----------------------------------------------------------------------------------------
;recibe cadena en edx y retorna numero en el registro eax
ATOI:
       
        push ebx
        push ecx

        ;set contador (eax) y limpiar registros
        mov eax, 0
        mov ecx,0
        mov ebx, 0

                ;si la cadena tiene \0 terminar
.comparacion:   cmp byte [edx],0
                je .terminar
                ;ver si i es 0 para ver signo
                cmp eax,0
                jne .evaluar
                ;si edx es espacio avanza sin hacer nada
                cmp byte [edx],32
                je .avanzar
                
                ;si hay + ignoras y avanzas
                cmp byte [edx],43 
                je .avanzar
                ;si hay 
                cmp byte [edx],45
                jne .avanzar
                mov ecx, -1
                jmp .avanzar


                 
                ;si edx es menor a 48, se termina
.evaluar:       cmp byte [edx],48
                jl .terminar
                ;si edx es mayor a 57, se termina
                cmp byte [edx],57
                jg .terminar
                ;multiplicar contador *10 y guardar en contador
                imul eax,eax,10
                ;agregar el numero de la cadena a el resultado
                mov bl, [edx]
                sub bl, 48
                add eax,ebx
.avanzar:       add edx,1
                jmp .comparacion

.terminar:      cmp ecx,-1
                jne .pops
                imul eax,eax,-1
.pops:          pop ecx
                pop ebx
                ret


