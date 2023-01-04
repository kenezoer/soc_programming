/* 
 * ----------------------------------------------------------------------------
 *  Project:  YetAnotherUART
 *  Filename: yaUART.c
 *  Purpose:  UART Driver for Application-Specified CPUs
 * ----------------------------------------------------------------------------
 *  Copyright © 2020-2023, Kirill Lyubavin <kenezoer@gmail.com>
 *  
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *  
 *      http://www.apache.org/licenses/LICENSE-2.0
 *  
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 * ----------------------------------------------------------------------------
 */

#ifndef     __YaUART_DEFINED__
#define     __YaUART_DEFINED__

#include "yaUART.h"


/*
 * ____________________________________________________________________________
 *
 * @brief The function is used to set up baudrate
 *
 * @param[in]   uint32_t baudrate       Baudrate value to set
 * ____________________________________________________________________________
 *
 */

static void YaUART_SetBaudrate(uint32_t baudrate) {

    uint32_t    baudrate_val = (uint32_t)YAUART_CLK_FREQ_HZ / baudrate;
    YAUART_MMIO32(YAUART_REG_UART_BIT_LENGTH)   = baudrate_val;

}

/*
 * ____________________________________________________________________________
 *
 * @brief The function is used to set up UART to work with typical settings
 * ____________________________________________________________________________
 *
 */

void YaUART_Init() {

    uint32_t    ctrl    = 0x0;

    //| We don't need to send parity bit
    ctrl    = ctrl | YAUART_REG_CTRL_SEND_PARITY;

    //| Set stop bit value as 0x1
    ctrl    = ctrl | YAUART_REG_CTRL_STOP_BIT_VALUE_1_0;

    //| Set stop bit mode as 1 bit
    ctrl    = ctrl | YAUART_REG_CTRL_STOP_BIT_MODE_1_0;

    //| Turn off Hardware flow control
    ctrl    = ctrl & ~YAUART_REG_CTRL_HW_FLOW_CTRL_EN;

    //| Turn on MSB First mode
    ctrl    = ctrl | YAUART_REG_CTRL_MSB_FIRST;

    //| Make a reset for both fifos
    ctrl    = ctrl | YAUART_REG_CTRL_UFIFO_RST;
    ctrl    = ctrl | YAUART_REG_CTRL_DFIFO_RST;

    //| Write settings into UART Control register
    YAUART_MMIO32(YAUART_REG_CTRL) = ctrl;

    //| Set UART BaudRate
    YaUART_SetBaudrate(YAUART_DEFAULT_BAUDRATE);

    //| De-assert fifo reset
    ctrl    = ctrl & ~YAUART_REG_CTRL_UFIFO_RST;
    ctrl    = ctrl & ~YAUART_REG_CTRL_DFIFO_RST;

    //| Write settings into UART Control register
    YAUART_MMIO32(YAUART_REG_CTRL) = ctrl;
}


/*
 * ____________________________________________________________________________
 *
 * @brief The function is used to set up baudrate
 *
 * @retval 0x1 UART is ready to transmit new byte
 * @retval 0x0 UART is not ready to transmit new byte
 * ____________________________________________________________________________
 *
 */

uint8_t YaUART_TxReady() {
    uint32_t    regval      = YAUART_MMIO32(YAUART_REG_STATS);
                regval      = regval & YAUART_REG_STATS_DFIFO_FULL;
    return (regval ? 0x0 : 0x1);
}


/*
 * ____________________________________________________________________________
 *
 * @brief The function is used to set up baudrate
 *
 * @retval 0x1 UART is ready to receive new byte
 * @retval 0x0 UART is not ready to receive new byte
 * ____________________________________________________________________________
 *
 */

uint8_t YaUART_RxReady() {
    uint32_t    regval      = YAUART_MMIO32(YAUART_REG_STATS);
                regval      = regval & YAUART_REG_STATS_UFIFO_EMPTY;
    return (regval ? 0x0 : 0x1);
}


/*
 * ____________________________________________________________________________
 *
 * @brief The function is used to send byte message
 *
 * @param[in]   uint32_t data       Byte to send (rounded to dword because of APB Interface, valid only lowest byte)
 * ____________________________________________________________________________
 *
 */

void YaUART_PutChar(uint32_t data) {
    while(!YaUART_TxReady());

    YAUART_MMIO32(YAUART_REG_DFIFO) = data;
}


/*
 * ____________________________________________________________________________
 *
 * @brief The function is used to receive byte message
 *
 * @retval   char       Given Char
 * ____________________________________________________________________________
 *
 */

uint8_t YaUART_GetChar() {
    while(!YaUART_RxReady());

    return (uint8_t)(YAUART_MMIO32(YAUART_REG_UFIFO));
}


/*
 * ____________________________________________________________________________
 *
 * @brief The function is used to receive byte message (not blocking)
 *
 * @retval   char       Given Char
 * ____________________________________________________________________________
 *
 */

uint8_t YaUART_GetCharNB() {

    if (YaUART_RxReady()) {
        return (uint8_t)(YAUART_MMIO32(YAUART_REG_UFIFO));
    }

    return -1;
}


/*
 * ____________________________________________________________________________
 *
 * @brief The function is allows you to wait until UART will be ready to receive new packet for transmit
 * ____________________________________________________________________________
 *
 */

void YaUART_TxFlush() {

    uint32_t    regval;

    do {
        regval      = YAUART_MMIO32(YAUART_REG_STATS);
        regval      = regval & YAUART_REG_STATS_DFIFO_EMPTY;
    } while (!regval);

}



#endif    /* __YaUART_DEFINED__ */
