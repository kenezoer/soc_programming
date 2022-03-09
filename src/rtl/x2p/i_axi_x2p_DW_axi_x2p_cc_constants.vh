/*
 ------------------------------------------------------------------------
--
// ------------------------------------------------------------------------------
// 
// Copyright 2001 - 2020 Synopsys, INC.
// 
// This Synopsys IP and all associated documentation are proprietary to
// Synopsys, Inc. and may only be used pursuant to the terms and conditions of a
// written license agreement with Synopsys, Inc. All other use, reproduction,
// modification, or distribution of the Synopsys IP or the associated
// documentation is strictly prohibited.
// 
// Component Name   : DW_axi_x2p
// Component Version: 2.04a
// Release Type     : GA
// ------------------------------------------------------------------------------

// 
// Release version :  2.04a
// File Version     :        $Revision: #1 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2p/amba_dev/src/DW_axi_x2p_cc_constants.vh#1 $ 
*/

//
//
//-----------------------------------------------------------------------------
// Description : This file contains all configuration parameters.
//-----------------------------------------------------------------------------

//==============================================================================
// Start Guard: prevent re-compilation of includes
//==============================================================================
`define i_axi_x2p___GUARD__DW_AXI_X2P_CC_CONSTANTS__VH__

// AXI INTERFACE SETUP


// Name:         X2P_AXI_INTERFACE_TYPE
// Default:      AXI3
// Values:       AXI3 (0), AXI4 (1)
// Enabled:      [<functionof> %item]
// 
// Select AXI Interface Type as AXI3 or AXI4. By default, DW_axi_x2p supports the AXI3 interface.
`define i_axi_x2p_X2P_AXI_INTERFACE_TYPE 0

//Creates a define if AXI3 is Enabled.

`define i_axi_x2p_X2P_AXI3_INTERFACE

//Creates a define if AXI4 is Enabled.

// `define i_axi_x2p_X2P_AXI4_INTERFACE


//Width of the AXI Lock bus.
//2 bits in AXI3 and 1 bit in AXI4

`define i_axi_x2p_X2P_AXI_LTW 2



// Name:         X2P_AXI_AW
// Default:      32
// Values:       32, ..., 64
// 
// Address bus width of the AXI system to which the bridge is attached as an AXI slave. The legal values comprise the full 
// range from 32 bits to 64 bits. The full range is used for the psel select signals, but only the lower 32 bits are passed 
// on to paddr.
`define i_axi_x2p_X2P_AXI_AW 32


// Name:         X2P_AXI_SIDW
// Default:      8
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
// 
// Read and write ID width of the AXI system to which the bridge is attached as an AXI slave.
`define i_axi_x2p_X2P_AXI_SIDW 4


// Name:         X2P_IDLE_VAL
// Default:      0
// Values:       0 1
// 
// Parameter to decide the values to be driven during an idle cycle
`define i_axi_x2p_X2P_IDLE_VAL 0


// Name:         X2P_DEFAULT_VAL
// Default:      0
// Values:       0 1
// 
// Parameter to decide the default value of ready signals.
`define i_axi_x2p_X2P_DEFAULT_VAL 0


// Name:         X2P_AXI_DW
// Default:      32
// Values:       8 16 32 64 128 256 512
// 
// Read and write data bus width of the AXI system to which the bridge is attached as an AXI slave. Data bus width for the 
// AXI slave interface must be greater than or equal to that of the APB master interface.
`define i_axi_x2p_X2P_AXI_DW 32


// Name:         X2P_AXI_BLW
// Default:      4
// Values:       4 5 6 7 8
// 
// Width used for the AWLEN and ARLEN burst count field.
`define i_axi_x2p_X2P_AXI_BLW 4


// Name:         X2P_AXI_ENDIANNESS
// Default:      Little Endian
// Values:       Little Endian (0), Big Endian (1)
// 
// Data bus endianness of the AXI system to which the bridge is attached as an AXI slave. 
//  - 0: AXI bus is little-endian 
//  - 1: AXI bus is big-endian  
// The APB bus is always little endian. For more information, see the "Endian Adaptation (Byte Re-ordering)" section in 
// the DW_axi_x2p Databook.
`define i_axi_x2p_X2P_AXI_ENDIANNESS 0

//Creates a define for enabling Big endian

// `define i_axi_x2p_BIV_ENDIAN_ENABLE

//Creates a define for enabling Little endian

`define i_axi_x2p_LITTLE_ENDIAN_ENABLE

// APB INTERFACE SETUP


// Name:         X2P_APB_ADDR_WIDTH
// Default:      32
// Values:       32
// 
// Address bus width of the APB system to which the bridge is attached as an APB master.
`define i_axi_x2p_X2P_APB_ADDR_WIDTH 32


// Name:         X2P_APB_DATA_WIDTH
// Default:      32
// Values:       8 16 32
// 
// Read and write data bus width of the APB system to which the bridge is attached as an APB master. This width must be 
// equal or smaller than the width of the AXI data bus.
`define i_axi_x2p_X2P_APB_DATA_WIDTH 32



// Name:         X2P_ALLOW_SPARSE_TRANSFER
// Default:      false
// Values:       false (0), true (1)
// 
// Selects whether to generate the error response for the sparse write and read transfers or not. 
//  - True (1) - DW_axi_x2p does not generate the error for sparse transfers and passes the AXI transaction on to APB 
//  Interface. 
//  - False (0) - DW_axi_x2p generates an error resonse for sparse transfers. 
// For more information, see the "AXI-to-APB Sparse Transfers" section in the DW_axi_x2p Databook.
`define i_axi_x2p_X2P_ALLOW_SPARSE_TRANSFER 0

//Creates a define for Allow Sparse transfer on APB interface

// `define i_axi_x2p_X2P_ALLOW_SPARSE_TRANSFER_EN



// Name:         X2P_NUM_APB_SLAVES
// Default:      4
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
// 
// Number of APB Slave Ports.
`define i_axi_x2p_X2P_NUM_APB_SLAVES 1


// Name:         X2P_AXI_NUM_SLAVES
// Default:      0
// Values:       0, ..., 16
// 
// Number of AXI Slave Ports.
`define i_axi_x2p_X2P_AXI_NUM_SLAVES 0


// Name:         X2P_AXI_NUM_MASTERS
// Default:      1
// Values:       1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
// 
// Number of AXI Master Ports.
`define i_axi_x2p_X2P_AXI_NUM_MASTERS 1

//This is a testbench parameter. The design does not depend on this
//parameter. This parameter specifies the clock period of the primary AXI system

`define i_axi_x2p_SIM_AXI_CLK_PERIOD 100

//This is a testbench parameter. The design does not depend on this
//parameter. This parameter specifies the clock period of the APB system

