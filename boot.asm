ORG 0
BITS 16 ;using 16 bit architecture

_start:
    jmp short start
    nop

times 33 db 0 ;creates 33 bytes for BIOS Parameter Block by filling null bytes
start:
    jmp 0x7c0:begin

begin:
    cli ;   Clear interrupts
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax 
    sti ;   Enables interrupts
    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7c00
    mov si, message ;   Mov addr of message label in si reg
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
dw 0xAA55 ; Boot signuature 55AA
