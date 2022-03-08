#include "sc_print.h"
//#include "sc_print.c"
#include <stdint.h>

#include "struct.c"

void main() {
    volatile my_device_t* my_device = (my_device_t*) APB3_INPUT_DATA_REG_ADDR;

    uint32_t temp_var;

    my_device->input_data.data      = 0xBAADC0DE;
    my_device->flags.calc_start     = 0x1;

    while(temp_var != 0x1) {
        temp_var = my_device->flags.calc_finish;
    }

    if(my_device->result.value == 0xB12E)
        my_device->status.value     = 0xFFFF; // GOOD
    else
        my_device->status.value     = 0xBEDA; // ERROR

}