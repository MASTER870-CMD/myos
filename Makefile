CC = gcc
LD = i686-elf-ld
AS = nasm
OBJCOPY = i686-elf-objcopy

CFLAGS = -m32 -ffreestanding -O2 -Wall -Wextra -fno-builtin
LDFLAGS = -m elf_i386 -T linker.ld

OBJS = boot.o kernel.o  # Removed apps.o since it's not being used

all: myos.iso

boot.o: boot.s
	nasm -f elf32 boot.s -o boot.o

kernel.o: kernel.c font8x8_basic.h
	$(CC) $(CFLAGS) -c kernel.c -o kernel.o

kernel.bin: $(OBJS) linker.ld
	$(LD) -m elf_i386 -T linker.ld -o kernel.elf $(OBJS)
	$(OBJCOPY) -O binary kernel.elf kernel.bin

myos.iso: kernel.bin
	@mkdir -p isodir/boot/grub
	@cp kernel.bin isodir/boot/kernel.bin
	@cp grub/grub.cfg isodir/boot/grub/grub.cfg
	@grub-mkrescue -o myos.iso isodir || (echo "grub-mkrescue failed; ensure grub-pc-bin and xorriso are installed"; exit 1)

clean: 
	rm -f *.o kernel.elf kernel.bin myos.iso
	rm -rf isodir
