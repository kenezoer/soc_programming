#include <stdint.h>

#define APB3_DEVICE_BASE_ADDRESS        0x400

// Offsets
#define APB3_INPUT_DATA_REG_ADDR_OFFSET 0x0
#define APB3_RESULT_REG_ADDR_OFFSET     0x4
#define APB3_FLAGS_REG_ADDR_OFFSET      0x8
#define APB3_STATUS_REG_ADDR_OFFSET     0xC

// Real Addresses
#define APB3_INPUT_DATA_REG_ADDR (APB3_DEVICE_BASE_ADDRESS + APB3_INPUT_DATA_REG_ADDR_OFFSET)
#define APB3_RESULT_REG_ADDR     (APB3_DEVICE_BASE_ADDRESS + APB3_RESULT_REG_ADDR_OFFSET)
#define APB3_FLAGS_REG_ADDR      (APB3_DEVICE_BASE_ADDRESS + APB3_FLAGS_REG_ADDR_OFFSET)
#define APB3_STATUS_REG_ADDR     (APB3_DEVICE_BASE_ADDRESS + APB3_STATUS_REG_ADDR_OFFSET)


typedef struct {
    uint32_t    input_data;
    uint32_t    result;
    uint32_t    flags;
    uint32_t    status;
} my_device_t;


void main() {

    volatile my_device_t* my_device = (my_device_t*) APB3_DEVICE_BASE_ADDRESS;

    uint32_t    temp_var;

    my_device->input_data   = 0xbaadc0de;
    my_device->flags        = 0x1;


    while(temp_var != 0x1) {
        temp_var    = (my_device->flags & (uint32_t)0x00010000) >> 16;
        my_device->status = temp_var;
    }

    
    if(my_device->result == 0xB12E)
        my_device->status     = 0xFFFF; // GOOD
    else
        my_device->status     = 0xBEDA; // ERROR

}