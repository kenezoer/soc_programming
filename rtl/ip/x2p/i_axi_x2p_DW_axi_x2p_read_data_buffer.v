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
// File Version     :        $Revision: #11 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2p/amba_dev/src/DW_axi_x2p_read_data_buffer.v#11 $ 
*/

//
//

//-----------------------------------------------------------------------------
// Filename    : DW_axi_x2p_read_data_buffer.v
// 
// Created     : Dec 15 2005
// Description : Connects to the DesignWare fifo control and the registers
//               Allows for a single or two clocks, selects fifo based on 
//               clocking
//               The APB side pushes with the data ID and resp
//               and monitors the condition of the stack by looking at
//               the adddress to the RAM (hrdata_uush_cnt)
//-----------------------------------------------------------------------------

`include "i_axi_x2p_DW_axi_x2p_all_includes.vh"

module i_axi_x2p_DW_axi_x2p_read_data_buffer(/*AUTOARG*/
   // Outputs
   arstatus_int, 
                                   arid_int, 
                                   arlast_int, 
                                   ardata_int, 
                                   arvalid_int_n,
                                   hrdata_rdy_int_n,
                                   pop_data_int_n, 
                                   clk_apb, 
                                   push_data_int_n, 
                                   hrstatus_int,
                                   hrid_int, 
                                   hrlast_int, 
                                   hrdata_int, 
                                   push_rst_n
                                   );

     // requires the following to be defined
//  X2P_AXI_DATA_WIDTH       width of the read data word;
//  X2P_AXI_ID_WIDTH         width of the read id
//  X2P_READ_BUFFER_DEPTH    depth of the FIFO

//  X2P_CLK_MODE           0 = Two Clocks implies FIFO with 2 push and pop sync 
//                         1 = Two  Clocks  imnplies FIFO with 3 push and pop sync
//                         2 = single clock implies a single clock fifo
    
parameter FIFO_WIDTH =`i_axi_x2p_X2P_AXI_DW + `i_axi_x2p_X2P_AXI_SIDW + 2;
parameter DEPTH=`i_axi_x2p_X2P_READ_BUFFER_DEPTH;
// push and pop syns for dual clock systems.
// if the clock ar sync use 1 reg between domains
// if async use the constraint
// set up all the widths and depths assume here that the depth cannot exceed 256
parameter COUNT_WIDTH=((DEPTH <= 2) ? 2 :(DEPTH <= 4) ? 3 :(DEPTH <= 8) ? 4 :(DEPTH <= 16) ? 5:(DEPTH <= 32) ? 6:(DEPTH <= 64) ? 7:(DEPTH <= 128) ? 8:9);
parameter DW_ADDR_WIDTH= (COUNT_WIDTH-1);
   // if FIFO is  dual-clocked adjusting the RAM depth for odd and non-power of 2 compatibility with the control
parameter DW_EFFECTIVE_DEPTH_S1=DEPTH;
parameter DW_EFFECTIVE_DEPTH_S2=((DEPTH == (1 << DW_ADDR_WIDTH))? DEPTH : DEPTH + ((DEPTH & 1) ? 1: 2));
parameter DW_EFFECTIVE_DEPTH=((`i_axi_x2p_X2P_CLK_MODE==2) ? DW_EFFECTIVE_DEPTH_S1 : DW_EFFECTIVE_DEPTH_S2);
  
  output                                  arstatus_int; 
  output [`i_axi_x2p_X2P_AXI_SIDW-1:0]              arid_int;
  output                                  arlast_int;
  output [`i_axi_x2p_X2P_AXI_DW-1:0]                ardata_int;
  input                                   pop_data_int_n;
  output                                  arvalid_int_n;
  output                                  hrdata_rdy_int_n;
   
  
  input                                   clk_apb;
  input                                   push_data_int_n;
  input                                   hrstatus_int; 
  input [`i_axi_x2p_X2P_AXI_SIDW-1:0]               hrid_int;
  input                                   hrlast_int;
  input [`i_axi_x2p_X2P_AXI_DW-1:0]                 hrdata_int;
  
  input                                   push_rst_n;
  
  wire                                    arstatus_int;
  wire [DW_ADDR_WIDTH-1:0]                wr_addr,rd_addr;
 
  wire                                    we_n, hrdata_rdy_int_n, arvalid_int_n; 
  wire                                    mem_rst_n;
  wire                                    clk_push;
  wire [FIFO_WIDTH-1:0]                  data_out_int;
  wire [FIFO_WIDTH-1:0]                  data_in_int;
   
  assign                    mem_rst_n = push_rst_n;
 parameter PUSH_AE_LVL=(DEPTH == 1) ? 0 : 2;
 parameter TST_MODE=0;     // scan test input not connected

  assign clk_push = clk_apb;

  wire [DW_ADDR_WIDTH-1:0]  af_thresh,ae_level;
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

  // Call fifo Controller
  //spyglass disable_block W528
  //SMD: A signal or variable is set but never read.
  //SJ : BCM components are configurable to use in various scenarios in this particular design we are not using certain ports. Hence although those signals are read we are not driving them. Therefore waiving this warning.
   // single clock
  i_axi_x2p_DW_axi_x2p_bcm06
   #(DEPTH,TST_MODE, DW_ADDR_WIDTH)
      U_READ_FIFO_CONTROL_S1(
                .clk(clk_push),
                .rst_n(push_rst_n),
                .init_n(1'b1),
                .full(hrdata_rdy_int_n),
                .empty(arvalid_int_n),
                .af_thresh(af_thresh),                        
                .diag_n(1'b1),
                .ae_level(ae_level),
                .push_req_n(push_data_int_n),
                .pop_req_n(pop_data_int_n),
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
  wire [FIFO_WIDTH-1:0]           pushsf_data_in_int;
  wire [FIFO_WIDTH-1:0]           spushsf_data_out_int;
  
  assign pushsf_data_in_int = data_in_int;
  assign data_out_int       = spushsf_data_out_int;

  i_axi_x2p_DW_axi_x2p_bcm57
   #(FIFO_WIDTH,DW_EFFECTIVE_DEPTH,0,DW_ADDR_WIDTH)
     U_READ_DATA_FIFO_RAM( .clk(clk_push)
                          ,.rst_n(mem_rst_n)
                          ,.wr_n(we_n)
                          ,.rd_addr(rd_addr)
                          ,.wr_addr(wr_addr)
                          ,.data_in(pushsf_data_in_int)
                          ,.data_out(spushsf_data_out_int)
                          );

  assign arstatus_int = data_out_int[`i_axi_x2p_X2P_AXI_DW+`i_axi_x2p_X2P_AXI_SIDW+1];
  assign arid_int     = data_out_int[`i_axi_x2p_X2P_AXI_DW+`i_axi_x2p_X2P_AXI_SIDW:`i_axi_x2p_X2P_AXI_DW+1];
  assign arlast_int   = data_out_int[`i_axi_x2p_X2P_AXI_DW];
  assign ardata_int   = data_out_int[`i_axi_x2p_X2P_AXI_DW-1:0];
  
  assign data_in_int  = {hrstatus_int,hrid_int,hrlast_int,hrdata_int};
  
endmodule // DW_axi_x2p_read_data_buffer

  
  

  











         
                      

