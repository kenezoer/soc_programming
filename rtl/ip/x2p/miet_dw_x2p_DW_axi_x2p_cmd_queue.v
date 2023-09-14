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
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2p/amba_dev/src/DW_axi_x2p_cmd_queue.v#12 $ 
*/

//
//
//-----------------------------------------------------------------------------
// Filename    : DW_axi_x2p_cmd_queue.v
// 
// Created     : Dec 15 2005
// Description : Connects to the DesignWare fifo control and the registers.
//               Allows for a single or two clocks, selects fifo based on 
//               clocking
//               The AXI side pushes with the acmd_queue_wd_int
//   
//-----------------------------------------------------------------------------

`include "miet_dw_x2p_DW_axi_x2p_all_includes.vh"

module miet_dw_x2p_DW_axi_x2p_cmd_queue(/*AUTOARG*/
   // Outputs
   acmd_rdy_int_n, 
                            push_af, 
                            hcmd_queue_wd_int, 
                            hcmd_rdy_int_n,
                            // Inputs
                            clk_axi, 
                            acmd_queue_wd_int, 
                            push_acmd_int_n, 
                            pop_hcmd_int_n, 
                            push_rst_n
                            );

// requires the following to be defined
//  X2P_CMD_QUEUE_WIDTH   total width of cmd queue word;
//  X2P_CMD_QUEUE_DEPTH   DEPTH of the FIFO

//  X2P_CLK_MODE          0 = Two Clocks implies FIFO with 2  push and pop sync 
//                        1 = Two Clocks  imnplies FIFO with 3 push and pop sync
//                        2 = single clock implies a single clock fifo
         
  input                              clk_axi;
  input [`X2P_CMD_QUEUE_WIDTH:0]   acmd_queue_wd_int;    // consisting of all the inputs
  input                              push_acmd_int_n;
  output                             acmd_rdy_int_n;
  output                             push_af;
  
  input                              pop_hcmd_int_n;
  output [`X2P_CMD_QUEUE_WIDTH:0]  hcmd_queue_wd_int;
  output                             hcmd_rdy_int_n;

  input                              push_rst_n;
  
  wire                               we_n, acmd_rdy_int_n,hcmd_rdy_int_n;
  wire                               push_af;

  
   
parameter FIFO_WIDTH=`X2P_CMD_QUEUE_WIDTH + 1;
parameter DEPTH=`X2P_CMD_QUEUE_DEPTH;
// push and pop syncs for dual clock systems.
// if the clocks are 0 use 2 clocks between domains
//  clock 1 use 3
// clock 2 a single clock use 1 clock
 parameter PUSH_AE_LVL=(DEPTH == 1) ? 0 : 2;
// set up all the widths and depths assume here that the DEPTH cannot exceed 256
parameter COUNT_WIDTH=((DEPTH <= 2) ? 2 :(DEPTH <= 4) ? 3 :(DEPTH <= 8) ? 4 :(DEPTH <= 16) ? 5:(DEPTH <= 32) ? 6:(DEPTH <= 64) ? 7:(DEPTH <= 128) ? 8:9);
parameter DW_ADDR_WIDTH= (COUNT_WIDTH-1);
   // if FIFO is  dual-clocked adjusting the RAM DEPTH for odd and non-power of 2 compatibility with the control
parameter DW_EFFECTIVE_DEPTH_S1=DEPTH;
parameter DW_EFFECTIVE_DEPTH_S2=((DEPTH == (1 << DW_ADDR_WIDTH))? DEPTH : DEPTH + ((DEPTH & 1) ? 1: 2));
parameter DW_EFFECTIVE_DEPTH=((`X2P_CLK_MODE==2) ? DW_EFFECTIVE_DEPTH_S1 : DW_EFFECTIVE_DEPTH_S2);

   wire [DW_ADDR_WIDTH-1:0]          wr_addr,rd_addr;
   wire                              mem_rst_n;
   
  assign                    mem_rst_n = push_rst_n;
 parameter TST_MODE=0;      // scan test input not connected
  
  wire [DW_ADDR_WIDTH-1:0]  af_thresh;
  wire [DW_ADDR_WIDTH-1:0]  ae_level;

  wire clk_push;
  assign                     clk_push = clk_axi;


  assign                     af_thresh = DW_EFFECTIVE_DEPTH-1;

  //spyglass disable_block W163
  //SMD: Truncation of bits in constant integer conversion
  //SJ: Truncation of bits in constant expected for certain configs.
  //However, all the required bits are assigned to LHS always.
  assign                     ae_level = PUSH_AE_LVL;
  //spyglass enable_block W163

//unused signals from the bcm06 module.
wire                       almost_empty_unconn;
wire                       half_full_unconn;
wire                       error_unconn;
wire [DW_ADDR_WIDTH-1:0]  wrd_count_unconn;
wire                       nxt_empty_n_unconn;
wire                       nxt_full_unconn;
wire                       nxt_error_unconn;


  // Call fifo Controller
  //spyglass disable_block W528
  //SMD: A signal or variable is set but never read.
  //SJ : BCM components are configurable to use in various scenarios in this particular design we are not using certain ports. Hence although those signals are read we are not driving them. Therefore waiving this warning.
  // Single clock
  miet_dw_x2p_DW_axi_x2p_bcm06
   #(DEPTH,TST_MODE, DW_ADDR_WIDTH)
      U_CMD_FIFO_CONTROL_S1(
                .clk(clk_push),
                .rst_n(push_rst_n),
                .init_n(1'b1),
                .full(acmd_rdy_int_n),
                .empty(hcmd_rdy_int_n),
                .af_thresh(af_thresh),                        
                .diag_n(1'b1),
                .ae_level(ae_level),
                .push_req_n(push_acmd_int_n),
                .pop_req_n(pop_hcmd_int_n),
                .we_n(we_n),
                .wr_addr(wr_addr),
                .rd_addr(rd_addr),
                .almost_empty(almost_empty_unconn),
                .half_full(half_full_unconn),
                .almost_full(push_af),
                .error(error_unconn),
                .wrd_count(wrd_count_unconn),
                .nxt_empty_n(nxt_empty_n_unconn),
                .nxt_full(nxt_full_unconn),
                .nxt_error(nxt_error_unconn)                         
                 );
  // spyglass enable_block W528
  //      
  // The RAM
  wire [`X2P_CMD_QUEUE_WIDTH:0]   pushsf_acmd_queue_wd_int; 
  wire [`X2P_CMD_QUEUE_WIDTH:0]   spushsf_hcmd_queue_wd_int; 
  
  assign pushsf_acmd_queue_wd_int = acmd_queue_wd_int;
  assign hcmd_queue_wd_int        = spushsf_hcmd_queue_wd_int;

  miet_dw_x2p_DW_axi_x2p_bcm57
   #(FIFO_WIDTH,DW_EFFECTIVE_DEPTH,0,DW_ADDR_WIDTH)
     U_CMD_FIFO_RAM( .clk(clk_push)
                    ,.rst_n(mem_rst_n)
                    ,.wr_n(we_n)
                    ,.rd_addr(rd_addr)
                    ,.wr_addr(wr_addr)
                    ,.data_in(pushsf_acmd_queue_wd_int)
                    ,.data_out(spushsf_hcmd_queue_wd_int)
                    );
  
//`include "../../src/DW_axi_x2h_fifo_report.inc"

endmodule // DW_axi_x2p_cmd_queue







