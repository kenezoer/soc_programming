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
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2p/amba_dev/src/DW_axi_x2p_s_packer.v#9 $ 
*/
//-----------------------------------------------------------------------------
//
//
// 
// Filename    : DW_axi_x2ps_packer.v
// 
// Description : APB read data packing for DW_axi_x2p bridge.
//               Positions and loads the APB read data and holds it
//               for pushing into the read data buffer
//-----------------------------------------------------------------------------

`include "DW_axi_x2p_all_includes.vh"

module DW_axi_x2p_s_packer (/*AUTOARG*/
   // Outputs
   axi_data, 
                            axi_id, 
                            axi_resp, 
                            axi_last,
                            // Inputs
                            clk, 
                            rstn, 
                            apb_data, 
                            apb_addr, 
                            clr_reg,
                            cmd_id, 
                            error, 
                            enable_pack, 
                            last
                            );


   input                                clk;
   input                                rstn;
   input [`X2P_APB_DATA_WIDTH-1:0]      apb_data;
   // spyglass disable_block W240
   // SMD: An input has been declared but is not read.
   // SJ : apb_addr is read only when X2P_AXI_DW > X2P_APB_DATA_WIDTH.
   input [`X2P_APB_ADDR_WIDTH-1:0]      apb_addr;
   // spyglass enable_block W240
   input                                clr_reg;
   
   
   input [`X2P_AXI_SIDW-1:0]            cmd_id;
   input                                error;
   input                                enable_pack;
   input                                last;
   
   
   output [`X2P_AXI_DW-1:0]             axi_data;
   output [`X2P_AXI_SIDW-1:0]           axi_id;
   output                               axi_resp;
   output                               axi_last;
   
   wire [`X2P_AXI_DW-1:0]           axi_data;   
  // When X2P is configured to single clock mode, the buffers are configured to pass through data without synchronization.
  // In this config the buffers can be configured to single entry deep. Waiving off the unused signals in this configuration.
   reg [`X2P_AXI_DW-1:0]            axi_data_reg, next_axi_data;
   reg [`X2P_AXI_SIDW-1:0]          axi_id;
   wire                             axi_resp;
   
//Integer start is used as an index to the next_data_axi signal. This is not a valid issue.
   integer                          ii,jj,start;


//   reg [`X2P_APB_DATA_WIDTH-1:0] temp_data;
   
   
 /* AUTO_CONSTANT (`X2P_APB_DATA_WIDTH, `APB_BUS_SIZE, `X2P_AXI_DW, `X2P_MAX_AXI_SIZE) */ 

 
// go down all APB word wide inputs to the AXI word 
   //  has a mux for each of AXI Data width/ APB data width

   always @(*)
     begin: NEXT_AXI_DATA_PROC
       start = 0;
       if (clr_reg) next_axi_data = {`X2P_AXI_DW{1'b1}};//-1;
       else next_axi_data = axi_data_reg;
//temp_data = {`X2P_APB_DATA_WIDTH{1'b0}};

       if (enable_pack)
         begin
           start = 0;     
           // each APB Data Word
           for (ii=0; ii < (`X2P_AXI_DW/`X2P_APB_DATA_WIDTH); ii = ii + 1)
             begin
             if (ii == 0) 
             // this is the one to update
             begin
// $display("----------%0t  start %0d AXI_DATA_WIDTH %0d ---------------------------------------",
// $time,start,`X2P_AXI_DW);
       // spyglass disable_block W415a
       // SMD: Signal may be multiply assigned (beside initialization) in the same scope.
       // SJ : Here we are initializing the next_axi_data before assignment based on assertion of clr_reg signal.          
               for (jj=0; jj<`X2P_APB_DATA_WIDTH; jj = jj + 1)
                 begin
                   next_axi_data[start+jj] = apb_data[jj];
//         temp_data[jj] = apb_data[jj];
//      $display("%t temp_data[%0d] = %0d (%0d)",$time,jj,temp_data[jj],apb_data[jj]);
                 end
       // spyglass enable_block W415a
// $display("%t ii=%0d apb_axi_displ %0d start %0d next_axi_data %h apb_data %h, temp_data %h",
//                           $time,ii,apb_axi_displ,start, next_axi_data, apb_data, temp_data);
             end // if (ii == apb_axi_displ)
               start = start + `X2P_APB_DATA_WIDTH;
             end // for (ii=0; ii < (`X2P_AXI_DW/`X2P_APB_DATA_WIDTH); ii = ii + 1)
         end // if (enable_pack)
     end // always @ (...
   

   
   assign axi_data = axi_data_reg;

   assign axi_last = last;   // un registered apb_xfer_cnt from control;
   
   assign axi_resp = error;
   
   
   always @(posedge clk or negedge rstn)
     begin: S_AXI_REG_PROC
       if (rstn == 1'b0)
         begin
           axi_data_reg <= {`X2P_AXI_DW{1'b0}};
           axi_id <= {`X2P_AXI_SIDW{1'b0}};     
         end
       else
         begin
            axi_data_reg <= next_axi_data;
            axi_id <= cmd_id;
         end // else: !if(rstn == 1'b0)
     end // always @ (posedge clk or negedge rstn)

    
endmodule // DW_axi_x2ps_packer


















