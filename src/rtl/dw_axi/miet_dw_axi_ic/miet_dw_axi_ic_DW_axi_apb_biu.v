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
// Revision: $Id: //dwh/DW_ocb/DW_axi/amba_dev/src/DW_axi_apb_biu.v#8 $ 
**
** ---------------------------------------------------------------------
**
** File     : DW_axi_apb_biu.v
//
//
** Created  : Thu Nov 17 13:27:47 MEST 2011
** Modified : $Date: 2020/03/22 $
** Abstract : Apb bus interface module.
//           This module is intended for use with APB slave
//           macrocells.  The module generates output signals
//           from the APB bus interface that are intended for use in
//           the register block of the apb module.
//
//        1: Generates the write enable (wr_en) and read
//           enable (rd_en) for register accesses to the apb module.
//
//        2: Decodes the address bus (paddr) to generate the active
//           byte lane signal (byte_en).
//
//        3: Strips the APB address bus (paddr) to generate the
//           register offset address output (reg_addr).
//
//        4: Registers APB read data (prdata) onto the APB data bus.
//           The read data is routed to the correct byte lane in this
//           module.
//
// -------------------------------------------------------------------
 ---------------------------------------------------------------------*/

`include "miet_dw_axi_ic_DW_axi_all_includes.vh"

module miet_dw_axi_ic_DW_axi_apb_biu
(
 // APB bus interface
 pclk,
 presetn,
 psel,
 penable,
 pwrite, 
 paddr,
 pwdata,
 prdata,

 // regfile interface
 wr_en,
 rd_en,
 byte_en,
 reg_addr,
 ipwdata,
 iprdata
 );

   // -------------------------------------
   // -- APB bus signals
   // -------------------------------------
   input                            pclk;      // APB clock
   input                            presetn;   // APB reset
   input                            psel;      // APB slave select
   //Only bits required for register addressing are used. Rest bits are only present for interface consistency.
   input     [`miet_dw_axi_ic_APB_ADDR_WIDTH-1:0]  paddr;     // APB address
   input                            pwrite;    // APB write/read
   input                            penable;   // APB enable
   input      [`miet_dw_axi_ic_APB_DATA_WIDTH-1:0] pwdata;    // APB write data bus
   

   // -------------------------------------
   // -- Register block interface signals
   // -------------------------------------
   input  [`miet_dw_axi_ic_MAX_APB_DATA_WIDTH-1:0] iprdata;   // Internal read data bus


   output     [`miet_dw_axi_ic_APB_DATA_WIDTH-1:0] prdata;    // APB read data bus

   output                           wr_en;     // Write enable signal
   output                           rd_en;     // Read enable signal
   output                     [3:0] byte_en;   // Active byte lane signal
   output  [`miet_dw_axi_ic_IC_ADDR_SLICE_LHS-2:0] reg_addr;  // Register address offset
   output [`miet_dw_axi_ic_MAX_APB_DATA_WIDTH-1:0] ipwdata;   // Internal write data bus

   // -------------------------------------
   // -- Local registers & wires
   // -------------------------------------
   reg        [`miet_dw_axi_ic_APB_DATA_WIDTH-1:0] prdata;    // Registered prdata output
   reg    [`miet_dw_axi_ic_MAX_APB_DATA_WIDTH-1:0] ipwdata;   // Internal pwdata bus
  //Only required amount of bits used. Rest will be optimized
   wire                       [3:0] byte_en;   // Registered byte_en output
   
   // --------------------------------------------
   // -- write/read enable
   //
   // -- Generate write/read enable signals from
   // -- psel, penable and pwrite inputs
   // --------------------------------------------
   assign wr_en = psel &  penable &  pwrite ; 
   assign rd_en = psel & (!penable) & (!pwrite) ;

   
   // --------------------------------------------
   // -- Register address
   //
   // -- Strips register offset address from the
   // -- APB address bus
   // --------------------------------------------
   assign reg_addr = paddr[`miet_dw_axi_ic_IC_ADDR_SLICE_LHS:2];

   
   // --------------------------------------------
   // -- APB write data
   //
   // -- ipwdata is zero padded before being
   // -- passed through this block
   // --------------------------------------------
  //spyglass disable_block W415a
  //SMD: Signal may be multiply assigned (beside initialization) in the same scope
  //SJ: This is not an issue.
   always @(pwdata) begin : IPWDATA_PROC
      ipwdata = { `miet_dw_axi_ic_MAX_APB_DATA_WIDTH{1'b0} };
      ipwdata[`miet_dw_axi_ic_APB_DATA_WIDTH-1:0] = pwdata[`miet_dw_axi_ic_APB_DATA_WIDTH-1:0];
   end
  //spyglass enable_block W415a
   
   // --------------------------------------------
   // -- Set active byte lane
   //
   // -- This bit vector is used to set the active
   // -- byte lanes for write/read accesses to the
   // -- registers
   // --------------------------------------------
   //Since APB Data width is always 32. fixing the byte_enable as well.
   assign byte_en = 4'b1111;
   //always @(*) begin : BYTE_EN_PROC
   //     byte_en = 4'b1111;
   //end
   

   // --------------------------------------------
   // -- APB read data.
   //
   // -- Register data enters this block on a
   // -- 32-bit bus (iprdata). The upper unused
   // -- bit(s) have been zero padded before entering
   // -- this block.  The process below strips the
   // -- active byte lane(s) from the 32-bit bus
   // -- and registers the data out to the APB
   // -- read data bus (prdata).
   // --------------------------------------------
   always @(posedge pclk or negedge presetn) begin : PRDATA_PROC
      if(presetn == 1'b0) begin
         prdata <= { `miet_dw_axi_ic_APB_DATA_WIDTH{1'b0} };
      end else begin
         if(rd_en) begin
                  prdata <= iprdata;
         end
      end
   end
   
   
endmodule 
  
