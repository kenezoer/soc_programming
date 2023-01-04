#include <stdint.h>
#include <stdio.h>

void main() {
 
    int x = 0;
    //| Print your code Here
    do {
        x++;
    } while(x != 500);

    volatile uint32_t* user_signal = (uint32_t*)0x11000;
    *user_signal = x;

}