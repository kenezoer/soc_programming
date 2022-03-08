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
// File Version     :        $Revision: #8 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi/amba_dev/src/DW_axi_apbif.v#8 $ 
**
** ---------------------------------------------------------------------
**
** File     : DW_axi_apbif.v
//
//
** Created  : Thu Nov 17 13:27:47 MEST 2011
** Modified : $Date: 2020/03/22 $
** Abstract : apb interface top level module**
** ---------------------------------------------------------------------
*/

`include "miet_dw_axi_ic_DW_axi_all_includes.vh"
module miet_dw_axi_ic_DW_axi_apbif (
     pclk,
     presetn,
     penable,
     psel,
     pwrite,
     paddr,
     pwdata,
     aclk,
     aresetn,
  
     reg_awqos_m1,
     reg_arqos_m1,
  
     reg_awqos_m2,
     reg_arqos_m2,
      prdata
 );
input                           pclk;
input                           presetn;
input                           penable;
input                           psel;
input                           pwrite;
//Only bits required for register addressing are used. Rest bits are only present for interface consistency.
input   [`miet_dw_axi_ic_APB_ADDR_WIDTH-1:0]   paddr;
input   [`miet_dw_axi_ic_APB_DATA_WIDTH-1:0]   pwdata;
input                           aclk;
input                           aresetn;
output  [`miet_dw_axi_ic_APB_DATA_WIDTH-1:0]   prdata;
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
     output  [`miet_dw_axi_ic_AXI_QOSW-1: 0]       reg_awqos_m1;
     output  [`miet_dw_axi_ic_AXI_QOSW-1: 0]       reg_arqos_m1;
  
    output  [`miet_dw_axi_ic_AXI_QOSW-1: 0]        reg_awqos_m2;
    output  [`miet_dw_axi_ic_AXI_QOSW-1: 0]        reg_arqos_m2;


 //local wire assigments
 wire    [3:0]                     byte_en;   // Active byte lane signal
 wire    [`miet_dw_axi_ic_IC_ADDR_SLICE_LHS-2:0]  reg_addr;  // Register address offset
 wire    [`miet_dw_axi_ic_MAX_APB_DATA_WIDTH-1:0] ipwdata;   // Internal write data bus
 wire    [`miet_dw_axi_ic_MAX_APB_DATA_WIDTH-1:0] iprdata;   // Internal read data  bus

 ///
wire  [`miet_dw_axi_ic_APB_DATA_WIDTH-1:0]   prdata;
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
     wire  [`miet_dw_axi_ic_AXI_QOSW-1: 0]       reg_awqos_m1;
     wire  [`miet_dw_axi_ic_AXI_QOSW-1: 0]       reg_arqos_m1;
  
    wire  [`miet_dw_axi_ic_AXI_QOSW-1: 0]        reg_awqos_m2;
    wire  [`miet_dw_axi_ic_AXI_QOSW-1: 0]        reg_arqos_m2;
  wire [31:0]  data_reg_in_aclk ;
  wire [31:0]  data_reg_o_aclk ;
  wire         qos_reg_wen_aclk;
  wire [7:0]   qos_reg_offset_aclk;
  wire [31:0]  data_reg_in_pclk ;
  wire [31:0]  data_reg_o_pclk ;
  wire         qos_reg_wen_pclk;
  wire [7:0]   qos_reg_offset_pclk;
  wire         internal_reg_rst;
  wire         err_bit_pclk;
  wire         command_en;
  wire         command_en_aclk;
  wire         wr_en;
  wire         rd_en;
  wire         qos_reg_rdn_pclk;
  wire         command_en_ack;
  wire         err_bit;
  wire         qos_reg_rdn_aclk;

 //
 //Submodule Instance 
 miet_dw_axi_ic_DW_axi_apb_biu
  U_DW_axi_apb_biu 
    (
 .pclk(pclk),
 .presetn(presetn),
 .psel(psel),
 .penable(penable),
 .pwrite(pwrite), 
 .paddr(paddr),
 .pwdata(pwdata),
 .prdata(prdata),
 .wr_en(wr_en),
 .rd_en(rd_en),
 .byte_en(byte_en),
 .reg_addr(reg_addr),
 .ipwdata(ipwdata),
 .iprdata(iprdata)
  );

  miet_dw_axi_ic_DW_axi_apb_regfile
   U_DW_axi_apb_regfile
   (
  .pclk(pclk),
  .presetn(presetn),
  .wr_en(wr_en),
  .rd_en(rd_en),
  .byte_en(byte_en),
  .reg_addr(reg_addr),
  .ipwdata(ipwdata),
  .iprdata(iprdata),
  .err_bit(err_bit_pclk),
  .data_reg_in(data_reg_in_pclk),
  .data_reg_out(data_reg_o_pclk),
  .qosreg_wr_en(qos_reg_wen_pclk),
  .qosreg_rd_en(qos_reg_rdn_pclk),
  .qosreg_offset(qos_reg_offset_pclk),
  .internal_reg_rst(internal_reg_rst),
  .command_en(command_en),
  .command_en_ack(command_en_ack)
  );

