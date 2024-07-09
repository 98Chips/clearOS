;BIOS loads kernel into address 0x7c00
ORG 0x7c00

BITS 16 ;using 16 bit architecture

start:
    mov ah, 0eh
    mov al, 'A'
    int 0x10

    jmp $

times 510-($ - $$) db 0
dw 0xAA55 ;Boot signuature 55AA
    