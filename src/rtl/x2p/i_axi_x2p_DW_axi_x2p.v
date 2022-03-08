
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
// File Version     :        $Revision: #13 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2p/amba_dev/src/DW_axi_x2p.v#13 $ 
*/
//
//

//-----------------------------------------------------------------------------
// Filename    : DW_axi_x2p.v
// Created     : Dec 15 2005
// Description : Top level AXI-to-APB bridge.
//               A unidirectional bridge which is an AXI slave and
//               an APB master.
//-----------------------------------------------------------------------------


  // BRESP[0] is always tied to zero. (Only OKAY and SLVERR responses are supported).
  // RRESP[0] is always tied to zero. (Only OKAY and SLVERR responses are supported).
  
//==============================================================================
// Start License Usage
//==============================================================================
//==============================================================================
// End License Usage
//==============================================================================

`include "i_axi_x2p_DW_axi_x2p_all_includes.vh"

module i_axi_x2p_DW_axi_x2p (






   // Outputs
   rdata 
                   ,bresp 
                   ,rresp 
                   ,bid 
                   ,rid 
                   ,awready 
                   ,wready 
                   ,bvalid 
                   ,arready
                   ,rlast 
                   ,rvalid
                   ,psel_s0 
                   ,paddr 
                   ,penable 
                   ,pwdata
                   ,pwrite 
                   ,// Inputs
                   aclk 
                   ,aresetn 
                   ,awaddr 
                   ,wdata 
                   ,araddr
                   ,// spyglass disable_block Topology_02
                   // SMD: No asynchronous pin to pin paths
                   // SJ: cactive is driven by these inputs asynchronously. There is desired behavior and will not cause any functional issue, hence waived.
                   awvalid 
                   ,arvalid
                   ,// spyglass enable_block Topology_02 
                   wlast 
                   ,wvalid
                   ,bready 
                   ,rready 
                   ,awburst 
                   ,awlock 
                   ,arburst 
                   ,arlock 
                   ,awsize
                   ,awprot 
                   ,arsize 
                   ,arprot 
                   ,awid 
                   ,wid 
                   ,awlen 
                   ,awcache 
                   ,wstrb 
                   ,arid
                   ,arlen 
                   ,arcache 
                   ,prdata_s0 
                   );

  input                             aclk; // AXI clock
  input                             aresetn; // AXI reset
  //Only the lower 32 bits are used. The extra MSBs are unused.
  input [`i_axi_x2p_X2P_AXI_AW-1:0]               araddr; // AXI read address
  input [`i_axi_x2p_X2P_AXI_AW-1:0]               awaddr; // AXI write address
  input [1:0]                       arburst; // AXI read burst
  input [`i_axi_x2p_X2P_AXI_SIDW-1:0]             arid; // AXI read ID
  input [`i_axi_x2p_LEN_WIDTH-1:0]            arlen; // AXI read length
  input [2:0]                       arsize; // AXI read size
  input                             arvalid; // AXI read valid
  input [1:0]                       awburst; // AXI write burst
  input [`i_axi_x2p_X2P_AXI_SIDW-1:0]             awid; // AXI write ID
  input [`i_axi_x2p_LEN_WIDTH-1:0]            awlen; // AXI write length
  //spyglass disable_block W240
  //SMD: An input has been declared but is not read.
  //SJ : arcache, arprot, arlock, awcache, awprot, wid and awlock these signals are unused. These are included for interface consistency only.
  input  [3:0] arcache;
  input  [2:0] arprot;
  input [`i_axi_x2p_X2P_AXI_LTW-1:0]          arlock; // AXI read lock 
  input  [3:0] awcache;
  input  [2:0] awprot;
  input [`i_axi_x2p_X2P_AXI_SIDW-1:0]             wid; // AXI write data ID
  input [`i_axi_x2p_X2P_AXI_LTW-1:0]          awlock; // AXI write lock
  //spyglass enable_block W240
  input [2:0]                       awsize; // AXI write size
  input                             awvalid; // AXI write valid
  input                             bready; // AXI write response ready
  input                             rready; // AXI read response ready
  input [`i_axi_x2p_X2P_AXI_DW-1:0]               wdata; // AXI write data
  input                             wlast; // AXI write data last
  input [`i_axi_x2p_X2P_AXI_WSTRB_WIDTH-1:0]  wstrb; // AXI write data strobes
  input                             wvalid; // AXI write data valid

  input [`i_axi_x2p_X2P_APB_DATA_WIDTH-1:0]   prdata_s0; // APB read data slave 0

  output                            arready; // AXI read ready
  output                            awready; // AXI write ready
  output [`i_axi_x2p_X2P_AXI_SIDW-1:0]            bid; // AXI write response ID
  output [1:0]                      bresp; // AXI write response
  output                            bvalid; // AXI write response valid
  output [`i_axi_x2p_X2P_AXI_DW-1:0]              rdata; // AXI read data
  output [`i_axi_x2p_X2P_AXI_SIDW-1:0]            rid; // AXI read data ID
  output                            rlast; // AXI read data last
  output [1:0]                      rresp; // AXI read response
  output                            rvalid; // AXI read valid
  output                            wready; // AXI write ready

  output [`i_axi_x2p_X2P_APB_ADDR_WIDTH-1:0]  paddr; // APB address
  output                            penable; // APB enable
  output                            psel_s0; // APB select slave 0
  output [`i_axi_x2p_X2P_APB_DATA_WIDTH-1:0]  pwdata; // APB write data
  output                            pwrite; // APB write indicator

  // Low-power Channel



  // "Command" words
  wire [`i_axi_x2p_X2P_CMD_QUEUE_WIDTH:0]     hcmd_queue_wd_int,
                                    cmd_queue_wd;

  // Write data (actually {WDATA,WSTRB,WLAST}
  wire [`i_axi_x2p_X2P_AXI_WDFIFO_WIDTH-1:0]  awr_buff_wd,
                                    hwword_int;

  // Responses returned through write response, read data buffers
  wire                              hwstatus_int;
  wire                              pop_resp_status_wd;
  wire                              hrstatus_int;
  wire                              arstatus_int;

  // IDs returned through write response, read data buffers
  wire [`i_axi_x2p_X2P_AXI_SIDW-1:0]              hwid_int,
                                    pop_resp_id_wd,
                                    hrid_int,
                                    arid_int;

  // Read data
  wire [`i_axi_x2p_X2P_AXI_DW-1:0]                ardata_int,
                                    hrdata_int;
  wire                              read_buff_full;

  // read data from the APB muxed in from the slaves
  wire [`i_axi_x2p_X2P_APB_DATA_WIDTH-1:0]    prdata;




  wire [`i_axi_x2p_X2P_APB_DATA_WIDTH-1:0]    prdata_s0_s;

  // Internal wires in the AXI-clock domain
  wire                              awvalid_gtd;
