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
// File Version     :        $Revision: #10 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2p/amba_dev/src/DW_axi_x2p_dcdr.v#10 $ 
------------------------------------------------------------------------
--
//
//
--
-- File :                       DW_axi_x2p_dcdr
-- Date :                       $Date: 2020/03/22 $
-- Abstract     :               APB address decoder module.
--
-- This module takes as input the address. It decodes the address and
-- either generates a valid decode or an invalid_addr signal (psel_int = 0)
-- The decoder is maximally configured
-- - 16 slaves - always, and the required PSEL lines are sliced out of
-- this maximally configured system.
--
--
--
-- Modification History:        Refer to perforce log
-- =====================================================================
*/

`include "i_axi_x2p_DW_axi_x2p_all_includes.vh"

module i_axi_x2p_DW_axi_x2p_dcdr (/*AUTOARG*/
  // Outputs
  psel_int, psel_err,
  // Inputs
  psel_addr
  );
  // parameter apb_size = `i_axi_x2p_X2P_APB_SIZE;
  // parameter NUM_APB_SLAVES = `i_axi_x2p_X2P_NUM_APB_SLAVES;

//-----------------
// IO declarations
//-----------------

   input [`i_axi_x2p_X2P_CMD_ADDR_WIDTH-1:10]   psel_addr;    // input address bus

   output [`i_axi_x2p_X2P_NUM_APB_SLAVES-1:0]   psel_int;  // PSEL output bus

   output                             psel_err;  // set when no selects or more than 1 sel

//----------------
// wires and regs
//----------------
  wire [`i_axi_x2p_X2P_NUM_APB_SLAVES-1:0]                           psel_int;
  reg                                 psel_err;
  wire [31:10]                        paddr;      // 64 bit addressing the top 32 arn not seen

//---------------------------
// Internal wires and regs
//---------------------------
   wire [`i_axi_x2p_X2P_NUM_APB_SLAVES-1:0] psel_tmp; // max width psel bus
//   wire [3:0]  num_slaves = NUM_APB_SLAVES;
//   integer     adjusted_size;

parameter [63:0] START_TMP_PADDR0     = `i_axi_x2p_X2P_START_PADDR_S0;
parameter [63:0] END_TMP_PADDR0       = `i_axi_x2p_X2P_END_PADDR_S0; 
                                                           
   assign      paddr = psel_addr[31:10];

// the selection is only in 1k blocks
// Generate comparator based decoder for a maximally configured
// APB system always
//
   assign      psel_tmp[0] = ((paddr[31:10] >= START_TMP_PADDR0[31:10]) && (paddr[31:10] <= END_TMP_PADDR0[31:10]));

//
// Extract the active slice from the maximally configured bus
//
   assign psel_int = psel_tmp;

   // if no selects set the error
   // 1st is out of range
   // 2nd is not aligned to the APB
  always @(/*AS*/psel_tmp)
    begin: PSEL_ERR_PROC
      psel_err = 1'b0;
      //if (|psel_tmp == 0) psel_err = 1'b1;
      if (!(psel_tmp)) psel_err = 1'b1;
    end

endmodule // DW_axi_x2p_dcdr
























