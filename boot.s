; boot.s - multiboot header + entry
BITS 32
section .multiboot
align 4
multiboot_header:
    dd 0x1BADB002
    dd 0x00010003
    dd -(0x1BADB002 + 0x00010003)

section .text
global start_kernel
extern kernel_main
start_kernel:
    call kernel_main
.hang:
    cli
    hlt
    jmp .hang
