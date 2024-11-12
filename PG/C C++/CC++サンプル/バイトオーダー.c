#include <stdio.h>

#define DATA_MASK (unsigned int)(0x000000FFu)
#define BIT_PER_BYTE (8u)
#define DATA_LENGTH (4u)

int main(void){
    const unsigned int target_data = 0x11223344;
    int target_bytes = DATA_LENGTH;
    int bit_shift_max = (target_bytes - 1) * BIT_PER_BYTE;
    unsigned int bit_shift_result = 0;
    unsigned char data_result[DATA_LENGTH] = {0x00};
    
    for (int i = 0; i < target_bytes; i++) {
        //ビットをシフトする
        bit_shift_result = target_data >> (bit_shift_max - (i * BIT_PER_BYTE));
        // 結果を格納
        data_result[i] = (unsigned char)(bit_shift_result & DATA_MASK);
    }
    
    printf("target_data=%X\n", target_data);
    printf("data_result=%X\n", (unsigned int)(*(unsigned int*)data_result));
    // Your code here!
    return 0;
}

// https://paiza.io/ja
/*
target_data=11223344
data_result=44332211
*/
/*
C言語でバイトオーダー変換
https://qiita.com/stanaka2/items/8b5da26302ec1eb2930f
*/
