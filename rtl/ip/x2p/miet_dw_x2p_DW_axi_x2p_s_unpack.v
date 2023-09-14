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
// File Version     :        $Revision: #9 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2p/amba_dev/src/DW_axi_x2p_s_unpack.v#9 $ 
*/
//
//
//
//-----------------------------------------------------------------------------
// Filename    : DW_axi_x2ps_unpack.v
// 
// Description : APB write data unpacking for DW_axi_x2p bridge.
//-----------------------------------------------------------------------------

`include "miet_dw_x2p_DW_axi_x2p_all_includes.vh"

module miet_dw_x2p_DW_axi_x2p_s_unpack (/*AUTOARG*/
  // Outputs
  selected_data, selected_strobes, 
  // Inputs
  clk, rstn, write_buff_data, write_buff_strobes,
  next_apb_wd_sel, set_data
  );


   input                                clk;
   input                                rstn;
   input [`X2P_AXI_DW-1:0]              write_buff_data;
   input [(`X2P_AXI_DW/8)-1:0]          write_buff_strobes;
   input [7:0]                          next_apb_wd_sel;
   input                                set_data;
   
   output [`X2P_APB_DATA_WIDTH-1:0]     selected_data;
   output [(`X2P_APB_DATA_WIDTH/8)-1:0] selected_strobes;
   
   reg [`X2P_APB_DATA_WIDTH-1:0]    selected_data;
   wire [`X2P_AXI_DW-1:0]           write_buff_data;
   wire [(`X2P_AXI_DW/8)-1:0]       write_buff_strobes;
   wire [7:0]                       next_apb_wd_sel;
   reg [`X2P_APB_DATA_WIDTH-1:0]    next_selected_data;
   wire [`X2P_APB_DATA_WIDTH-1:0]   selected_data_ns;
   reg [(`X2P_APB_DATA_WIDTH/8)-1:0] selected_strobes_ns;
   wire [(`X2P_APB_DATA_WIDTH/8)-1:0] selected_strobes;

  integer                               i;
  integer                               j;

  always@(/*AUTOSENSE*/next_apb_wd_sel or write_buff_data)
    /*AUTO_CONSTANT(`X2P_APB_DATA_WIDTH)*/
    begin: NEXT_SEL_DATA_PROC
      for(i=0; i<`X2P_APB_DATA_WIDTH; i=i+1)
        begin
         // spyglass disable_block SelfDeterminedExpr-ML
         // SMD: Self determined expression present in the design
         // SJ : The expression indexing the vector/array will never exceed the boundary of the vector/array.
          next_selected_data[i] = write_buff_data[i+(next_apb_wd_sel*`X2P_APB_DATA_WIDTH)];
         // spyglass enable_block SelfDeterminedExpr-ML
        end
    end // always@ (...
  
  always@(/*AUTOSENSE*/next_apb_wd_sel or write_buff_strobes)
    /*AUTO_CONSTANT(`X2P_APB_WSTRB_WIDTH)*/
    begin:SEL_STROBES_NS_PROC
      for(j=0; j<`X2P_APB_WSTRB_WIDTH; j=j+1)
        begin

         // spyglass disable_block SelfDeterminedExpr-ML
         // SMD: Self determined expression present in the design
         // SJ : The expression indexing the vector/array will never exceed the boundary of the vector/array.
          selected_strobes_ns[j] = write_buff_strobes[j+(next_apb_wd_sel*`X2P_APB_WSTRB_WIDTH)];
         // spyglass enable_block SelfDeterminedExpr-ML
        end
    end // always@ (...

  
   assign selected_strobes = selected_strobes_ns;   
   assign selected_data_ns = (set_data==1'b1) ? next_selected_data : selected_data;
      
  always @(posedge clk or negedge rstn)
    begin:S_SEL_DATA_PROC
      if (!rstn)
        begin
          selected_data <= {`X2P_APB_DATA_WIDTH{1'b0}};
        end
      else
        begin
          selected_data <= selected_data_ns;
        end
    end // always @ (posedge clk or negedge rstn)
   
endmodule // DW_axi_x2ps_unpack


