`define i_axi_x2p_SIM_APB_CLK_PERIOD 100


// Name:         X2P_CLK_MODE
// Default:      Dual Clock
// Values:       Dual Clock (0), Single Clock (2)
// 
// Specifies the relationship between aclk and pclk. The AXI slave interface is clocked by aclk; the APB master interface 
// is clocked by pclk.  
//  - Dual Clock: aclk and pclk are different (asynchronous or quasi-synchronous) using synchronization register stages to 
//  a depth of X2P_DUAL_CLK_SYNC_DEPTH. 
//  - Single Clock: aclk and pclk are driven by the same clock signal.
`define i_axi_x2p_X2P_CLK_MODE 2



// Name:         X2P_DUAL_CLK_SYNC_DEPTH
// Default:      2
// Values:       0 2 3
// Enabled:      X2P_CLK_MODE == 0
// 
// Number of synchronization register stages in the internal channel fifos for signals crossing clock domains between AXI 
// and APB. When aclk and pclk are quasi-synchronous it should be possible to set this parameter to 0 to reduce the latency 
// across the bridge. This parameter is enabled only if dual clock mode is selected. If dual clock mode is not selected this 
// parameter is irrelevant.
`define i_axi_x2p_X2P_DUAL_CLK_SYNC_DEPTH 2


//Creates a define for enabling Single clock mode

`define i_axi_x2p_X2P_CLK_MODE_2


//Creates a define for enabling dual clock mode

// `define i_axi_x2p_X2P_CLK_MODE_0



// LOW POWER HANDSHAKING INTERFACE SETUP



// Name:         X2P_LOWPWR_HS_IF
// Default:      false
// Values:       false (0), true (1)
// 
// If true, the low-power handshaking interface (csysreq, csysack and cactive signals) and associated logic is implemented. 
// If false, support for low-power handshaking interface is not provided.
`define i_axi_x2p_X2P_LOWPWR_HS_IF 0


// Legacy low power interface selection

`define i_axi_x2p_X2P_LOWPWR_LEGACY_IF 0

//Creates a define for whether or not the low power handshaking interface
//exists.

// `define i_axi_x2p_X2P_HAS_LOWPWR_HS_IF

//Creates a define for whether or not the legacy low power handshaking
//interface exists.

// `define i_axi_x2p_X2P_HAS_LOWPWR_LEGACY_IF



// Name:         X2P_LOWPWR_NOPX_CNT
// Default:      0
// Values:       0, ..., 4294967295
// Enabled:      X2P_LOWPWR_HS_IF == 1
// 
// Number of AXI clock cycles to wait before cactive signal de-asserts, when there are no pending transactions. 
//  
// Note that if csysreq de-asserts while waiting this number of cycles, cactive will immediately de-assert. If a new 
// transaction is initiated during the wait period, the counting will be halted, cactive will not de-assert, and the counting will 
// be re-initiated when there are no pending transactions. 
// Available only if X2P_LOWPWR_HS_IF is true
`define i_axi_x2p_X2P_LOWPWR_NOPX_CNT 32'd0

//This is the log2 of (X2P_LOWPWR_NOPX_CNT )

`define i_axi_x2p_X2P_LOG2_LOWPWR_NOPX_CNT 1



// Name:         X2P_CMD_QUEUE_DEPTH
// Default:      4
// Values:       1 2 4 8 16 32
// 
// Number of locations in the common command queue. Depth must be at least 2 when in dual-clock mode. The depth 1 is 
// allowed in only single-clock mode.
`define i_axi_x2p_X2P_CMD_QUEUE_DEPTH 4


// Name:         X2P_WRITE_BUFFER_DEPTH
// Default:      2
// Values:       1 2 4 8 16 32 64
// 
// Number of locations in the write data buffer. Depth must be at least 2 when in dual-clock mode. The depth 1 is allowed 
// in only single-clock mode.
`define i_axi_x2p_X2P_WRITE_BUFFER_DEPTH 2


// Name:         X2P_WRITE_RESP_BUFFER_DEPTH
// Default:      2
// Values:       1 2 4 8 16
// 
// Number of locations in the write response buffer. Depth must be at least 2 when in dual-clock mode. The depth 1 is 
// allowed in only single-clock mode.
`define i_axi_x2p_X2P_WRITE_RESP_BUFFER_DEPTH 2


// Name:         X2P_READ_BUFFER_DEPTH
// Default:      2
// Values:       1 2 4 8 16 32
// 
// Number of locations in the read data buffer. Depth must be at least 2 when in dual-clock mode. The depth 1 is allowed in 
// only single-clock mode.
`define i_axi_x2p_X2P_READ_BUFFER_DEPTH 2



/********************************************************************/
/*                                                                  */
/*         Decoders for the APBs                                    */
/*                                                                  */
/********************************************************************/


// Name:         X2P_START_PADDR_S0
// Default:      0x0000000000000400
// Values:       0x0000000000000000, ..., (2**X2P_AXI_AW)-1024
// 
// Start address for APB Slave 0. Following are the default values: 
//  - i = 0: 0x0000000000000400 
//  - i = 1: 0x0000000000000800 
//  - i = 2: 0x0000000000000c00 
//  - i = 3: 0x0000000000001000 
//  - i = 4: 0x0000000000001400 
//  - i = 5: 0x0000000000001800 
//  - i = 6: 0x0000000000001c00 
//  - i = 7: 0x0000000000002000 
//  - i = 8: 0x0000000000002400 
//  - i = 9: 0x0000000000002800 
//  - i = 10: 0x0000000000002c00 
//  - i = 11: 0x0000000000003000 
//  - i = 12: 0x0000000000003400 
//  - i = 13: 0x0000000000003800 
//  - i = 14: 0x0000000000003c00 
//  - i = 15: 0x0000000000004000
`define i_axi_x2p_X2P_START_PADDR_S0 64'h0000000000000000


// Name:         X2P_END_PADDR_S0
// Default:      0x00000000000007ff
// Values:       0x00000000000003ff, ..., (2**X2P_AXI_AW)-1
// 
// End address for APB Slave 0. Following are the default values: 
//  - i = 0: 0x00000000000007ff 
//  - i = 1: 0x0000000000000bff 
//  - i = 2: 0x0000000000000fff 
//  - i = 3: 0x00000000000013ff 
//  - i = 4: 0x00000000000017ff 
//  - i = 5: 0x0000000000001bff 
//  - i = 6: 0x0000000000001fff 
//  - i = 7: 0x00000000000023ff 
//  - i = 8: 0x00000000000027ff 
//  - i = 9: 0x0000000000002bff 
//  - i = 10: 0x0000000000002fff 
//  - i = 11: 0x00000000000033ff 
//  - i = 12: 0x00000000000037ff 
//  - i = 13: 0x0000000000003bff 
//  - i = 14: 0x0000000000003fff 
//  - i = 15: 0x00000000000043ff
`define i_axi_x2p_X2P_END_PADDR_S0 64'h0000000000000fff


// Name:         X2P_IS_APB3_S0
// Default:      false
// Values:       false (0), true (1)
// 
// AMBA 3 support for APB slave. Slave 0 has the additional ports PREADY and PSLVERR according to the AMBA3 specification.
`define i_axi_x2p_X2P_IS_APB3_S0 1

//Creates a define for enabling APB3 in Slave 0

// `define i_axi_x2p_X2P_APB3_S0


