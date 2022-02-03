/* ---------------------------------------------------------------------
**
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
// Component Name   : DW_axi
// Component Version: 4.04a
// Release Type     : GA
// ------------------------------------------------------------------------------

// 
// Release version :  4.04a
// File Version     :        $Revision: #9 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi/amba_dev/src/DW_axi_lp.v#9 $ 
**
** ---------------------------------------------------------------------
**
** File     : DW_axi_lp.v
//
//
** Created  : Tue May 11 15:54:00 MEST 2010
** Modified : $Date: 2020/03/22 $
** Abstract : The purpose of this block is to implementn low power
**            interface compliant with axi protocol.
**
** ---------------------------------------------------------------------
*/
`include "miet_dw_axi_ic_DW_axi_all_includes.vh"
module miet_dw_axi_ic_DW_axi_lp (
  aclk_i,
  aresetn_i,
  awpendtrans_i,
  arpendtrans_i,
  awvalid_m_i,
  arvalid_m_i,

  csysreq_i,
  csysack_o,
  cactive_o,
  ready_en_o
  
);

  input      aclk_i;                                // AXI system clock
  input      aresetn_i;                             // AXI system reset

  input      [`miet_dw_axi_ic_AXI_NUM_MASTERS-1:0] awpendtrans_i;  // Number of pending transitions on write address channel of all Masters
  input      [`miet_dw_axi_ic_AXI_NUM_MASTERS-1:0] arpendtrans_i;  // Number of pending transitions on read address channel of all Masters

  input      [`miet_dw_axi_ic_AXI_NUM_MASTERS-1:0] awvalid_m_i;    // Masters awvalid bus
  input      [`miet_dw_axi_ic_AXI_NUM_MASTERS-1:0] arvalid_m_i;    // Masters arvalid_m bus

  input      csysreq_i;                             // System low-power request
  output     csysack_o;                             // Low-power request acknowledgement
  output     cactive_o;                             // Clock active
  output     ready_en_o;                            // Ready enable

  wire       cactive_o;
  wire       csysack_o;

  wire       active_trans;

  wire       ready_en_o;

  assign active_trans = (awpendtrans_i) | (arpendtrans_i) | (awvalid_m_i) | (arvalid_m_i) ;
    


  miet_dw_axi_ic_DW_axi_lpfsm
   #(
    `miet_dw_axi_ic_AXI_LOWPWR_NOPX_CNT,
    `miet_dw_axi_ic_AXI_LOG2_LOWPWR_NOPX_CNT
  )
  U_DW_axi_lpfsm (
     // Inputs
     .aclk         (aclk_i),
     .aresetn      (aresetn_i),
     .active_trans (active_trans),
     .csysreq      (csysreq_i),

     // Outputs
     .cactive      (cactive_o),
     .csysack      (csysack_o),
     .ready        (ready_en_o)
  );


endmodule
