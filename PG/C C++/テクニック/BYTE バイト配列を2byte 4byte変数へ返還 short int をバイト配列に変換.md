```
#include <stdio.h>
#define U2_BYTES 2
#define U4_BYTES 4
#define BYTE_BITS 8
#define BYTE_MASK 0xFF

/* FF 1234567890 FF */
static const unsigned char BUFFER[6] = 
{
    0xFF, 0xD2, 0x02, 0x96, 0x49, 0xFF
};

void set_word(unsigned char* buffer, unsigned short value)
{
    for (int i = 0; i < U2_BYTES; i++) {
        buffer[i] = (unsigned char)((value >> (i * BYTE_BITS)) & BYTE_MASK);
    }
    return;
}
unsigned short get_word(unsigned char* buffer)
{
    unsigned short value = 0;
    for (int i = (U2_BYTES - 1) ; 0 <= i; i--) {
        value |= (unsigned int)buffer[i] << (i * BYTE_BITS);
    }
    
    return value;
}

void set_dword(unsigned char* buffer, unsigned int value)
{
    for (int i = 0; i < U4_BYTES; i++) {
        buffer[i] = (unsigned char)((value >> (i * BYTE_BITS)) & BYTE_MASK);
    }
    return;
}
unsigned int get_dword(unsigned char* buffer)
{
    unsigned int value = 0;
    /* BIG ENDIAN
    for (int i = ; i < 4; i++) {
        value |= (unsigned int)buffer[i] << (32 - ((i + 1) * 8));
    }
    */
    for (int i = (U4_BYTES - 1) ; 0 <= i; i--) {
        value |= (unsigned int)buffer[i] << (i * BYTE_BITS);
    }
    
    return value;
}
int main(void){
    unsigned int buffer[6] = {0};
    // Your code here!
    printf("%u\n", *((unsigned int *)(&BUFFER[1])));
    printf("%u\n", get_dword(&BUFFER[1]));
    
    set_word(&buffer[1], 1234567890u);
    printf("%u\n", get_dword(&buffer[1]));
    
    return 0;
}
```