miet_dw_axi_ic_DW_axi_dummy_sync
 U_DW_axi_dummy_sync
  (
  .data_reg_in_aclk(data_reg_in_aclk),
  .data_reg_in_pclk(data_reg_in_pclk),
  .data_reg_o_aclk(data_reg_o_aclk),
  .data_reg_o_pclk(data_reg_o_pclk),
  .qos_reg_wen_aclk(qos_reg_wen_aclk),
  .qos_reg_wen_pclk(qos_reg_wen_pclk),
  .qos_reg_rdn_aclk(qos_reg_rdn_aclk),
  .qos_reg_rdn_pclk(qos_reg_rdn_pclk),
  .qos_reg_offset_aclk(qos_reg_offset_aclk),
  .qos_reg_offset_pclk(qos_reg_offset_pclk)
  );    

miet_dw_axi_ic_DW_axi_bcm21 
 
#(.WIDTH(1),.F_SYNC_TYPE(`miet_dw_axi_ic_AXI_NUM_SYNC_FF),.VERIF_EN(`miet_dw_axi_ic_AXI_VERIF_EN))U_DW_axi_bcm21_command_en_aclk
      (
         .clk_d               (aclk)
        ,.rst_d_n             (aresetn)
        ,.data_s              (command_en)
        ,.data_d              (command_en_aclk)
      );
miet_dw_axi_ic_DW_axi_bcm21 
 
#(.WIDTH(1),.F_SYNC_TYPE(`miet_dw_axi_ic_AXI_NUM_SYNC_FF),.VERIF_EN(`miet_dw_axi_ic_AXI_VERIF_EN))U_DW_axi_bcm21_command_en_pclk
      (
         .clk_d               (pclk)
        ,.rst_d_n             (presetn)
        ,.data_s              (command_en_aclk)
        ,.data_d              (command_en_ack)
      );
      
miet_dw_axi_ic_DW_axi_bcm21 
 #(.WIDTH(1),.F_SYNC_TYPE(`miet_dw_axi_ic_AXI_NUM_SYNC_FF),.VERIF_EN(`miet_dw_axi_ic_AXI_VERIF_EN))U_DW_axi_bcm21_err_bit_pclk
      (
         .clk_d               (pclk)
        ,.rst_d_n             (presetn)
        ,.data_s              (err_bit)
        ,.data_d              (err_bit_pclk)
      );

  
 miet_dw_axi_ic_DW_axi_qos_regfile
  U_DW_axi_qos_regfile
    (
     .aclk(aclk),
     .aresetn(aresetn),
     .internal_reg_rst(internal_reg_rst),
     .wr_en(qos_reg_wen_aclk),
     .rd_en(qos_reg_rdn_aclk),
     .addr(qos_reg_offset_aclk),
     .wdata(data_reg_o_aclk),
     .command_en_aclk(command_en_aclk),

















































    .reg_awqos_m1   (reg_awqos_m1),
    .reg_arqos_m1   (reg_arqos_m1),


    .reg_awqos_m2   (reg_awqos_m2),
    .reg_arqos_m2   (reg_arqos_m2),




























































































    .err_bit(err_bit),
    .rdata(data_reg_in_aclk)
     );
endmodule

 
