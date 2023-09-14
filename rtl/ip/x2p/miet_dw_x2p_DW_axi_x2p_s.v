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
// File Version     :        $Revision: #8 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2p/amba_dev/src/DW_axi_x2p_s.v#8 $ 
*/

//
//
//
// Filename    : DW_axi_x2ps.v
// 
// Description : APB Master for DW_axi_x2p bridge.
//-----------------------------------------------------------------------------

`include "miet_dw_x2p_DW_axi_x2p_all_includes.vh"

module miet_dw_x2p_DW_axi_x2p_s (/*AUTOARG*/
  // Outputs
  pop_hcmd_int_n, 
                     pop_wdata_int_n, 
                     hwid_int, 
                     hwstatus_int, 
                     push_resp_int_n, 
                     hrid_int, 
                     hrdata_int, 
                     hrstatus_int, 
                     hrlast_int, 
                     push_data_int_n, 
                     psel, 
                     paddr, 
                     penable, 
                     pwdata, 
                     pwrite, 
                     // Inputs
                     clk, 
                     rst_n, 
                     hcmd_queue_wd_int, 
                     hcmd_rdy_int_n, 
                     hwword_int, 
                     hwdata_rdy_int_n, 
                     hresp_rdy_int_n, 
                     read_buffer_full, 
                     pready_raw, 
                     pslverr_raw,
                     prdata
                     );
   input                              clk;
   input                              rst_n;

// Interface to Common CMD Queue

   input   [`X2P_CMD_QUEUE_WIDTH:0] hcmd_queue_wd_int;   // Contains several fields
   input                              hcmd_rdy_int_n;      // Low means not empty
   output                             pop_hcmd_int_n;      // Low-true POP

// Interface to Write Data FIFO

   input  [`X2P_AXI_WDFIFO_WIDTH-1:0] hwword_int;          // DATA, WSTRB, LAST
   input                              hwdata_rdy_int_n;    // Low means not empty
   output                             pop_wdata_int_n;     // Low-true POP


   // the contents of the write data buffer is registered

   input                              hresp_rdy_int_n;     // Low means: OK to push
   output             [`X2P_AXI_SIDW-1:0] hwid_int;
   output                             hwstatus_int;
   output                             push_resp_int_n;     // Low-true PUSH


// Interface to the RDFIFO

   input                              read_buffer_full;
   output             [`X2P_AXI_SIDW-1:0] hrid_int;
   output               [`X2P_AXI_DW-1:0] hrdata_int; 
   output                             hrstatus_int;
   output                             hrlast_int;
   output                             push_data_int_n;

 // APB master inputs 
   // raw is right off the buss when not APB3 
   // he raw signals will be bypassed and tied appropriatly 
  input                             pready_raw;  
  input                             pslverr_raw;
  input   [`X2P_APB_DATA_WIDTH-1:0] prdata;

  // APB master outputs
  output  [`X2P_NUM_APB_SLAVES-1:0] psel;
  output  [`X2P_APB_ADDR_WIDTH-1:0] paddr; 
  output                            penable;
  output  [`X2P_APB_DATA_WIDTH-1:0] pwdata;
  output                            pwrite;

  wire   [`X2P_CMD_QUEUE_WIDTH:0] hcmd_queue_wd_int;   // Contains several fields
  wire  [`X2P_AXI_WDFIFO_WIDTH-1:0] hwword_int;          // DATA, WSTRB, LAST
  wire   [`X2P_APB_DATA_WIDTH-1:0] prdata;
  
  wire [`X2P_NUM_APB_SLAVES-1:0]   psel;
  wire [`X2P_NUM_APB_SLAVES-1:0]   psel_ungated;
   
// these are after the AMBA compatibility adjustments   
   reg                             pready;
   reg                             pslverr;

   wire [`X2P_APB_ADDR_WIDTH-1:0]  paddr;
   
   wire [(`X2P_APB_DATA_WIDTH/8)-1:0] selected_strobes;
   wire [7:0] next_apb_wd_sel;

   wire [7:0] last_strobe;
   wire dcd_error,error,push_resp_request;
   wire set_addr,incr_addr,incr_base_addr;
   wire save_id,set_data,clr_data_reg;
   wire update_address,psel_en,enable_pack,last_push_read;

   wire [`X2P_CMD_ADDR_WIDTH-1:0] cmd_queue_addr; 
   wire [`X2P_AXI_SIDW-1:0]       cmd_id;
   
   wire [`X2P_AXI_DW-1:0]         conditioned_write_data;
   wire [(`X2P_AXI_DW/8)-1:0]     conditioned_write_strobes;

   wire [`X2P_AXI_DW-1:0]         packed_read_data;
   
   reg [`X2P_AXI_DW-1:0]          next_write_data,write_data_reg;
   reg [(`X2P_AXI_DW/8)-1:0]      next_write_strobes,write_strobes_reg;
   reg                            next_write_last,write_last_reg;
   wire                           rd_error;   
   
// Interface to Write Response FIFO

// if not APB3 tie pready active and pslverr low
   integer                        AMBA_VER;

  //spyglass disable_block SelfDeterminedExpr-ML
  //SMD: Self determined expression present in the design.
  //SJ : The expression indexing the vector/array will never exceed the boundary of the vector/array.
   assign cmd_id[`X2P_AXI_SIDW-1:0] = hcmd_queue_wd_int[(`LEN_WIDTH+`X2P_AXI_SIDW +5):(`LEN_WIDTH+6)];
  //spyglass enable_block SelfDeterminedExpr-ML
