
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

`include "miet_dw_x2p_DW_axi_x2p_all_includes.vh"

module miet_dw_x2p_DW_axi_x2p (






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
                   ,psel_s1 
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
                   ,awlen 
                   ,awcache 
                   ,wstrb 
                   ,arid
                   ,arlen 
                   ,arcache 
                   ,pready_s0 
                   ,prdata_s0 
                   ,pslverr_s0
                   ,pready_s1 
                   ,prdata_s1 
                   ,pslverr_s1 
                   );

  input                             aclk; // AXI clock
  input                             aresetn; // AXI reset
  //Only the lower 32 bits are used. The extra MSBs are unused.
  input [`X2P_AXI_AW-1:0]               araddr; // AXI read address
  input [`X2P_AXI_AW-1:0]               awaddr; // AXI write address
  input [1:0]                       arburst; // AXI read burst
  input [`X2P_AXI_SIDW-1:0]             arid; // AXI read ID
  input [`LEN_WIDTH-1:0]            arlen; // AXI read length
  input [2:0]                       arsize; // AXI read size
  input                             arvalid; // AXI read valid
  input [1:0]                       awburst; // AXI write burst
  input [`X2P_AXI_SIDW-1:0]             awid; // AXI write ID
  input [`LEN_WIDTH-1:0]            awlen; // AXI write length
  //spyglass disable_block W240
  //SMD: An input has been declared but is not read.
  //SJ : arcache, arprot, arlock, awcache, awprot, wid and awlock these signals are unused. These are included for interface consistency only.
  input  [3:0] arcache;
  input  [2:0] arprot;
  input [`X2P_AXI_LTW-1:0]          arlock; // AXI read lock 
  input  [3:0] awcache;
  input  [2:0] awprot;
  input [`X2P_AXI_LTW-1:0]          awlock; // AXI write lock
  //spyglass enable_block W240
  input [2:0]                       awsize; // AXI write size
  input                             awvalid; // AXI write valid
  input                             bready; // AXI write response ready
  input                             rready; // AXI read response ready
  input [`X2P_AXI_DW-1:0]               wdata; // AXI write data
  input                             wlast; // AXI write data last
  input [`X2P_AXI_WSTRB_WIDTH-1:0]  wstrb; // AXI write data strobes
  input                             wvalid; // AXI write data valid

  input [`X2P_APB_DATA_WIDTH-1:0]   prdata_s0; // APB read data slave 0
  input [`X2P_APB_DATA_WIDTH-1:0]   prdata_s1; // APB read data slave 1
  input                             pready_s0; // APB ready data slave 0
  input                             pready_s1; // APB ready data slave 1
  input                             pslverr_s0; // APB error slave 0
  input                             pslverr_s1; // APB error slave 1

  output                            arready; // AXI read ready
  output                            awready; // AXI write ready
  output [`X2P_AXI_SIDW-1:0]            bid; // AXI write response ID
  output [1:0]                      bresp; // AXI write response
  output                            bvalid; // AXI write response valid
  output [`X2P_AXI_DW-1:0]              rdata; // AXI read data
  output [`X2P_AXI_SIDW-1:0]            rid; // AXI read data ID
  output                            rlast; // AXI read data last
  output [1:0]                      rresp; // AXI read response
  output                            rvalid; // AXI read valid
  output                            wready; // AXI write ready

  output [`X2P_APB_ADDR_WIDTH-1:0]  paddr; // APB address
  output                            penable; // APB enable
  output                            psel_s0; // APB select slave 0
  output                            psel_s1; // APB select slave 1
  output [`X2P_APB_DATA_WIDTH-1:0]  pwdata; // APB write data
  output                            pwrite; // APB write indicator

  // Low-power Channel



  // "Command" words
  wire [`X2P_CMD_QUEUE_WIDTH:0]     hcmd_queue_wd_int,
                                    cmd_queue_wd;

  // Write data (actually {WDATA,WSTRB,WLAST}
  wire [`X2P_AXI_WDFIFO_WIDTH-1:0]  awr_buff_wd,
                                    hwword_int;

  // Responses returned through write response, read data buffers
  wire                              hwstatus_int;
  wire                              pop_resp_status_wd;
  wire                              hrstatus_int;
  wire                              arstatus_int;

  // IDs returned through write response, read data buffers
  wire [`X2P_AXI_SIDW-1:0]              hwid_int,
                                    pop_resp_id_wd,
                                    hrid_int,
                                    arid_int;

  // Read data
  wire [`X2P_AXI_DW-1:0]                ardata_int,
                                    hrdata_int;
  wire                              read_buff_full;

  // read data from the APB muxed in from the slaves
  wire [`X2P_APB_DATA_WIDTH-1:0]    prdata;


  wire                              pready_s0_s;
  wire                              pready_s1_s;

  wire                              pslverr_s0_s;
  wire                              pslverr_s1_s;

  wire [`X2P_APB_DATA_WIDTH-1:0]    prdata_s0_s;
  wire [`X2P_APB_DATA_WIDTH-1:0]    prdata_s1_s;

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
  wire                              pready;
  wire                              pslverr;

  wire [`X2P_NUM_APB_SLAVES-1:0]    psel;

  assign {
          psel_s1,
         psel_s0} = psel;


  assign prdata_s0_s = prdata_s0;

  assign prdata_s1_s = prdata_s1;


  assign pready_s0_s = pready_s0;
  assign pready_s1_s = pready_s1;


  assign pslverr_s0_s = pslverr_s0;
  assign pslverr_s1_s = pslverr_s1;


  miet_dw_x2p_DW_axi_x2p_mux
   U_MUX (
                        .psel(psel),
                        .pready_s0_s(pready_s0_s),
                        .pready_s1_s(pready_s1_s),
                        .pslverr_s0_s(pslverr_s0_s),
                        .pslverr_s1_s(pslverr_s1_s),
                        .prdata_s0_s(prdata_s0_s),
                        .prdata_s1_s(prdata_s1_s),
                        .pready(pready),
                        .pslverr(pslverr),
                        .prdata(prdata)
                        );

 //DW_axi_x2p_p  #(`X2P_AXI_SIDW,`X2P_AXI_AW, `X2P_AXI_DW, `X2P_AXI_WSTRB_WIDTH,
