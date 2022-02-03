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
// File Version     :        $Revision: #9 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi/amba_dev/src/DW_axi_dlock_mux.v#9 $ 
--
-- File     : DW_axi_dlock_cnt.v
-- Version  :  
//
//
-- Abstract : Deadlock detector
--
------------------------------------------------------------------------
*/

`include "miet_dw_axi_ic_DW_axi_all_includes.vh"

module miet_dw_axi_ic_DW_axi_dlock_mux (
  aclk,
  aresetn,  
  dlock_w_m1,
  dlock_id_w_m1,
  dlock_snum_w_m1,
  dlock_r_m1,
  dlock_id_r_m1,
  dlock_snum_r_m1,
  dlock_mst,
  dlock_slv,
  dlock_id,
  dlock_wr,
  dlock_irq
);

   //spyglass disable_block W240
   //SMD: An input has been declared but is not read
   //SJ: These ports are not used  
  input                          aclk;
  input                          aresetn;
  //spyglass enable_block W240
  input                          dlock_w_m1;
  input [`miet_dw_axi_ic_AXI_MIDW-1:0]          dlock_id_w_m1;
  input [`miet_dw_axi_ic_AXI_LOG2_NSP1-1:0]     dlock_snum_w_m1;
  input                          dlock_r_m1;
  input [`miet_dw_axi_ic_AXI_MIDW-1:0]          dlock_id_r_m1;
  input [`miet_dw_axi_ic_AXI_LOG2_NSP1-1:0]     dlock_snum_r_m1;
  output [`miet_dw_axi_ic_AXI_LOG2_LCL_NM-1:0]  dlock_mst;
  output [`miet_dw_axi_ic_AXI_LOG2_NSP1-1:0]    dlock_slv;
  output [`miet_dw_axi_ic_AXI_MIDW-1:0]         dlock_id;
  output                         dlock_wr;
  output                         dlock_irq;

  reg    [`miet_dw_axi_ic_AXI_NUM_MASTERS-1:0]  dlock_w;
  reg    [`miet_dw_axi_ic_AXI_MIDW-1:0]         dlock_id_w   [`miet_dw_axi_ic_AXI_NUM_MASTERS-1:0];
  reg    [`miet_dw_axi_ic_AXI_LOG2_NSP1-1:0]    dlock_snum_w [`miet_dw_axi_ic_AXI_NUM_MASTERS-1:0];
  reg    [`miet_dw_axi_ic_AXI_NUM_MASTERS-1:0]  dlock_r;
  reg    [`miet_dw_axi_ic_AXI_MIDW-1:0]         dlock_id_r   [`miet_dw_axi_ic_AXI_NUM_MASTERS-1:0];
  reg    [`miet_dw_axi_ic_AXI_LOG2_NSP1-1:0]    dlock_snum_r [`miet_dw_axi_ic_AXI_NUM_MASTERS-1:0];

  reg    [`miet_dw_axi_ic_AXI_LOG2_LCL_NM-1:0]  dlock_mst_c;
  reg    [`miet_dw_axi_ic_AXI_LOG2_NSP1-1:0]    dlock_slv_c;
  reg    [`miet_dw_axi_ic_AXI_MIDW-1:0]         dlock_id_c;
  reg                            dlock_wr_c;
  reg                            dlock_irq_c;


  always @(*)
  begin : dlock_w_PROC

  dlock_w[0]  = dlock_w_m1;
















  end

  always @(*)
  begin : dlock_id_w_PROC

  dlock_id_w[0]  = dlock_id_w_m1;
















  end

  always @(*)
  begin : dlock_snum_w_PROC

  dlock_snum_w[0]  = dlock_snum_w_m1;
















  end

  always @(*)
  begin : dlock_r_PROC

  dlock_r[0]  = dlock_r_m1;
















  end

  always @(*)
  begin : dlock_id_r_PROC

  dlock_id_r[0]  = dlock_id_r_m1;
















  end

  always @(*)
  begin : dlock_snum_r_PROC

  dlock_snum_r[0]  = dlock_snum_r_m1;
















  end

  //spyglass disable_block W415a
  //SMD: Signal may be multiply assigned (beside initialization) in the same scope
  //SJ: This is not an issue.
  always @(*)
  begin : dlock_PROC
    integer i;
    reg     found;
    
    dlock_mst_c = {`miet_dw_axi_ic_AXI_LOG2_LCL_NM{1'b0}};
    dlock_slv_c = {`miet_dw_axi_ic_AXI_LOG2_NSP1{1'b0}};
    dlock_id_c  = {`miet_dw_axi_ic_AXI_MIDW{1'b0}};
    dlock_wr_c  = 1'b0;
    dlock_irq_c = 1'b0;

    found     = 1'b0;

    for( i = 0;
         i <= `miet_dw_axi_ic_AXI_NUM_MASTERS-1;
   i = i+1 )
      begin
        if ((dlock_w[i] || dlock_r[i]) && (!found))
    begin
            dlock_mst_c = i;
      if(dlock_w[i])
        begin
          dlock_slv_c = dlock_snum_w[i];
          dlock_id_c  = dlock_id_w[i];
        end
      else
        begin
          dlock_slv_c = dlock_snum_r[i];
          dlock_id_c  = dlock_id_r[i];
        end
      dlock_wr_c  = dlock_w[i];
      dlock_irq_c = 1'b1;
      found       = 1'b1;
          end
      end
  end
  //spyglass enable_block W415a

  assign dlock_mst = dlock_mst_c;
  assign dlock_slv = dlock_slv_c;
  assign dlock_id  = dlock_id_c;
  assign dlock_wr  = dlock_wr_c;
  assign dlock_irq = dlock_irq_c;      

endmodule