//   assign cmd_queue_addr[`X2P_CMD_ADDR_WIDTH-1:0] = hcmd_queue_wd_int >> (`LEN_WIDTH+`X2P_AXI_SIDW +6); 
   assign cmd_queue_addr[`X2P_CMD_ADDR_WIDTH-1:0] = hcmd_queue_wd_int[`X2P_CMD_QUEUE_WIDTH:`X2P_CMD_QUEUE_WIDTH-31]; 
   
   always @(*)
     begin: AMBA3_COMPATIBILITY_PROC
       AMBA_VER=1;
       case(psel)
          1: AMBA_VER = `X2P_IS_APB3_S0;
          2: AMBA_VER = `X2P_IS_APB3_S1;
    default: AMBA_VER = 1;
  endcase // case(psel)
    if (AMBA_VER >= 1)
      begin
        pready = pready_raw;
        pslverr = pslverr_raw;
      end
    else
      begin
        pready = 1'b1;       // AMBA 2 so I'll tie pready internally
        pslverr = 1'b0;         // no slave error so tie it internally
      end
    end // block: AMBA3_Compatibility
  
   
   assign conditioned_write_data = 
            hwword_int[`X2P_AXI_WDFIFO_WIDTH-1:`X2P_AXI_WDFIFO_WIDTH-`X2P_AXI_DW];
   assign conditioned_write_strobes = hwword_int[(`X2P_AXI_DW/8):1];
   assign hrdata_int = packed_read_data; 
   

   
/// monitor the write buffer output determine from the strobes the 1's APB and the last APB word
    miet_dw_x2p_DW_axi_x2p_first_last_strobe
     U_x2ps_first_last_strb(
                                   .clk(clk),
                                                        .rstn(rst_n),
                                                        .sample_strobes(incr_base_addr),      
                                                        .last_strobe(last_strobe)
                                                        );
      
    
// the control module contains all the state machines (read and write)
    miet_dw_x2p_DW_axi_x2p_s_control
     U_x2ps_ctrl(
                                     .clk(clk)
                                     ,.rstn(rst_n)
                                     ,// Inputs
                                     .cmd_queue_wd(hcmd_queue_wd_int) 
                                     ,.cmd_queue_empty(hcmd_rdy_int_n) 
                                     ,.write_buffer_last(write_last_reg) 
                                     ,.next_write_buff_empty(hwdata_rdy_int_n)
                                     ,.resp_rdy_n(hresp_rdy_int_n)
                                     ,.selected_strobes(selected_strobes)
                                     ,.dcd_error(dcd_error)
                                     ,.read_buffer_full(read_buffer_full)
                                     ,.pready(pready)
                                     ,.pslverr(pslverr)
                                     ,.last_strobes(last_strobe)
                                     ,// Outputs
                                     .pop_cmd_queue_n(pop_hcmd_int_n)
                                     ,.pop_write_buff_n(pop_wdata_int_n)
                                     ,.push_read_buffer_n(push_data_int_n)
                                     ,.error(error)
                                     ,.rd_error(rd_error)
                                     ,.push_rsp_buff_n(push_resp_request)
                                     ,.next_apb_wd_sel(next_apb_wd_sel)
                                     ,.set_addr(set_addr)
                                     ,.incr_base_addr(incr_base_addr)
                                     ,.set_data(set_data)
                                     ,.incr_addr(incr_addr)
                                     ,.update_address(update_address)
                                     ,.psel_en(psel_en)
                                     ,.penable(penable)
                                     ,.enable_pack(enable_pack)
                                     ,.last_push_read(last_push_read)
                                     ,.clr_rd_data_reg(clr_data_reg)
                                     ,.pwrite(pwrite)
                                     ,.save_id(save_id)
                                     );
   
   miet_dw_x2p_DW_axi_x2p_s_packer
    U_x2ps_pack(
                                   .clk(clk),
                                   .rstn(rst_n),
                                   // inputs
                                   .apb_data(prdata),
                                   .apb_addr(paddr),
                                   .cmd_id(cmd_id),
                                   .error(rd_error),
                                   .last(last_push_read),
                                   .enable_pack(enable_pack),
                                   .clr_reg(clr_data_reg),
                                   // outputs go to the read data buffer
                                   .axi_data(packed_read_data),
                                   .axi_id(hrid_int),
                                   .axi_resp(hrstatus_int),
                                   .axi_last(hrlast_int)
                                   );
   
   miet_dw_x2p_DW_axi_x2p_s_unpack
    U_x2ps_unpack(.clk(clk),
                                     .rstn(rst_n),
                                    // Outputs
                                    .selected_data(pwdata), 
                                    .selected_strobes(selected_strobes),
                                    // Inputs
                                    .write_buff_data(write_data_reg), 
                                    .write_buff_strobes(write_strobes_reg), 
//                                    .cmd_size(hcmd_queue_wd_int[5:3]),
                                    .next_apb_wd_sel(next_apb_wd_sel),
                                    .set_data(set_data)
                                     );
// this will issue responses to the write response buffer
   miet_dw_x2p_DW_axi_x2p_s_response
    U_x2ps_resp(.clk(clk),
                                     .rstn(rst_n),
                                     // inputs
                                     .wr_error(error),
                                     .push_req_n(push_resp_request),
                                     .cmd_id(cmd_id),
                                     .resp_rdy_n(hresp_rdy_int_n),
                                     .save_id(save_id),
                                     // outputs
                                     .resp_id(hwid_int),
                                     .resp_status(hwstatus_int),
                                     .push_n(push_resp_int_n)
                                    );
   // address generation for the APB and decode of address will issue 
   // an error upon address generated out of any APB slave address range
   
   miet_dw_x2p_DW_axi_x2p_s_addr_dcd
    U_x2ps_addr (
                                      .clk(clk),
                                      .rstn(rst_n),
                                      //Inputs
                                      .cmd_addr(cmd_queue_addr),
                                      .cmd_type(hcmd_queue_wd_int[2:1]),
                                      .cmd_size(hcmd_queue_wd_int[5:3]),
                                      //spyglass disable_block SelfDeterminedExpr-ML
                                      //SMD: Self determined expression present in the design.
                                      //SJ : The expression indexing the vector/array will never exceed the boundary of the vector/array.
                                      .cmd_len(hcmd_queue_wd_int[5+`LEN_WIDTH:6]),
                                      //spyglass enable_block SelfDeterminedExpr-ML
                                      .cmd_direction(hcmd_queue_wd_int[0]),
                                      .incr_addr(incr_addr),
                                      .incr_base_addr(incr_base_addr),
                                      .set_addr(set_addr),
                                      .update_address(update_address),
                                      // Outputs
                                      .dcd_error(dcd_error),
                                      .psel(psel_ungated),
                                      .paddr(paddr)
                                      );
