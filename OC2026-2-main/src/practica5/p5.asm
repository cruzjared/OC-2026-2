%include "../../lib/pc_io.inc"   ; incluir declaraciones de procedimiento externos

section .text
    global _start         ; referencia para inicio de programa
    
_start:   
    ; --- IMPRIMIR CADENA COMPLETA ---
    mov edx, msg          ; edx = dirección de la cadena msg
    call puts             ; imprime cadena
    mov byte[msg + 26 ], '@' ; inciso C
	call puts 
    mov ecx, 25 ;inciso D
    mov al, 'Z'
    mov byte [edx + ecx], al
    call puts
    mov ecx, 10;inciso E
    mov al, 'P' ; subregistro de eax de 8 bits
    mov byte[edx+ecx+5], al
    call puts
    ;inciso f
    mov ecx, 2
    mov ebx, edx ;copiar inicio de cadena y aumentarle 15
    add ebx,15
    mov al, '%'
    mov byte[ebx+ecx*2], al
    call puts

    ; --- FIN DE PROGRAMA ---
    mov eax, 1            ; Llamada sys_exit
	xor ebx, ebx          ; return 0
    int 0x80              ; Fin de programa

section .data
    msg db 'abcdefghijklmnopqrstuvwxyz0123456789', 0xa, 0
    salto db 0xa
    uno db 'Z'  