// Name:         X2P_START_PADDR_S1
// Default:      0x0000000000000800
// Values:       0x0000000000000000, ..., (2**X2P_AXI_AW)-1024
// Enabled:      X2P_NUM_APB_SLAVES>1
// 
// Start address for APB Slave 1. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_START_PADDR_S1 64'h0000000000000800


// Name:         X2P_END_PADDR_S1
// Default:      0x0000000000000bff
// Values:       0x00000000000003ff, ..., (2**X2P_AXI_AW)-1
// Enabled:      X2P_NUM_APB_SLAVES>1
// 
// End address for APB Slave 1. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_END_PADDR_S1 64'h0000000000000bff


// Name:         X2P_IS_APB3_S1
// Default:      false
// Values:       false (0), true (1)
// Enabled:      X2P_NUM_APB_SLAVES>1
// 
// Slave 1 has the additional ports PREADY and PSLVERR 
// according to the AMBA3 specification.
`define i_axi_x2p_X2P_IS_APB3_S1 0

//Creates a define for enabling APB3 in Slave 1 

// `define i_axi_x2p_X2P_APB3_S1


// Name:         X2P_START_PADDR_S2
// Default:      0x0000000000000c00
// Values:       0x0000000000000000, ..., (2**X2P_AXI_AW)-1024
// Enabled:      X2P_NUM_APB_SLAVES>2
// 
// Start address for APB Slave 2. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_START_PADDR_S2 64'h0000000000000c00


// Name:         X2P_END_PADDR_S2
// Default:      0x0000000000000fff
// Values:       0x00000000000003ff, ..., (2**X2P_AXI_AW)-1
// Enabled:      X2P_NUM_APB_SLAVES>2
// 
// End address for APB Slave 2. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_END_PADDR_S2 64'h0000000000000fff


// Name:         X2P_IS_APB3_S2
// Default:      false
// Values:       false (0), true (1)
// Enabled:      X2P_NUM_APB_SLAVES>2
// 
// Slave 2 has the additional ports PREADY and PSLVERR 
// according to the AMBA3 specification.
`define i_axi_x2p_X2P_IS_APB3_S2 0

//Creates a define for enabling APB3 in Slave 2

// `define i_axi_x2p_X2P_APB3_S2


// Name:         X2P_START_PADDR_S3
// Default:      0x0000000000001000
// Values:       0x0000000000000000, ..., (2**X2P_AXI_AW)-1024
// Enabled:      X2P_NUM_APB_SLAVES>3
// 
// Start address for APB Slave 3. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_START_PADDR_S3 64'h0000000000001000


// Name:         X2P_END_PADDR_S3
// Default:      0x00000000000013ff
// Values:       0x00000000000003ff, ..., (2**X2P_AXI_AW)-1
// Enabled:      X2P_NUM_APB_SLAVES>3
// 
// End address for APB Slave 3. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_END_PADDR_S3 64'h00000000000013ff


// Name:         X2P_IS_APB3_S3
// Default:      false
// Values:       false (0), true (1)
// Enabled:      X2P_NUM_APB_SLAVES>3
// 
// Slave 3 has the additional ports PREADY and PSLVERR 
// according to the AMBA3 specification.
`define i_axi_x2p_X2P_IS_APB3_S3 0

//Creates a define for enabling APB3 in Slave 3

// `define i_axi_x2p_X2P_APB3_S3


// Name:         X2P_START_PADDR_S4
// Default:      0x0000000000001400
// Values:       0x0000000000000000, ..., (2**X2P_AXI_AW)-1024
// Enabled:      X2P_NUM_APB_SLAVES>4
// 
// Start address for APB Slave 4. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_START_PADDR_S4 64'h0000000000001400


// Name:         X2P_END_PADDR_S4
// Default:      0x00000000000017ff
// Values:       0x00000000000003ff, ..., (2**X2P_AXI_AW)-1
// Enabled:      X2P_NUM_APB_SLAVES>4
// 
// End address for APB Slave 4. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_END_PADDR_S4 64'h00000000000017ff


// Name:         X2P_IS_APB3_S4
// Default:      false
// Values:       false (0), true (1)
// Enabled:      X2P_NUM_APB_SLAVES>4
// 
// Slave 4 has the additional ports PREADY and PSLVERR 
// according to the AMBA3 specification.
`define i_axi_x2p_X2P_IS_APB3_S4 0

//Creates a define for enabling APB3 in Slave 4

// `define i_axi_x2p_X2P_APB3_S4


// Name:         X2P_START_PADDR_S5
// Default:      0x0000000000001800
// Values:       0x0000000000000000, ..., (2**X2P_AXI_AW)-1024
// Enabled:      X2P_NUM_APB_SLAVES>5
// 
// Start address for APB Slave 5. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_START_PADDR_S5 64'h0000000000001800


// Name:         X2P_END_PADDR_S5
// Default:      0x0000000000001bff
// Values:       0x00000000000003ff, ..., (2**X2P_AXI_AW)-1
// Enabled:      X2P_NUM_APB_SLAVES>5
// 
// End address for APB Slave 5. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_END_PADDR_S5 64'h0000000000001bff


// Name:         X2P_IS_APB3_S5
// Default:      false
// Values:       false (0), true (1)
// Enabled:      X2P_NUM_APB_SLAVES>5
// 
// Slave 5 has the additional ports PREADY and PSLVERR 
// according to the AMBA3 specification.
`define i_axi_x2p_X2P_IS_APB3_S5 0

//Creates a define for enabling APB3 in Slave 5

// `define i_axi_x2p_X2P_APB3_S5


// Name:         X2P_START_PADDR_S6
// Default:      0x0000000000001c00
// Values:       0x0000000000000000, ..., (2**X2P_AXI_AW)-1024
// Enabled:      X2P_NUM_APB_SLAVES>6
// 
// Start address for APB Slave 6. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_START_PADDR_S6 64'h0000000000001c00


// Name:         X2P_END_PADDR_S6
// Default:      0x0000000000001fff
// Values:       0x00000000000003ff, ..., (2**X2P_AXI_AW)-1
// Enabled:      X2P_NUM_APB_SLAVES>6
// 
// End address for APB Slave 6. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_END_PADDR_S6 64'h0000000000001fff


// Name:         X2P_IS_APB3_S6
// Default:      false
// Values:       false (0), true (1)
// Enabled:      X2P_NUM_APB_SLAVES>6
// 
// Slave 6 has the additional ports PREADY and PSLVERR 
// according to the AMBA3 specification.
`define i_axi_x2p_X2P_IS_APB3_S6 0

//Creates a define for enabling APB3 in Slave 6

// `define i_axi_x2p_X2P_APB3_S6


// Name:         X2P_START_PADDR_S7
// Default:      0x0000000000002000
// Values:       0x0000000000000000, ..., (2**X2P_AXI_AW)-1024
// Enabled:      X2P_NUM_APB_SLAVES>7
// 
// Start address for APB Slave 7. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_START_PADDR_S7 64'h0000000000002000