// gate out the psel on active ops
   assign psel = (psel_en == 1'b1) ? psel_ungated : {`X2P_NUM_APB_SLAVES{1'b0}};   

   
// register the outputs of the write data buffer
   // he registering goes with each pop of the write data buffer
   // the data first goes through the endian conversion
   always @(*)
     begin: NEXT_WRITE_PROC
       next_write_data = write_data_reg;
       next_write_strobes = write_strobes_reg;
       next_write_last = write_last_reg;
       if (pop_wdata_int_n == 1'b0)
         begin
            next_write_data = conditioned_write_data;
            next_write_strobes = conditioned_write_strobes;
            next_write_last = hwword_int[0];
         end
     end // always @ (...

   
   //Register
   always @(posedge clk or negedge rst_n)
     begin: WRITE_DATA_PROC
       if (!rst_n)
       begin
         write_data_reg <= {`X2P_AXI_DW{1'b0}};
         write_strobes_reg <= {(`X2P_AXI_DW/8){1'b0}};
         write_last_reg <= 1'b0;
       end
       else
       begin
         write_data_reg <= next_write_data;
         write_strobes_reg <= next_write_strobes;
         write_last_reg <= next_write_last;
       end // else: !if(!rst_n)
     end // always @ (posedge clk or negedge rst_n)
   
endmodule // DW_axi_x2ps