//  wire                              awready_int;
  wire                              wvalid_gtd;
  wire                              wready_int;
  wire                              arvalid_gtd;
//  wire                              arready_int;
  wire                              resp_pop_rdy_n;
  wire                              pop_resp_n;
  wire                              wr_buff_push_rdy_n;
  wire                              push_write_buffer_n;
  wire                              arlast_int;
  wire                              pop_rdata_n;
  wire                              arvalid_int_n;
  wire                              cmd_push_af;
  wire                              cmd_queue_push_rdy_n;

  // Internal wires in the AHB-clock domain
  wire                              hcmd_rdy_int_n;
  wire                              pop_hcmd_int_n;
  wire                              hwdata_rdy_int_n;
  wire                              pop_wdata_int_n;
  wire                              hresp_rdy_int_n;
  wire                              push_resp_int_n;
  wire                              hrlast_int;
  wire                              push_data_int_n;
  wire                              push_cmd_queue_n;

  // when using a single clock connect aclk internally
  wire                              pclk_int;
  wire                              presetn_int;


  assign                            pclk_int =  aclk;
  assign                            presetn_int = aresetn;

  wire [`i_axi_x2p_X2P_NUM_APB_SLAVES-1:0]    psel;

  assign {
         psel_s0} = psel;


  assign prdata_s0_s = prdata_s0;







  i_axi_x2p_DW_axi_x2p_mux
   U_MUX (
                        .psel(psel),
                        .prdata_s0_s(prdata_s0_s),
                        .prdata(prdata)
                        );

 //DW_axi_x2p_p  #(`i_axi_x2p_X2P_AXI_SIDW,`i_axi_x2p_X2P_AXI_AW, `i_axi_x2p_X2P_AXI_DW, `i_axi_x2p_X2P_AXI_WSTRB_WIDTH,
i_axi_x2p_DW_axi_x2p_p
  #(`i_axi_x2p_X2P_AXI_SIDW,32, `i_axi_x2p_X2P_AXI_DW, `i_axi_x2p_X2P_AXI_WSTRB_WIDTH,
         `i_axi_x2p_X2P_CMD_QUEUE_WIDTH,`i_axi_x2p_X2P_AXI_WDFIFO_WIDTH,`i_axi_x2p_LEN_WIDTH)
               U_AXI_SLAVE(
                  .awid(awid),
                           .awaddr(awaddr[31:0]),
                           .awlen(awlen),
                           .awsize(awsize),
                           .awburst(awburst),
                           //                  .awlock(awlock),
                           //                  .awcache(awcache),
                           //                  .awprot(awprot),
                           //                  .awready(awready_int),
                           //                  `ifdef i_axi_x2p_X2P_AXI3_INTERFACE
                           //                  .wid(wid),
                           //                  `endif
                           .awvalid(awvalid_gtd),
                           .wdata(wdata),
                           .wstrb(wstrb),
                           .wlast(wlast),
                           .wvalid(wvalid_gtd),
                           .wready(wready_int),
                           .bid(bid),
                           .bresp(bresp),
                           .bvalid(bvalid),
                           .bready(bready),
                           // the response buffer
                           .response_avail_n(resp_pop_rdy_n),
                           .pop_resp_n(pop_resp_n),
                           .pop_resp_word({pop_resp_status_wd,pop_resp_id_wd}),
                           // the write data buffer
                           .write_buffer_wd(awr_buff_wd),
                           .push_write_buffer_n(push_write_buffer_n),
                           .write_buff_rdy_n(wr_buff_push_rdy_n),
                           // read side
                           .arid(arid),
                           .araddr(araddr[31:0]),
                           .arlen(arlen),
                           .arsize(arsize),
                           .arburst(arburst),
                           //                  .arlock(arlock),
                           //                  .arcache(arcache),
                           //                  .arprot(arprot),
                           .arvalid(arvalid_gtd),
                           //                  .arready(arready_int),
                           .rid(rid),
                           .rdata(rdata),
                           .rresp(rresp),
                           .rlast(rlast),
                           .rvalid(rvalid),
                           .rready(rready),
                           // the read data buffer
                           .arstatus_int(arstatus_int),
                           .arid_int(arid_int),
                           .arlast_int(arlast_int),
                           .ardata_int(ardata_int),
                           .pop_data_int_n(pop_rdata_n),
                           .arvalid_int_n(arvalid_int_n),
                           .push_cmd_queue_n(push_cmd_queue_n),
                           .cmd_queue_wd(cmd_queue_wd),
                           .cmd_queue_rdy_n(cmd_queue_push_rdy_n)
                           );

