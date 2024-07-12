# Bootloader with Interrupt Handling

This repository contains assembly code (`boot.asm`) for a simple bootloader that demonstrates interrupt handling and basic disk I/O operations. The bootloader is designed to be compiled into a binary file (`boot.bin`) that can be used to boot a compatible x86 system.

## Features

- **Interrupt Handling**: Handles three interrupts (`int 0`, `int 1`, and `int 2`) with corresponding handlers that print characters and messages to the screen.
- **Disk I/O**: Reads sectors from the disk using BIOS interrupt `int 0x13`.
- **Message Display**: Displays messages such as "Booting OS", "INT TWO |", and error messages on the screen.
- **Infinite Loop**: After initialization, enters an infinite loop to maintain control and continue displaying messages.

## File Structure

- `boot.asm`: Assembly code file containing the bootloader code.
- `makefile`: Makefile to automate the compilation process.
- `text.txt`: Text file used in the boot image (`boot.bin`).

## Usage

1. **Compile the Bootloader**:
nasm -f bin ./boot.asm -o ./boot.bin


2. **Create Boot Image**:
- Append additional data (`text.txt`) and fill the rest with zeros:
  ```
  dd if=./text.txt >> ./boot.bin
  dd if=/dev/zero bs=512 count=1 >> ./boot.bin
  ```

3. **Boot the Image**:
- Use a virtual machine or emulator that supports booting from a disk image (e.g., QEMU, VirtualBox).

## Understanding the Code

- **Interrupt Handlers**: Each interrupt handler (`handle_interrupt_zero`, `handle_interrupt_one`, `handle_interrupt_two`) demonstrates different ways to use BIOS interrupts (`int 0x10` for screen output, `int 0x13` for disk I/O).
- **Message Printing**: Messages are printed using a subroutine (`print`) that loops through characters and uses BIOS interrupt `int 0x10`.
- **Error Handling**: Includes an error message displayed when a disk read operation fails (`jc error`).

## Requirements

- NASM (Netwide Assembler) for compiling assembly code.
- An x86-compatible virtual machine or emulator for testing the bootloader.
