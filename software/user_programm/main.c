#include <stdint.h>
#include <stdio.h>

#define MMIO32(addr)            ( *(volatile uint32_t *)(addr)  )

#define USER_MODULE_BASEADDR    ( 0x11000                       )
#define POLY_REG                ( USER_MODULE_BASEADDR + 0x0    )
#define DATA_IN_REG             ( USER_MODULE_BASEADDR + 0x4    )
#define DATA_OUT_REG            ( USER_MODULE_BASEADDR + 0x8    )
#define CONTROL_REG             ( USER_MODULE_BASEADDR + 0xC    )

uint8_t CheckBusy() {
    uint32_t    control_reg    = MMIO32(CONTROL_REG);
    uint8_t     busy_flag      = (uint8_t)(control_reg >> 24) & 0x1;
    return      busy_flag;
};

void MakeInit() {
    while(CheckBusy());
    uint32_t    control_reg     = 0x1 << 8;
    MMIO32(CONTROL_REG)         = control_reg;
}

void MakeStart() {
    while(CheckBusy());
    uint32_t    control_reg     = 0x1;
    MMIO32(CONTROL_REG)         = control_reg;
}

void WaitUntilFinish() {
    uint32_t    control_reg;

    // Wait untill finish_status from control_reg will be asserted
    do {
        control_reg = MMIO32(CONTROL_REG);
        control_reg = (control_reg >> 16) & 0x1;
    } while(control_reg == 0x0);

    // clear finish_status flag for next correct checkout
    control_reg         = 0x1 << 16;
    MMIO32(CONTROL_REG) = control_reg;
}


void LoadNewData(uint32_t data) {
    while(CheckBusy());
    MMIO32(DATA_IN_REG) = data;
}

uint32_t GetData() { 
    return MMIO32(DATA_OUT_REG);
}

void main() {

    MakeInit();
    LoadNewData(0xAAAABBBB);
    MakeStart();
    WaitUntilFinish();
    uint32_t given_value = GetData();

    LoadNewData(given_value);
    
}