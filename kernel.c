typedef unsigned int u32;

#include "font8x8_basic.h"

// VGA text buffer starts here
unsigned short *VGA_BUFFER = (unsigned short *)0xB8000;
int VGA_INDEX = 0;

// Function to print a single character
void print_char(char c, char color) {
    // Use the font8x8_basic array to get the character bitmap
    unsigned char *char_bitmap = font8x8_basic[(unsigned char)c];  // Cast to unsigned char
    for (int i = 0; i < 8; i++) {
        unsigned char row = char_bitmap[i];
        for (int j = 0; j < 8; j++) {
            if (row & (1 << (7 - j))) {
                VGA_BUFFER[VGA_INDEX] = (color << 8) | (c); // Drawing the pixel
            }
            VGA_INDEX++;
        }
    }
}

// Function to print a string
void print_string(const char *str, char color) {
    while (*str) {
        print_char(*str++, color);
    }
}

// Kernel entry point
void kmain(void) {
    for (int i = 0; i < 80 * 25; i++) {
        VGA_BUFFER[i] = (0x07 << 8) | ' '; // Clear the screen (fill with spaces)
    }
    VGA_INDEX = 0;

    print_string("Welcome to Ultraviolet OS!", 0x0F); // White text
    print_string("\nHello, World!", 0x0E);            // Yellow text
}