// Name:         X2P_END_PADDR_S7
// Default:      0x00000000000023ff
// Values:       0x00000000000003ff, ..., (2**X2P_AXI_AW)-1
// Enabled:      X2P_NUM_APB_SLAVES>7
// 
// End address for APB Slave 7. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_END_PADDR_S7 64'h00000000000023ff


// Name:         X2P_IS_APB3_S7
// Default:      false
// Values:       false (0), true (1)
// Enabled:      X2P_NUM_APB_SLAVES>7
// 
// slave 7 has the additional ports PREADY and PSLVERR 
// according to the AMBA3 specification.
`define i_axi_x2p_X2P_IS_APB3_S7 0

//Creates a define for enabling APB3 in Slave 7

// `define i_axi_x2p_X2P_APB3_S7


// Name:         X2P_START_PADDR_S8
// Default:      0x0000000000002400
// Values:       0x0000000000000000, ..., (2**X2P_AXI_AW)-1024
// Enabled:      X2P_NUM_APB_SLAVES>8
// 
// Start address for APB Slave 8. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_START_PADDR_S8 64'h0000000000002400


// Name:         X2P_END_PADDR_S8
// Default:      0x00000000000027ff
// Values:       0x00000000000003ff, ..., (2**X2P_AXI_AW)-1
// Enabled:      X2P_NUM_APB_SLAVES>8
// 
// End address for APB Slave 8. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_END_PADDR_S8 64'h00000000000027ff


// Name:         X2P_IS_APB3_S8
// Default:      false
// Values:       false (0), true (1)
// Enabled:      X2P_NUM_APB_SLAVES>8
// 
// slave 8 has the additional ports PREADY and PSLVERR 
// according to the AMBA3 specification.
`define i_axi_x2p_X2P_IS_APB3_S8 0

//Creates a define for enabling APB3 in Slave 8

// `define i_axi_x2p_X2P_APB3_S8



// Name:         X2P_START_PADDR_S9
// Default:      0x0000000000002800
// Values:       0x0000000000000000, ..., (2**X2P_AXI_AW)-1024
// Enabled:      X2P_NUM_APB_SLAVES>9
// 
// Start address for APB Slave 9. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_START_PADDR_S9 64'h0000000000002800


// Name:         X2P_END_PADDR_S9
// Default:      0x0000000000002bff
// Values:       0x00000000000003ff, ..., (2**X2P_AXI_AW)-1
// Enabled:      X2P_NUM_APB_SLAVES>9
// 
// End address for APB Slave 9. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_END_PADDR_S9 64'h0000000000002bff


// Name:         X2P_IS_APB3_S9
// Default:      false
// Values:       false (0), true (1)
// Enabled:      X2P_NUM_APB_SLAVES>9
// 
// Slave 9 has the additional ports PREADY and PSLVERR 
// according to the AMBA3 specification.
`define i_axi_x2p_X2P_IS_APB3_S9 0

//Creates a define for enabling APB3 in Slave 9

// `define i_axi_x2p_X2P_APB3_S9


// Name:         X2P_START_PADDR_S10
// Default:      0x0000000000002c00
// Values:       0x0000000000000000, ..., (2**X2P_AXI_AW)-1024
// Enabled:      X2P_NUM_APB_SLAVES>10
// 
// Start address for APB Slave 10. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_START_PADDR_S10 64'h0000000000002c00


// Name:         X2P_END_PADDR_S10
// Default:      0x0000000000002fff
// Values:       0x00000000000003ff, ..., (2**X2P_AXI_AW)-1
// Enabled:      X2P_NUM_APB_SLAVES>10
// 
// End address for APB Slave 10. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_END_PADDR_S10 64'h0000000000002fff


// Name:         X2P_IS_APB3_S10
// Default:      false
// Values:       false (0), true (1)
// Enabled:      X2P_NUM_APB_SLAVES>10
// 
// slave 10 has the additional ports PREADY and PSLVERR 
// according to the AMBA3 specification.
`define i_axi_x2p_X2P_IS_APB3_S10 0

//Creates a define for enabling APB3 in Slave 10

// `define i_axi_x2p_X2P_APB3_S10


// Name:         X2P_START_PADDR_S11
// Default:      0x0000000000003000
// Values:       0x0000000000000000, ..., (2**X2P_AXI_AW)-1024
// Enabled:      X2P_NUM_APB_SLAVES>11
// 
// Start address for APB Slave 11. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_START_PADDR_S11 64'h0000000000003000


// Name:         X2P_END_PADDR_S11
// Default:      0x00000000000033ff
// Values:       0x00000000000003ff, ..., (2**X2P_AXI_AW)-1
// Enabled:      X2P_NUM_APB_SLAVES>11
// 
// End address for APB Slave 11. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_END_PADDR_S11 64'h00000000000033ff


// Name:         X2P_IS_APB3_S11
// Default:      false
// Values:       false (0), true (1)
// Enabled:      X2P_NUM_APB_SLAVES>11
// 
// Slave 11 has the additional ports PREADY and PSLVERR 
// according to the AMBA3 specification.
`define i_axi_x2p_X2P_IS_APB3_S11 0

//Creates a define for enabling APB3 in Slave 11

// `define i_axi_x2p_X2P_APB3_S11


// Name:         X2P_START_PADDR_S12
// Default:      0x0000000000003400
// Values:       0x0000000000000000, ..., (2**X2P_AXI_AW)-1024
// Enabled:      X2P_NUM_APB_SLAVES>12
// 
// Start address for APB Slave 12. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_START_PADDR_S12 64'h0000000000003400


// Name:         X2P_END_PADDR_S12
// Default:      0x00000000000037ff
// Values:       0x00000000000003ff, ..., (2**X2P_AXI_AW)-1
// Enabled:      X2P_NUM_APB_SLAVES>12
// 
// End address for APB Slave 12. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_END_PADDR_S12 64'h00000000000037ff


// Name:         X2P_IS_APB3_S12
// Default:      false
// Values:       false (0), true (1)
// Enabled:      X2P_NUM_APB_SLAVES>12
// 
// Slave 12 has the additional ports PREADY and PSLVERR 
// according to the AMBA3 specification.
`define i_axi_x2p_X2P_IS_APB3_S12 0

//Creates a define for enabling APB3 in Slave 12

// `define i_axi_x2p_X2P_APB3_S12


// Name:         X2P_START_PADDR_S13
// Default:      0x0000000000003800
// Values:       0x0000000000000000, ..., (2**X2P_AXI_AW)-1024
// Enabled:      X2P_NUM_APB_SLAVES>13
// 
// Start address for APB Slave 13. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_START_PADDR_S13 64'h0000000000003800


// Name:         X2P_END_PADDR_S13
// Default:      0x0000000000003bff
// Values:       0x00000000000003ff, ..., (2**X2P_AXI_AW)-1
// Enabled:      X2P_NUM_APB_SLAVES>13
// 
// End address for APB Slave 13. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_END_PADDR_S13 64'h0000000000003bff


