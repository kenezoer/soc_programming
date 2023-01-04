/* 
 * ----------------------------------------------------------------------------
 *  Project:  YetAnotherUART
 *  Filename: yaUART.h
 *  Purpose:  UART Driver for Application-Specified CPUs (header)
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

#ifndef     __YaUART_HEADER_DEFINED__
#define     __YaUART_HEADER_DEFINED__


    #include <stdint.h>
    
    /* ------------------------------------------------------------------------------------------------------ */
    /* YetAnotherUART Settings  */

    #define YAUART_BASE_ADDR                        ( 0x11000                                               )
    #define YAUART_CLK_FREQ_HZ                      ( 50000000                                              )
    #define YAUART_DEFAULT_BAUDRATE                 ( 115200                                                )

    /* ------------------------------------------------------------------------------------------------------ */
    /* Useful define for Memory Mapped IO Transactions */

    #define YAUART_MMIO32(addr)                     ( *(volatile uint32_t *)(addr)                          )

    /* ------------------------------------------------------------------------------------------------------ */
    /* Register map */

    #define YAUART_REG_HWINFO                       ( YAUART_BASE_ADDR  + 0x20                              )
    #define YAUART_REG_STATS                        ( YAUART_BASE_ADDR  + 0x1C                              )
    #define YAUART_REG_UFIFO                        ( YAUART_BASE_ADDR  + 0x18                              )
    #define YAUART_REG_IRQ_EVENT                    ( YAUART_BASE_ADDR  + 0x14                              )
    #define YAUART_REG_IRQ_MASK                     ( YAUART_BASE_ADDR  + 0x10                              )
    #define YAUART_REG_IRQ_EN                       ( YAUART_BASE_ADDR  + 0xC                               )
    #define YAUART_REG_UART_BIT_LENGTH              ( YAUART_BASE_ADDR  + 0x8                               )
    #define YAUART_REG_CTRL                         ( YAUART_BASE_ADDR  + 0x4                               )
    #define YAUART_REG_DFIFO                        ( YAUART_BASE_ADDR  + 0x0                               )

    /* ------------------------------------------------------------------------------------------------------ */
    /* Regfields definition */


    //| Register: CTRL --------------------------------------------------------------------------------------
    #define YAUART_REG_CTRL_SEND_PARITY             ( (uint32_t)0x1 << 8                                    )
    #define YAUART_REG_CTRL_UFIFO_RST               ( (uint32_t)0x1 << 7                                    )
    #define YAUART_REG_CTRL_DFIFO_RST               ( (uint32_t)0x1 << 6                                    )
    #define YAUART_REG_CTRL_MSB_FIRST               ( (uint32_t)0x1 << 5                                    )
    #define YAUART_REG_CTRL_HW_FLOW_CTRL_EN         ( (uint32_t)0x1 << 4                                    )

    #define YAUART_REG_CTRL_STOP_BIT_VALUE_OFST     ( 2                                                     )
    #define YAUART_REG_CTRL_STOP_BIT_VALUE_MASK     ( (uint32_t)0x3 << YAUART_REG_CTRL_STOP_BIT_VALUE_OFST  )
    #define YAUART_REG_CTRL_STOP_BIT_VALUE_0_0      ( (uint32_t)0x0 << YAUART_REG_CTRL_STOP_BIT_VALUE_OFST  )
    #define YAUART_REG_CTRL_STOP_BIT_VALUE_0_1      ( (uint32_t)0x1 << YAUART_REG_CTRL_STOP_BIT_VALUE_OFST  )
    #define YAUART_REG_CTRL_STOP_BIT_VALUE_1_0      ( (uint32_t)0x2 << YAUART_REG_CTRL_STOP_BIT_VALUE_OFST  )
    #define YAUART_REG_CTRL_STOP_BIT_VALUE_1_1      ( (uint32_t)0x3 << YAUART_REG_CTRL_STOP_BIT_VALUE_OFST  )

    #define YAUART_REG_CTRL_STOP_BIT_MODE_OFST      ( 0                                                     )
    #define YAUART_REG_CTRL_STOP_BIT_MODE_MASK      ( (uint32_t)0x3 << YAUART_REG_CTRL_STOP_BIT_MODE_OFST   )
    #define YAUART_REG_CTRL_STOP_BIT_MODE_0_5       ( (uint32_t)0x0 << YAUART_REG_CTRL_STOP_BIT_MODE_OFST   )
    #define YAUART_REG_CTRL_STOP_BIT_MODE_1_0       ( (uint32_t)0x1 << YAUART_REG_CTRL_STOP_BIT_MODE_OFST   )
    #define YAUART_REG_CTRL_STOP_BIT_MODE_1_5       ( (uint32_t)0x2 << YAUART_REG_CTRL_STOP_BIT_MODE_OFST   )
    #define YAUART_REG_CTRL_STOP_BIT_MODE_2_0       ( (uint32_t)0x3 << YAUART_REG_CTRL_STOP_BIT_MODE_OFST   )

    //| Registers: IRQ --------------------------------------------------------------------------------------
    #define YAUART_REG_IRQ_TX_STARTED               ( (uint32_t)0x1 << 0                                    )
    #define YAUART_REG_IRQ_TX_DONE                  ( (uint32_t)0x1 << 1                                    )
    #define YAUART_REG_IRQ_RX_STARTED               ( (uint32_t)0x1 << 2                                    )
    #define YAUART_REG_IRQ_RX_DONE                  ( (uint32_t)0x1 << 3                                    )
    #define YAUART_REG_IRQ_DFIFO_ERROR              ( (uint32_t)0x1 << 4                                    )
    #define YAUART_REG_IRQ_DFIFO_EMPTY              ( (uint32_t)0x1 << 5                                    )
    #define YAUART_REG_IRQ_UFIFO_ERROR              ( (uint32_t)0x1 << 6                                    )
    #define YAUART_REG_IRQ_UFIFO_FULL               ( (uint32_t)0x1 << 7                                    )
    #define YAUART_REG_IRQ_UART_PARITY_ERR          ( (uint32_t)0x1 << 8                                    )
    #define YAUART_REG_IRQ_UART_BAD_FRAME           ( (uint32_t)0x1 << 9                                    )

    //| Registers: HWINFO -----------------------------------------------------------------------------------
    #define YAUART_REG_HWINFO_PARITY_CHECK_EN_OFST  ( (uint32_t)0x1 << 31                                   )

    #define YAUART_REG_HWINFO_UFIFO_DEPTH_OFST      ( 16                                                    )
    #define YAUART_REG_HWINFO_UFIFO_DEPTH_MASK      ( (uint32_t)0xFF << YAUART_REG_HWINFO_UFIFO_DEPTH_OFST  )

    #define YAUART_REG_HWINFO_DFIFO_DEPTH_OFST      ( 8                                                     )
    #define YAUART_REG_HWINFO_DFIFO_DEPTH_MASK      ( (uint32_t)0xFF << YAUART_REG_HWINFO_DFIFO_DEPTH_OFST  )

    #define YAUART_REG_HWINFO_IP_VERSION_OFST       ( 0                                                     )
    #define YAUART_REG_HWINFO_IP_VERSION_MASK       ( (uint32_t)0xFF << YAUART_REG_HWINFO_IP_VERSION_OFST   )

    //| Registers: STATS ------------------------------------------------------------------------------------
    #define YAUART_REG_STATS_RX_STATUS              ( (uint32_t)0x1 << 26                                   )
    #define YAUART_REG_STATS_UFIFO_FULL             ( (uint32_t)0x1 << 25                                   )
    #define YAUART_REG_STATS_UFIFO_EMPTY            ( (uint32_t)0x1 << 24                                   )
    #define YAUART_REG_STATS_UFIFO_USED_OFST        ( 16                                                    )
    #define YAUART_REG_STATS_UFIFO_USED_MASK        ( (uint32_t)0xFF << YAUART_REG_STATS_UFIFO_USED_OFST    )
    #define YAUART_REG_STATS_TX_STATUS              ( (uint32_t)0x1 << 10                                   )
    #define YAUART_REG_STATS_DFIFO_FULL             ( (uint32_t)0x1 << 9                                    )
    #define YAUART_REG_STATS_DFIFO_EMPTY            ( (uint32_t)0x1 << 8                                    )
    #define YAUART_REG_STATS_DFIFO_USED_OFST        ( 0                                                     )
    #define YAUART_REG_STATS_DFIFO_USED_MASK        ( (uint32_t)0xFF << YAUART_REG_STATS_DFIFO_USED_OFST    )

    /* ------------------------------------------------------------------------------------------------------ */
    /* Base function prototypes */

    void    YaUART_Init();
    uint8_t YaUART_TxReady();
    uint8_t YaUART_RxReady();
    void    YaUART_PutChar(uint32_t data);
    uint8_t YaUART_GetChar();
    uint8_t YaUART_GetCharNB();
    void    YaUART_TxFlush();

#endif   /* __YaUART_HEADER_DEFINED__ */