// no low-power in the bridge
   // just a report of internal activity

i_axi_x2p_DW_axi_x2p_arb
 U_X2H_ARB (
                 .aclk(aclk),
                 .aresetn(aresetn),
                 // Outputs
                 .wvalid_gtd(wvalid_gtd),
                 .wready(wready),
                 .awvalid_gtd(awvalid_gtd),
                 .arvalid_gtd(arvalid_gtd),
                 .awready(awready),
                 .arready(arready),
                 // Inputs
                 .wvalid(wvalid),
                 .awvalid(awvalid),
                 .arvalid(arvalid),
                 .wready_int(wready_int),
                 .cmd_queue_rdy_n(cmd_queue_push_rdy_n),
                 .cmd_push_af(cmd_push_af)
                 );

// FIFOs

i_axi_x2p_DW_axi_x2p_cmd_queue
 U_CMD_QUEUE (
               // the AXI slave side is pushing
               .clk_axi(aclk),
                                  .push_rst_n(aresetn),
                                  .acmd_queue_wd_int(cmd_queue_wd),
                                  .push_acmd_int_n(push_cmd_queue_n),
                                  .acmd_rdy_int_n(cmd_queue_push_rdy_n),
                                  .push_af(cmd_push_af),
                                  .pop_hcmd_int_n(pop_hcmd_int_n),
                                  .hcmd_queue_wd_int(hcmd_queue_wd_int),
                                  .hcmd_rdy_int_n(hcmd_rdy_int_n)
                                  );