// Name:         X2P_IS_APB3_S13
// Default:      false
// Values:       false (0), true (1)
// Enabled:      X2P_NUM_APB_SLAVES>13
// 
// Slave 13 has the additional ports PREADY and PSLVERR 
// according to the AMBA3 specification.
`define i_axi_x2p_X2P_IS_APB3_S13 0

//Creates a define for enabling APB3 in Slave 13

// `define i_axi_x2p_X2P_APB3_S13



// Name:         X2P_START_PADDR_S14
// Default:      0x0000000000003c00
// Values:       0x0000000000000000, ..., (2**X2P_AXI_AW)-1024
// Enabled:      X2P_NUM_APB_SLAVES>14
// 
// Start address for APB Slave 14. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_START_PADDR_S14 64'h0000000000003c00


// Name:         X2P_END_PADDR_S14
// Default:      0x0000000000003fff
// Values:       0x00000000000003ff, ..., (2**X2P_AXI_AW)-1
// Enabled:      X2P_NUM_APB_SLAVES>14
// 
// End address for APB Slave 14. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_END_PADDR_S14 64'h0000000000003fff


// Name:         X2P_IS_APB3_S14
// Default:      false
// Values:       false (0), true (1)
// Enabled:      X2P_NUM_APB_SLAVES>14
// 
// slave 14 has the additional ports PREADY and PSLVERR 
// according to the AMBA3 specification.
`define i_axi_x2p_X2P_IS_APB3_S14 0

//Creates a define for enabling APB3 in Slave 14

// `define i_axi_x2p_X2P_APB3_S14



// Name:         X2P_START_PADDR_S15
// Default:      0x0000000000004000
// Values:       0x0000000000000000, ..., (2**X2P_AXI_AW)-1024
// Enabled:      X2P_NUM_APB_SLAVES>15
// 
// Start address for APB Slave 15. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_START_PADDR_S15 64'h0000000000004000


// Name:         X2P_END_PADDR_S15
// Default:      0x00000000000043ff
// Values:       0x00000000000003ff, ..., (2**X2P_AXI_AW)-1
// Enabled:      X2P_NUM_APB_SLAVES>15
// 
// End address for APB Slave 15. 
//  
// Dependencies: Any address must not be contained in any other range and 
// must have a minimum size of 1 KB, and must be aligned to a 1 KB boundary.
`define i_axi_x2p_X2P_END_PADDR_S15 64'h00000000000043ff


// Name:         X2P_IS_APB3_S15
// Default:      false
// Values:       false (0), true (1)
// Enabled:      X2P_NUM_APB_SLAVES>15
// 
// Slave 15 has the additional ports PREADY and PSLVERR 
// according to the AMBA3 specification.
`define i_axi_x2p_X2P_IS_APB3_S15 0

//Creates a define for enabling APB3 in Slave 15

// `define i_axi_x2p_X2P_APB3_S15


`define i_axi_x2p_X2P_AXI_START_ADDR 64'h0


`define i_axi_x2p_X2P_AXI_END_ADDR 64'hfff



// Name:         X2P_START_PADDR_32_S0
// Default:      0x00000000 (X2P_START_PADDR_S0 & 0x00000000ffffffff)
// Values:       0x00000000, ..., 0xfffffc00
// Enabled:      0
// 
// Start Address for APB Slave #0 that the component will use to decode the addressed APB Slave. This parameter is 
// non-editable and is used for visual purposes only in the coreConsultant GUI.
`define i_axi_x2p_X2P_START_PADDR_32_S0 32'h00000000


// Name:         X2P_END_PADDR_32_S0
// Default:      0x00000fff (X2P_END_PADDR_S0 & 0x00000000ffffffff)
// Values:       0x000003ff, ..., 0xffffffff
// Enabled:      0
// 
// End Address for APB Slave #0 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_END_PADDR_32_S0 32'h00000fff


// Name:         X2P_START_PADDR_32_S1
// Default:      0x00000800 (X2P_START_PADDR_S1 & 0x00000000ffffffff)
// Values:       0x00000000, ..., 0xfffffc00
// Enabled:      0
// 
// Start Address for APB Slave #1 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_START_PADDR_32_S1 32'h00000800


// Name:         X2P_END_PADDR_32_S1
// Default:      0x00000bff (X2P_END_PADDR_S1 & 0x00000000ffffffff)
// Values:       0x000003ff, ..., 0xffffffff
// Enabled:      0
// 
// End Address for APB Slave #1 that the component will use to decode the addressed APB Slave. This parameter is 
// non-editable and is used for visual purposes only in the coreConsultant GUI.
`define i_axi_x2p_X2P_END_PADDR_32_S1 32'h00000bff


// Name:         X2P_START_PADDR_32_S2
// Default:      0x00000c00 (X2P_START_PADDR_S2 & 0x00000000ffffffff)
// Values:       0x00000000, ..., 0xfffffc00
// Enabled:      0
// 
// Start Address for APB Slave #2 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_START_PADDR_32_S2 32'h00000c00


// Name:         X2P_END_PADDR_32_S2
// Default:      0x00000fff (X2P_END_PADDR_S2 & 0x00000000ffffffff)
// Values:       0x000003ff, ..., 0xffffffff
// Enabled:      0
// 
// End Address for APB Slave #2 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_END_PADDR_32_S2 32'h00000fff


// Name:         X2P_START_PADDR_32_S3
// Default:      0x00001000 (X2P_START_PADDR_S3 & 0x00000000ffffffff)
// Values:       0x00000000, ..., 0xfffffc00
// Enabled:      0
// 
// Start Address for APB Slave #3 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_START_PADDR_32_S3 32'h00001000


// Name:         X2P_END_PADDR_32_S3
// Default:      0x000013ff (X2P_END_PADDR_S3 & 0x00000000ffffffff)
// Values:       0x000003ff, ..., 0xffffffff
// Enabled:      0
// 
// End Address for APB Slave #3 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_END_PADDR_32_S3 32'h000013ff


// Name:         X2P_START_PADDR_32_S4
// Default:      0x00001400 (X2P_START_PADDR_S4 & 0x00000000ffffffff)
// Values:       0x00000000, ..., 0xfffffc00
// Enabled:      0
// 
// Start Address for APB Slave #4 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_START_PADDR_32_S4 32'h00001400


// Name:         X2P_END_PADDR_32_S4
// Default:      0x000017ff (X2P_END_PADDR_S4 & 0x00000000ffffffff)
// Values:       0x000003ff, ..., 0xffffffff
// Enabled:      0
// 
// End Address for APB Slave #4 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_END_PADDR_32_S4 32'h000017ff


// Name:         X2P_START_PADDR_32_S5
// Default:      0x00001800 (X2P_START_PADDR_S5 & 0x00000000ffffffff)
// Values:       0x00000000, ..., 0xfffffc00
// Enabled:      0
// 
// Start Address for APB Slave #5 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_START_PADDR_32_S5 32'h00001800