miet_dw_x2p_DW_axi_x2p_p
  #(`X2P_AXI_SIDW,32, `X2P_AXI_DW, `X2P_AXI_WSTRB_WIDTH,
         `X2P_CMD_QUEUE_WIDTH,`X2P_AXI_WDFIFO_WIDTH,`LEN_WIDTH)
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
                           //                  `ifdef X2P_AXI3_INTERFACE
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

miet_dw_x2p_DW_axi_x2p_arb
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

miet_dw_x2p_DW_axi_x2p_cmd_queue
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

miet_dw_x2p_DW_axi_x2p_write_data_buffer
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


miet_dw_x2p_DW_axi_x2p_resp_buffer
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

miet_dw_x2p_DW_axi_x2p_read_data_buffer
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
 miet_dw_x2p_DW_axi_x2p_s
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
                             // Inputs from APB
                             // the raw ports are always here but in the
                             // case the slave is not APB3 these will be tied
                             // inside the master
                             .pready_raw(pready),
                             .pslverr_raw(pslverr),
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


 `undef LITTLE_ENDIAN_ENABLE
 `undef X2P_CLK_MODE_2
 `undef X2P_APB3_S0
 `undef X2P_APB3_S1
 `undef X2P_HAS_S1
 `undef X2P_PREADY_S0
 `undef X2P_PSLVERR_S0
 `undef X2P_PREADY_S1
 `undef X2P_PSLVERR_S1
endmodule // DW_axi_x2p































