extern canonical_off
extern canonical_on

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
    msg2 db ln,'Cadena: ', 0
    
section .bss
    ;resb = reservar byte sin inicializar
    ;etiqeuta-resb-cantidad bytes
    cadena resb lencadena

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

    ;llamar a funcion de mayusculas
    mov edx,cadena
    call mayusculas 
    mov edx, msg2
    call puts 
    mov edx, cadena
    call puts

    ;llamar a funcion de minusculas
    mov edx,cadena
    call minusculas
    mov edx, msg2
    call puts 
    mov edx, cadena
    call puts
    
       
    jmp .fin_programa  
    
    
    
; ----------------------------------------------------------------------------------------
    .fin_programa: 
        mov edx, nline    
        call puts     
        call puts     
        mov eax, 1            ; Llamada sys_exit
	    xor ebx, ebx          ; return 0
        int 0x80              ; Fin de programa

;-----------------------------------------------------------------------------------------
    ;al contiene dato a desplegar
    putchar:
                
                push edx
                push ecx
                push ebx
                push eax
                ;llamar servicio de sys_write
                mov eax,4
                ;argumento de destino de sys_write(pantalla)
                mov ebx,1
                ;mover al puntero de cadena el contenido inicial de eax por medio del esp (stack pointer)
                mov ecx, esp
                ;argumento de cantidad de bytes (escribir un byte)
                mov edx,1
                ;llamar interrupcion
                int 0x80
                pop eax
                pop ebx
                pop ecx
                pop edx
                ret


;-----------------------------------------------------------------------------------------
    ;guarda lo leido en al -> eax low part
    getch:
        ;apagar nodo canonico
        call canonical_off
        ;guardar lo que tenia registro eax, ebx,ecx
        
        push ebx
        push ecx
        push edx
        push eax
        ;llamada servicio sys read
        mov eax, 3 
        ;origen teclado
        mov ebx, 0
        ;mov a puntero de texto lo pusheado a la pila 
        mov ecx, esp
        ;tamano a leer
        mov edx, 1 
        int 0x80 
        
        
        call canonical_on
        pop eax
        pop edx
        pop ecx
        pop ebx
       
        ret
;-----------------------------------------------------------------------------------------

    getche:
             ;apagar nodo canonico
        call canonical_off
        ;guardar lo que tenia registro eax, ebx,ecx
        
        push ebx
        push ecx
        push edx
        push eax
        ;llamada servicio sys read
        mov eax, 3 
        ;origen teclado
        mov ebx, 0
        ;mov a puntero de texto lo pusheado a la pila 
        mov ecx, esp
        ;tamano a leer
        mov edx, 1 
        int 0x80 
        
        
        call canonical_on
        pop eax
        call putchar
        pop edx
        pop ecx
        pop ebx
       
        ret


;-----------------------------------------------------------------------------------------
    ;recibe en edx el puntero de la cadena 
    puts:
                push eax
    .comparar:  cmp byte [edx],0
                je .terminar
                mov al,[edx];
                call putchar
                add edx,1
                jmp .comparar
    .terminar:  pop eax
                ret






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


    mayusculas:

    ;si lo de la cadena es igual a \0 terminar
    .comparacionM:  cmp byte [edx],0
                    je .terminarM
                
    ;si lo de la cadena es mayor a 96 y menor 
    .liminf:    cmp byte [edx],96
                jg .limsup
                jmp .aumento

    .limsup:    cmp byte [edx], 123
                jl .cambioM
                jmp .aumento

    .cambioM:   sub byte [edx],32
    .aumento:   add edx, 1
                jmp .comparacionM

    .terminarM: ret

;-------------------------------------------------------------------------------------------
                
minusculas:

    ;si lo de la cadena es igual a \0 terminar
    .comparacionM:  cmp byte [edx],0
                    je .terminarM
                
    ;si lo de la cadena es mayor a 64 y menor 91
    .liminf:    cmp byte [edx],64
                jg .limsup
                jmp .aumento

    .limsup:    cmp byte [edx], 91
                jl .cambioM
                jmp .aumento

    .cambioM:   add byte [edx],32
    .aumento:   add edx, 1
                jmp .comparacionM

    .terminarM: ret

;-----------------------------------------------------------------------------
                




    borrar:
        push eax 
        ;0x8 en ascii es backspace
        mov al,0x8
        call putchar    
        mov al,' '
        call putchar
        mov al,0x8
        call putchar   
        pop eax
        ret 