// Name:         X2P_END_PADDR_32_S5
// Default:      0x00001bff (X2P_END_PADDR_S5 & 0x00000000ffffffff)
// Values:       0x000003ff, ..., 0xffffffff
// Enabled:      0
// 
// End Address for APB Slave #5 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_END_PADDR_32_S5 32'h00001bff


// Name:         X2P_START_PADDR_32_S6
// Default:      0x00001c00 (X2P_START_PADDR_S6 & 0x00000000ffffffff)
// Values:       0x00000000, ..., 0xfffffc00
// Enabled:      0
// 
// Start Address for APB Slave #6 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_START_PADDR_32_S6 32'h00001c00


// Name:         X2P_END_PADDR_32_S6
// Default:      0x00001fff (X2P_END_PADDR_S6 & 0x00000000ffffffff)
// Values:       0x000003ff, ..., 0xffffffff
// Enabled:      0
// 
// End Address for APB Slave #6 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_END_PADDR_32_S6 32'h00001fff


// Name:         X2P_START_PADDR_32_S7
// Default:      0x00002000 (X2P_START_PADDR_S7 & 0x00000000ffffffff)
// Values:       0x00000000, ..., 0xfffffc00
// Enabled:      0
// 
// Start Address for APB Slave #7 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_START_PADDR_32_S7 32'h00002000


// Name:         X2P_END_PADDR_32_S7
// Default:      0x000023ff (X2P_END_PADDR_S7 & 0x00000000ffffffff)
// Values:       0x000003ff, ..., 0xffffffff
// Enabled:      0
// 
// End Address for APB Slave #7 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_END_PADDR_32_S7 32'h000023ff


// Name:         X2P_START_PADDR_32_S8
// Default:      0x00002400 (X2P_START_PADDR_S8 & 0x00000000ffffffff)
// Values:       0x00000000, ..., 0xfffffc00
// Enabled:      0
// 
// Start Address for APB Slave #8 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_START_PADDR_32_S8 32'h00002400


// Name:         X2P_END_PADDR_32_S8
// Default:      0x000027ff (X2P_END_PADDR_S8 & 0x00000000ffffffff)
// Values:       0x000003ff, ..., 0xffffffff
// Enabled:      0
// 
// End Address for APB Slave #8 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_END_PADDR_32_S8 32'h000027ff


// Name:         X2P_START_PADDR_32_S9
// Default:      0x00002800 (X2P_START_PADDR_S9 & 0x00000000ffffffff)
// Values:       0x00000000, ..., 0xfffffc00
// Enabled:      0
// 
// Start Address for APB Slave #9 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_START_PADDR_32_S9 32'h00002800


// Name:         X2P_END_PADDR_32_S9
// Default:      0x00002bff (X2P_END_PADDR_S9 & 0x00000000ffffffff)
// Values:       0x000003ff, ..., 0xffffffff
// Enabled:      0
// 
// End Address for APB Slave #9 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_END_PADDR_32_S9 32'h00002bff


// Name:         X2P_START_PADDR_32_S10
// Default:      0x00002c00 (X2P_START_PADDR_S10 & 0x00000000ffffffff)
// Values:       0x00000000, ..., 0xfffffc00
// Enabled:      0
// 
// Start Address for APB Slave #10 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_START_PADDR_32_S10 32'h00002c00


// Name:         X2P_END_PADDR_32_S10
// Default:      0x00002fff (X2P_END_PADDR_S10 & 0x00000000ffffffff)
// Values:       0x000003ff, ..., 0xffffffff
// Enabled:      0
// 
// End Address for APB Slave #10 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_END_PADDR_32_S10 32'h00002fff


// Name:         X2P_START_PADDR_32_S11
// Default:      0x00003000 (X2P_START_PADDR_S11 & 0x00000000ffffffff)
// Values:       0x00000000, ..., 0xfffffc00
// Enabled:      0
// 
// Start Address for APB Slave #11 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_START_PADDR_32_S11 32'h00003000


// Name:         X2P_END_PADDR_32_S11
// Default:      0x000033ff (X2P_END_PADDR_S11 & 0x00000000ffffffff)
// Values:       0x000003ff, ..., 0xffffffff
// Enabled:      0
// 
// End Address for APB Slave #11 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_END_PADDR_32_S11 32'h000033ff


// Name:         X2P_START_PADDR_32_S12
// Default:      0x00003400 (X2P_START_PADDR_S12 & 0x00000000ffffffff)
// Values:       0x00000000, ..., 0xfffffc00
// Enabled:      0
// 
// Start Address for APB Slave #12 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_START_PADDR_32_S12 32'h00003400


// Name:         X2P_END_PADDR_32_S12
// Default:      0x000037ff (X2P_END_PADDR_S12 & 0x00000000ffffffff)
// Values:       0x000003ff, ..., 0xffffffff
// Enabled:      0
// 
// End Address for APB Slave #12 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_END_PADDR_32_S12 32'h000037ff


// Name:         X2P_START_PADDR_32_S13
// Default:      0x00003800 (X2P_START_PADDR_S13 & 0x00000000ffffffff)
// Values:       0x00000000, ..., 0xfffffc00
// Enabled:      0
// 
// Start Address for APB Slave #13 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_START_PADDR_32_S13 32'h00003800


// Name:         X2P_END_PADDR_32_S13
// Default:      0x00003bff (X2P_END_PADDR_S13 & 0x00000000ffffffff)
// Values:       0x000003ff, ..., 0xffffffff
// Enabled:      0
// 
// End Address for APB Slave #13 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_END_PADDR_32_S13 32'h00003bff


// Name:         X2P_START_PADDR_32_S14
// Default:      0x00003c00 (X2P_START_PADDR_S14 & 0x00000000ffffffff)
// Values:       0x00000000, ..., 0xfffffc00
// Enabled:      0
// 
// Start Address for APB Slave #14 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_START_PADDR_32_S14 32'h00003c00


// Name:         X2P_END_PADDR_32_S14
// Default:      0x00003fff (X2P_END_PADDR_S14 & 0x00000000ffffffff)
// Values:       0x000003ff, ..., 0xffffffff
// Enabled:      0
// 
// End Address for APB Slave #14 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_END_PADDR_32_S14 32'h00003fff


// Name:         X2P_START_PADDR_32_S15
// Default:      0x00004000 (X2P_START_PADDR_S15 & 0x00000000ffffffff)
// Values:       0x00000000, ..., 0xfffffc00
// Enabled:      0
// 
// Start Address for APB Slave #15 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_START_PADDR_32_S15 32'h00004000


// Name:         X2P_END_PADDR_32_S15
// Default:      0x000043ff (X2P_END_PADDR_S15 & 0x00000000ffffffff)
// Values:       0x000003ff, ..., 0xffffffff
// Enabled:      0
// 
// End Address for APB Slave #15 that the component will use 
// to decode the addressed APB Slave. This parameter 
// is non-editable and is used for visual purposes only 
// in the coreConsultant GUI.
`define i_axi_x2p_X2P_END_PADDR_32_S15 32'h000043ff


//Creates a define for enabling Slave 1

// `define i_axi_x2p_X2P_HAS_S1

