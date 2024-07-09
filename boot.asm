;BIOS loads kernel into address 0x7c00
ORG 0x7c00

BITS 16 ;using 16 bit architecture

start:
    mov si, message ;mov addr of message label in si reg
    call print
    jmp $


print:
.loop:
    lodsb
    cmp al,0
    je .done
    call print_char
    jmp .loop
.done:
    ret

print_char:
    mov ah, 0eh
    int 0x10
    ret

message: db 'Booting OS' , 0

times 510-($ - $$) db 0
dw 0xAA55 ;Boot signuature 55AA