i_axi_x2p_DW_axi_x2p_write_data_buffer
 U_WR_DATA_BUFF (
             // AXI Slave Side is pushing
             .clk_axi(aclk),
                                             .push_rst_n(aresetn),
                                             .awword_int(awr_buff_wd),
                                             .push_awdata_int_n(push_write_buffer_n),
                                             .awdata_rdy_int_n(wr_buff_push_rdy_n),
                                             .hwword_int(hwword_int),
                                             .pop_wdata_int_n(pop_wdata_int_n),
                                             .hwdata_rdy_int_n(hwdata_rdy_int_n)
                                             );


i_axi_x2p_DW_axi_x2p_resp_buffer
 U_RESP_BUFF (
               // the AXI slave side is popping
                                    .awstatus_int(pop_resp_status_wd),
                                    .awid_int(pop_resp_id_wd),
                                    .pop_resp_int_n(pop_resp_n),
                                    .aresp_rdy_int_n(resp_pop_rdy_n),
                                    // the APB Master Side is pushing
                                    .clk_apb(pclk_int),
                                    .push_rst_n(presetn_int),
                                    .hwstatus_int(hwstatus_int),
                                    .hwid_int(hwid_int),
                                    .push_resp_int_n(push_resp_int_n),
                                    .hresp_rdy_int_n(hresp_rdy_int_n)
                                    );

i_axi_x2p_DW_axi_x2p_read_data_buffer
 U_RD_DATA_BUFF (
             // AXI Slave Side is popping
                                            .arstatus_int(arstatus_int),
                                            .arid_int(arid_int),
                                            .arlast_int(arlast_int),
                                            .ardata_int(ardata_int),
                                            .pop_data_int_n(pop_rdata_n),
                                            .arvalid_int_n(arvalid_int_n),
                                            // the APB Master Side is pushing
                                            .clk_apb(pclk_int),
                                            .push_rst_n(presetn_int),
                                            .hrstatus_int(hrstatus_int),
                                            .hrid_int(hrid_int),
                                            .hrlast_int(hrlast_int),
                                            .hrdata_int(hrdata_int),
                                            .push_data_int_n(push_data_int_n),
                                            .hrdata_rdy_int_n(read_buff_full)
                                            );

// APB Master interface
 i_axi_x2p_DW_axi_x2p_s
   U_APB_MASTER (
             // Inputs
             .clk(pclk_int),
                             .rst_n(presetn_int),
                             // Inputs from internal FIFOs
                             .hcmd_queue_wd_int(hcmd_queue_wd_int),
                             .hcmd_rdy_int_n(hcmd_rdy_int_n),
                             .hwword_int(hwword_int),
                             .hwdata_rdy_int_n(hwdata_rdy_int_n),
                             .hresp_rdy_int_n(hresp_rdy_int_n),
                             .read_buffer_full(read_buff_full),
                             .prdata(prdata),
                             // Outputs
                             // to the internal FIFOs
                             .pop_hcmd_int_n(pop_hcmd_int_n),
                             .pop_wdata_int_n(pop_wdata_int_n),
                             .hwid_int(hwid_int),
                             .hwstatus_int(hwstatus_int),
                             .push_resp_int_n(push_resp_int_n),
                             .hrid_int(hrid_int),
                             .hrdata_int(hrdata_int),
                             .hrstatus_int(hrstatus_int),
                             .hrlast_int(hrlast_int),
                             .push_data_int_n(push_data_int_n),
                             // Outputs to the APB
                             .psel(psel),
                             .paddr(paddr),
                             .pwdata(pwdata),
                             .pwrite(pwrite),
                             .penable(penable)
                             );


 `undef i_axi_x2p_LITTLE_ENDIAN_ENABLE
 `undef i_axi_x2p_X2P_CLK_MODE_2
endmodule // DW_axi_x2p































