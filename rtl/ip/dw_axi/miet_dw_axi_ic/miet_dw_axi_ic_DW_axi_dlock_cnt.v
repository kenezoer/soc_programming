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
// Component Name   : DW_axi
// Component Version: 4.04a
// Release Type     : GA
// ------------------------------------------------------------------------------

// 
// Release version :  4.04a
// File Version     :        $Revision: #8 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi/amba_dev/src/DW_axi_dlock_cnt.v#8 $ 
--
-- File     : DW_axi_dlock_cnt.v
-- Version  :  
//
//
-- Abstract : Counter for dealock detection
--
------------------------------------------------------------------------
*/

`include "miet_dw_axi_ic_DW_axi_all_includes.vh"

module miet_dw_axi_ic_DW_axi_dlock_cnt (
  aclk,
  aresetn,
  dlc_zero,
  dlc_max
);

  input  aclk;
  input  aresetn;
  output dlc_zero;
  output dlc_max;

  reg [`miet_dw_axi_ic_AXI_LOG2_DLOCK_TIMEOUT_P1-1:0] dlc_cnt;

  reg dlc_zero;
  reg dlc_max;

  always@(posedge aclk or negedge aresetn)
    begin : dlc_cnt_PROC
      if(!aresetn)
        dlc_cnt <= {(`miet_dw_axi_ic_AXI_LOG2_DLOCK_TIMEOUT_P1){1'b0}};
      else
        begin
    if(dlc_cnt < `miet_dw_axi_ic_AXI_DLOCK_TIMEOUT)
      dlc_cnt <= dlc_cnt+1;
    else
      dlc_cnt <= {(`miet_dw_axi_ic_AXI_LOG2_DLOCK_TIMEOUT_P1){1'b0}};
  end
    end

  always@(posedge aclk or negedge aresetn)
    begin : dlc_zero_PROC
      if(!aresetn)
        dlc_zero <= 1'b0;
      else
        begin
    if(dlc_cnt == {(`miet_dw_axi_ic_AXI_LOG2_DLOCK_TIMEOUT_P1){1'b0}})
      dlc_zero <= 1'b1;
    else
      dlc_zero <= 1'b0;
  end
    end

  always@(posedge aclk or negedge aresetn)
    begin : dlc_max_PROC
      if(!aresetn)
        dlc_max <= 1'b0;
      else
        begin
    if(dlc_cnt == `miet_dw_axi_ic_AXI_DLOCK_TIMEOUT)
      dlc_max <= 1'b1;
    else
      dlc_max <= 1'b0;
  end
    end

endmodule
