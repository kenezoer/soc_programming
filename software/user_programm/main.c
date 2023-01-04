#include <stdint.h>
#include <stdio.h>
#include "sc_print.h"
#include "yaUART.h"

void main() {

    YaUART_Init();
 
    int x = 0;
    //| Print your code Here
    do {
        x++;
    } while(x != 500);

    volatile uint32_t* user_signal = (uint32_t*)0x11000;
    *user_signal = x;

    sc_printf("test");

}