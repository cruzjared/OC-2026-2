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
    call captura    
    call captura  
       
    jmp .fin_programa  
    
    
    
; ----------------------------------------------------------------------------------------
    .fin_programa: 
        mov edx, nline    
        call puts     
        call puts     
        mov eax, 1            ; Llamada sys_exit
	    xor ebx, ebx          ; return 0
        int 0x80              ; Fin de programa

   
    captura:

            ;i = ebx
            mov ebx,0
            mov ecx,1
            mov eax, lencadena
    ;si lencadena - i = 0, terminar, si no continuar
    .comparacion:   cmp eax,ebx
                    je terminar

                    ;leer tecla presionada
                    push ax
                    call getch
                    ;si lo leido por getch es \n, terminar
                    cmp al,ln
                    je terminar
                    ;si lo leido es igual a borrar, evaluar
                    cmp al, bskey
                    je evaluar
                    jmp guardar
                    ; i < 1, no se puede borar
    .evaluar:       cmp ebx,ecx
                    jl borrar

                    ;si no se tuvo que borrar, guardar la letra en la direccion de memoria
    .guardar:       mov [edx], al
                    add edx,1
                    call putchar
                    pop ax
                    ;i++
                    add ebx,1
                    jmp comparacion

    .terminar:      mov byte[edx], 0
                    ret
                    
    .borrar:        call borrar
                    sub ebx,1
                    sub,edx,1
                    jmp comparacion
             

    ;.sig:   call putchar
           ; pop ax
           ; ret

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