//Creates a define for enabling Slave 2

// `define i_axi_x2p_X2P_HAS_S2

//Creates a define for enabling Slave 3

// `define i_axi_x2p_X2P_HAS_S3

//Creates a define for enabling Slave 4

// `define i_axi_x2p_X2P_HAS_S4

//Creates a define for enabling Slave 5

// `define i_axi_x2p_X2P_HAS_S5

//Creates a define for enabling Slave 6

// `define i_axi_x2p_X2P_HAS_S6

//Creates a define for enabling Slave 7

// `define i_axi_x2p_X2P_HAS_S7

//Creates a define for enabling Slave 8

// `define i_axi_x2p_X2P_HAS_S8

//Creates a define for enabling Slave 9

// `define i_axi_x2p_X2P_HAS_S9

//Creates a define for enabling Slave 10

// `define i_axi_x2p_X2P_HAS_S10

//Creates a define for enabling Slave 11

// `define i_axi_x2p_X2P_HAS_S11

//Creates a define for enabling Slave 12

// `define i_axi_x2p_X2P_HAS_S12

//Creates a define for enabling Slave 13

// `define i_axi_x2p_X2P_HAS_S13

//Creates a define for enabling Slave 14

// `define i_axi_x2p_X2P_HAS_S14

//Creates a define for enabling Slave 15

// `define i_axi_x2p_X2P_HAS_S15

//Creates a define for enabling PREADY Signal in Slave 0

// `define i_axi_x2p_X2P_PREADY_S0

//Creates a define for enabling SLVERR Signal in Slave 0

// `define i_axi_x2p_X2P_PSLVERR_S0

//Creates a define for enabling PREADY Signal in Slave 1

// `define i_axi_x2p_X2P_PREADY_S1

//Creates a define for enabling SLVERR Signal in Slave 1

// `define i_axi_x2p_X2P_PSLVERR_S1

//Creates a define for enabling PREADY Signal in Slave 2

// `define i_axi_x2p_X2P_PREADY_S2

//Creates a define for enabling SLVERR Signal in Slave 2

// `define i_axi_x2p_X2P_PSLVERR_S2

//Creates a define for enabling PREADY Signal in Slave 3

// `define i_axi_x2p_X2P_PREADY_S3

//Creates a define for enabling SLVERR Signal in Slave 3

// `define i_axi_x2p_X2P_PSLVERR_S3

//Creates a define for enabling PREADY Signal in Slave 4

// `define i_axi_x2p_X2P_PREADY_S4

//Creates a define for enabling SLVERR Signal in Slave 4

// `define i_axi_x2p_X2P_PSLVERR_S4

//Creates a define for enabling PREADY Signal in Slave 5

// `define i_axi_x2p_X2P_PREADY_S5

//Creates a define for enabling SLVERR Signal in Slave 5

// `define i_axi_x2p_X2P_PSLVERR_S5

//Creates a define for enabling PREADY Signal in Slave 6

// `define i_axi_x2p_X2P_PREADY_S6

//Creates a define for enabling SLVERR Signal in Slave 6

// `define i_axi_x2p_X2P_PSLVERR_S6

//Creates a define for enabling PREADY Signal in Slave 7

// `define i_axi_x2p_X2P_PREADY_S7

//Creates a define for enabling SLVERR Signal in Slave 7

// `define i_axi_x2p_X2P_PSLVERR_S7

//Creates a define for enabling PREADY Signal in Slave 8

// `define i_axi_x2p_X2P_PREADY_S8

//Creates a define for enabling SLVERR Signal in Slave 8

// `define i_axi_x2p_X2P_PSLVERR_S8

//Creates a define for enabling PREADY Signal in Slave 9

// `define i_axi_x2p_X2P_PREADY_S9

//Creates a define for enabling SLVERR Signal in Slave 9

// `define i_axi_x2p_X2P_PSLVERR_S9

//Creates a define for enabling PREADY Signal in Slave 10

// `define i_axi_x2p_X2P_PREADY_S10

//Creates a define for enabling SLVERR Signal in Slave 10

// `define i_axi_x2p_X2P_PSLVERR_S10

//Creates a define for enabling PREADY Signal in Slave 11

// `define i_axi_x2p_X2P_PREADY_S11

//Creates a define for enabling SLVERR Signal in Slave 11

// `define i_axi_x2p_X2P_PSLVERR_S11

//Creates a define for enabling PREADY Signal in Slave 12

// `define i_axi_x2p_X2P_PREADY_S12

//Creates a define for enabling SLVERR Signal in Slave 12

// `define i_axi_x2p_X2P_PSLVERR_S12

//Creates a define for enabling PREADY Signal in Slave 13

// `define i_axi_x2p_X2P_PREADY_S13

//Creates a define for enabling SLVERR Signal in Slave 13

// `define i_axi_x2p_X2P_PSLVERR_S13

//Creates a define for enabling PREADY Signal in Slave 14

// `define i_axi_x2p_X2P_PREADY_S14

//Creates a define for enabling SLVERR Signal in Slave 14

// `define i_axi_x2p_X2P_PSLVERR_S14

//Creates a define for enabling PREADY Signal in Slave 15

// `define i_axi_x2p_X2P_PREADY_S15

//Creates a define for enabling SLVERR Signal in Slave 15

// `define i_axi_x2p_X2P_PSLVERR_S15



// -------------------------------------
// simulation parameters available in cC
// -------------------------------------
//This is a testbench parameter. The design does not depend on this
//parameter. This parameter specifies the clock period of the primary
//AXI system (also called AXI system "A") used in the testbench to drive
//the Bridge slave interface.

`define i_axi_x2p_SIM_A_CLK_PERIOD 100

//This is a testbench parameter. The design does not depend from this
//parameter. This parameter specifies the clock period of the secondary
//APB system (also called APB system "B") used in the testbench to drive
//the Bridge master interface.

`define i_axi_x2p_SIM_B_CLK_PERIOD 100

// this enables tests to produce additional dump files with information about the
// random transfers generated, the addresses values observed on the bus etc.

`define i_axi_x2p_SIM_DEBUG_LEVEL 0

// this enables tests to use a variable seed (related with the OS time) to
// initialize random generators.

`define i_axi_x2p_SIM_USE_VARIABLE_SEED 0

// Verification uses the following parameter if SIM_USE_CC_RAND_SEED
// is set. Use's get_systime value otherwise. Note the
// seed wil be the same but the configurations
// will be different between regression runs.



`define i_axi_x2p_SIM_RAND_SEED 0


`define i_axi_x2p_SIM_USE_CC_RAND_SEED 0



