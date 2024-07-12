ORG 0
BITS 16  ; Specify 16-bit architecture

_start:
    jmp short start   ; Jump over the BIOS Parameter Block
    nop           

times 33 db 0         ; BIOS Parameter Block: 33 bytes of zeros

start:
    jmp 0x7c0:begin    ; Jump to the beginning of our bootloader code


handle_interrupt_zero:
    mov ah, 0eh       
    mov al, 'C'        
    int 0x10           
    iret               

handle_interrupt_one:
    mov ah, 0eh        
    mov al, 'V'        
    int 0x10           
    iret               

handle_interrupt_two:
    mov si, interrupt_two_message  
    call print         ; Call the print subroutine to display the message
    iret               

begin:
    cli                
    
    ; Set up segment registers
    mov ax, 0x7c0       
    mov ds, ax          
    mov es, ax          
    mov ax, 0x00        
    mov ss, ax          
    mov sp, 0x7c00      

    sti                 ; Enable interrupts

    mov ah, 2
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov bx, buffer
    int 0x13
    jc error

    mov si, buffer
    call print

    mov word [ss:0x00], handle_interrupt_zero  
    mov word [ss:0x02], 0x7c0                  

    mov word [ss:0x04], handle_interrupt_one   
    mov word [ss:0x06], 0x7c0                  
    mov word [ss:0x08], handle_interrupt_two   ; Entry for interrupt 2 (0x02)
    mov word [ss:0x0A], 0x7c0                  ; Segment address of ISR

    int 2               ; Trigger interrupt 2

    ; Display boot message
    mov si, message     
    call print          

    jmp $               ; Infinite loop

error:
    mov si, error_message
    call print 
    jmp $

print:
.loop:
    lodsb               
    cmp al, 0           
    je .done           
    call print_char     
    jmp .loop           
.done:
    ret                 

print_char:
    mov ah, 0eh         
    int 0x10            
    ret                 


message: db 'Booting OS', 0                  ; Null-terminated boot message
interrupt_two_message: db 'INT TWO | ', 0       ; Null-terminated message for interrupt 2
error_message: db ' !Error Occured', 0
times 510-($ - $$) db 0                      ; Fill remaining space in boot sector
dw 0xAA55                                     ; Boot signature 55AA

buffer: 
