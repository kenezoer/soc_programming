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
// File Version     :        $Revision: #12 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2p/amba_dev/src/DW_axi_x2p_resp_buffer.v#12 $ 
*/

//
//
//-----------------------------------------------------------------------------
// Filename    : DW_axi_x2p_resp_buffer
// 
// Created     : Dec 15 2005
// Description : Connects to the DesignWare fifo control and the registers
//               Allows for a single or two clocks, selects fifo based on 
//               clocking
//               The APB side pushes with the response
//   
//-----------------------------------------------------------------------------

`include "DW_axi_x2p_all_includes.vh"

module DW_axi_x2p_resp_buffer(/*AUTOARG*/
   // Outputs
   hresp_rdy_int_n, 
                              aresp_rdy_int_n, 
                              awstatus_int, 
                              awid_int,
                              clk_apb, 
                              hwstatus_int, 
                              hwid_int, 
                              push_resp_int_n,
                              pop_resp_int_n, 
                              push_rst_n
                              );

     // requires the following to be defined
//  X2P_AXI_DATA_WIDTH      width of the read data word;
//  X2P_AXI_ID_WIDTH        width of the read id
//  X2P_WRITE_RESP_BUFFER_DEPTH   depth of the FIFO
   
//  X2P_CLK_MODE           0 = Async Clocks implies FIFO with 2 or 3 push and pop sync 
//                         1 = Sync Clocks  imnplies FIFO with 1 push and pop sync
//                         2 = single clock implies a single clock fifo
  input                   clk_apb; 
  input                   hwstatus_int;
  input [`X2P_AXI_SIDW-1:0] hwid_int;
  input       push_resp_int_n;
  output      hresp_rdy_int_n;
  output      aresp_rdy_int_n;
  output      awstatus_int;
  output [`X2P_AXI_SIDW-1:0] awid_int;
  input        pop_resp_int_n;
  input        push_rst_n;
  
parameter FIFO_WIDTH=`X2P_AXI_SIDW+1;                // fixed for ID plus status
parameter DEPTH=`X2P_WRITE_RESP_BUFFER_DEPTH;
// push and pop syncs for dual clock systems.
// if the clock are sync use 1 reg between domains
// if async use the constraint
// set up all the widths and depths assume here that the depth cannot exceed 256
parameter COUNT_WIDTH=((DEPTH <= 2) ? 2 :(DEPTH <= 4) ? 3 :(DEPTH <= 8) ? 4 :(DEPTH <= 16) ? 5:(DEPTH <= 32) ? 6:(DEPTH <= 64) ? 7:(DEPTH <= 128) ? 8:9);
parameter DW_ADDR_WIDTH= (COUNT_WIDTH-1);
   // adjusting the RAM depth for odd and non-power of 2 compatibility with the control
   // if FIFO is  dual-clocked adjusting the RAM depth for odd and non-power of 2 compatibility with the control
parameter DW_EFFECTIVE_DEPTH_S1=DEPTH;
parameter DW_EFFECTIVE_DEPTH_S2=((DEPTH == (1 << DW_ADDR_WIDTH))? DEPTH : DEPTH + ((DEPTH & 1) ? 1: 2));
parameter DW_EFFECTIVE_DEPTH=((`X2P_CLK_MODE==2) ? DW_EFFECTIVE_DEPTH_S1 : DW_EFFECTIVE_DEPTH_S2);

  wire  [DW_ADDR_WIDTH-1:0] wr_addr,rd_addr;
  wire                      mem_rst_n;
  wire                      aresp_rdy_int_n,hresp_rdy_int_n;
  wire                      we_n;
  
  assign                    mem_rst_n = push_rst_n;
 parameter PUSH_AE_LVL=(DEPTH == 1) ? 0 : 2;
 parameter TST_MODE=0;      // scan test input not connected

  wire clk_push;
  wire [DW_ADDR_WIDTH-1:0]  af_thresh,ae_level;

   assign                   clk_push = clk_apb;

  assign                     af_thresh = DW_EFFECTIVE_DEPTH-1;

  //spyglass disable_block W163
  //SMD: Truncation of bits in constant integer conversion
  //SJ: Truncation of bits in constant expected for certain configs.
  //However, all the required bits are assigned to LHS always.
  assign                     ae_level = PUSH_AE_LVL;
  //spyglass enable_block W163

//unused signals from the bcm06 module.
wire                      almost_empty_unconn;
wire                      half_full_unconn;
wire                      almost_full_unconn;
wire                      error_unconn;
wire [DW_ADDR_WIDTH-1:0] wrd_count_unconn;
wire                      nxt_empty_n_unconn;
wire                      nxt_full_unconn;
wire                      nxt_error_unconn;
  // Not concerned with unconnected ports, hence disable the
  // The following port(s) of this instance are intentionally unconnected.   
  // This instance design is shared by other module(s) that uses these port(s).
  // Call fifo Controller
  //spyglass disable_block W528
  //SMD: A signal or variable is set but never read.
  //SJ : BCM components are configurable to use in various scenarios in this particular design we are not using certain ports. Hence although those signals are read we are not driving them. Therefore waiving this warning.
   // single clock
  DW_axi_x2p_bcm06
   #(DEPTH,TST_MODE, DW_ADDR_WIDTH)
      U_RESP_FIFO_CONTROL_S1(
                .clk(clk_push),
                .rst_n(push_rst_n),
                .init_n(1'b1),
                .full(hresp_rdy_int_n),
                .empty(aresp_rdy_int_n),
                .af_thresh(af_thresh),                        
                .diag_n(1'b1),
                .ae_level(ae_level),
                .push_req_n(push_resp_int_n),
                .pop_req_n(pop_resp_int_n),
                .we_n(we_n),
                .wr_addr(wr_addr),
                .rd_addr(rd_addr),
                .almost_empty(almost_empty_unconn),
                .half_full(half_full_unconn),
                .almost_full(almost_full_unconn),
                .error(error_unconn),
                .wrd_count(wrd_count_unconn),
                .nxt_empty_n(nxt_empty_n_unconn),
                .nxt_full(nxt_full_unconn),
                .nxt_error(nxt_error_unconn)                         
                 );
  // spyglass enable_block W528
  // The RAM
  wire                     pushsf_hwstatus_int;
  wire [`X2P_AXI_SIDW-1:0] pushsf_hwid_int;
  wire                     spushsf_awstatus_int;
  wire [`X2P_AXI_SIDW-1:0] spushsf_awid_int;
  
  assign pushsf_hwstatus_int = hwstatus_int;
  assign pushsf_hwid_int     = hwid_int;
  assign awstatus_int        = spushsf_awstatus_int;
  assign awid_int            = spushsf_awid_int;

  DW_axi_x2p_bcm57
   #(FIFO_WIDTH,DW_EFFECTIVE_DEPTH,0,DW_ADDR_WIDTH)
     U_RESP_FIFO_RAM( .clk(clk_push)
                     ,.rst_n(mem_rst_n)
                     ,.wr_n(we_n)
                     ,.rd_addr(rd_addr)
                     ,.wr_addr(wr_addr)
                     ,.data_in({pushsf_hwstatus_int,pushsf_hwid_int})
                     ,.data_out({spushsf_awstatus_int,spushsf_awid_int})
                      );

endmodule // DW_axi_x2p_resp_buffer