`define i_axi_x2p_USE_FOUNDATION 0


// ------------------------------------------
// simulation constants used in the testbench
// do not change !
// ------------------------------------------

// clock cycles in a time tick
`define i_axi_x2p_SIM_A_TTICK_CLK_CYCLES 100000
`define i_axi_x2p_SIM_B_TTICK_CLK_CYCLES 51

// primary bus memory map
`define i_axi_x2p_SIM_A_START_ADDR_S1 32'h10000000  /* slave A1 */
`define i_axi_x2p_SIM_A_END_ADDR_S1   32'h1fffffff
`define i_axi_x2p_SIM_A_START_ADDR_S2 32'h20000000  /* bridge A->B */
`define i_axi_x2p_SIM_A_END_ADDR_S2   32'h2fffffff
`define i_axi_x2p_SIM_A_START_ADDR_S3 32'h30000000  /* slave A3 */
`define i_axi_x2p_SIM_A_END_ADDR_S3   32'h3fffffff

// secondary bus memory map
`define i_axi_x2p_SIM_B_START_ADDR_S1 32'h20000000  /* slave B1 */
`define i_axi_x2p_SIM_B_END_ADDR_S1   32'h27ffffff
`define i_axi_x2p_SIM_B_START_ADDR_S3 32'h28000000  /* slave B3 */
`define i_axi_x2p_SIM_B_END_ADDR_S3   32'h2fffffff
`define i_axi_x2p_SIM_B_START_ADDR_S2 32'h30000000  /* bridge A->B */
`define i_axi_x2p_SIM_B_END_ADDR_S2   32'h3fffffff


//----------------------------------------------
// used for the axi to apb bridge
//----------------------------------------------

// This sets the number of transactions the random test will run

`define i_axi_x2p_AXI_TEST_RAND_XACTNS 1000

//----------------------------------------------
// used for the axi to apb bridge
//----------------------------------------------

// used to allow random generation of default signal levels
// in the regression tests
// bit 0 for default for RREADY
// bit 1                 BREADY
// 3:2   WSTRB inactive
//   0   low
//   1   prev
//   2   hign

`define i_axi_x2p_AXI_TEST_INACTIVE_SIGNALS 2

/*****************************************/
/*                                       */
/*          MAXI BUS SIZES               */
/*                                       */
/*****************************************/
`define i_axi_x2p_MAX_X2P_AXI_DATA_WIDTH  512
`define i_axi_x2p_MAX_X2P_AXI_ADDR_WIDTH  64
`define i_axi_x2p_MAX_X2P_AXI_ID_WIDTH 20



`define i_axi_x2p_RM_ENDIAN 1
/*****************************************/
/*                                       */
/*          Derived Values               */
/*                                       */
/*****************************************/
// the following are "derived defines"
// the following will be derived from the X2P_CLK_MODE


`define i_axi_x2p_X2P_AXI_WSTRB_WIDTH  `i_axi_x2p_X2P_AXI_DW/8
`define i_axi_x2p_X2P_APB_WSTRB_WIDTH  `i_axi_x2p_X2P_APB_DATA_WIDTH/8

`define i_axi_x2p_APB_DW_32

`define i_axi_x2p_X2P_AXI_WDFIFO_WIDTH  `i_axi_x2p_X2P_AXI_DW + `i_axi_x2p_X2P_AXI_WSTRB_WIDTH + 1

// the LEN is the cmd queue will be the larger of the write and read
`define i_axi_x2p_LEN_WIDTH `i_axi_x2p_X2P_AXI_BLW

// keep the axi addr width allowing selects to span the whole X2P_AXI_AW range
//`define i_axi_x2p_X2P_CMD_ADDR_WIDTH  `i_axi_x2p_X2P_AXI_AW
//`define i_axi_x2p_X2P_CMD_QUEUE_WIDTH  `i_axi_x2p_X2P_AXI_AW + `i_axi_x2p_X2P_AXI_SIDW + `i_axi_x2p_X2P_AXI_BLW + 2 + 2 + 1
`define i_axi_x2p_X2P_CMD_ADDR_WIDTH  32
`define i_axi_x2p_X2P_CMD_QUEUE_WIDTH 32 + `i_axi_x2p_X2P_AXI_SIDW + `i_axi_x2p_X2P_AXI_BLW + 2 + 2 + 1

// based on the AXI data width define the max SIZE that can be issued
`define i_axi_x2p_X2P_MAX_AXI_SIZE ((`i_axi_x2p_X2P_AXI_DW == 512) ? 6 :((`i_axi_x2p_X2P_AXI_DW == 256) ? 5 : ((`i_axi_x2p_X2P_AXI_DW == 128) ? 4 : ((`i_axi_x2p_X2P_AXI_DW == 64 ? 3 :((`i_axi_x2p_X2P_AXI_DW == 32) ? 2 : ((`i_axi_x2p_X2P_AXI_DW == 16) ? 1: 0)))))))
// provide the fixed size of the APB
`define i_axi_x2p_X2P_APB_SIZE ((`i_axi_x2p_X2P_APB_DATA_WIDTH == 512) ? 6 :((`i_axi_x2p_X2P_APB_DATA_WIDTH == 256) ? 5 : ((`i_axi_x2p_X2P_APB_DATA_WIDTH == 128) ? 4 : ((`i_axi_x2p_X2P_APB_DATA_WIDTH == 64 ? 3 :((`i_axi_x2p_X2P_APB_DATA_WIDTH == 32) ? 2 : ((`i_axi_x2p_X2P_APB_DATA_WIDTH == 16) ? 1: 0)))))))


`define i_axi_x2p_APB_BUS_SIZE ((`i_axi_x2p_X2P_APB_DATA_WIDTH == 32) ? 2 : (`i_axi_x2p_X2P_APB_DATA_WIDTH == 16) ? 1 : 0)


// `define i_axi_x2p_X2P_ENCRYPT


// Name:         X2P_HAS_APB3
// Default:      0 (X2P_IS_APB3_S0 || X2P_IS_APB3_S1 || X2P_IS_APB3_S2 || 
//               X2P_IS_APB3_S3 || X2P_IS_APB3_S4 || X2P_IS_APB3_S5 || X2P_IS_APB3_S6 || 
//               X2P_IS_APB3_S7 || X2P_IS_APB3_S8 || X2P_IS_APB3_S9 || X2P_IS_APB3_S10 || 
//               X2P_IS_APB3_S11 || X2P_IS_APB3_S12 || X2P_IS_APB3_S13 || X2P_IS_APB3_S14 
//               || X2P_IS_APB3_S15)
// Values:       -2147483648, ..., 2147483647
// 
// IF X2P HAS A APB3 SLAVE
`define i_axi_x2p_X2P_HAS_APB3 0


//Used to insert internal tests


`define i_axi_x2p_X2P_VERIF_EN 1

//**************************************************************************************************
// Parameters to remove init and test ports in bcm
//**************************************************************************************************


`define i_axi_x2p_DWC_NO_TST_MODE

`define i_axi_x2p_DWC_NO_CDC_INIT

`define i_axi_x2p_X2P_AXI_BLW_4





//==============================================================================
// End Guard
//==============================================================================
