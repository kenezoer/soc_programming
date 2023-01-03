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
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2p/amba_dev/src/DW_axi_x2p_s_response.v#9 $ 
*/

//
//

//-----------------------------------------------------------------------------
// Filename    : DW_axi_x2ps_response.v
// Created     : Dec 19 2005
// Description : APB control of the write response buffer
//               
//               
//----------------------------------------------------------------------------

`include "i_axi_x2p_DW_axi_x2p_all_includes.vh"

module i_axi_x2p_DW_axi_x2p_s_response(/*AUTOARG*/
   // Outputs
   resp_id, resp_status, push_n,
   // Inputs
   clk, rstn, wr_error, push_req_n, cmd_id, resp_rdy_n, save_id
   );

   input clk; 
   input rstn; 
  
   input wr_error;
   input push_req_n;
   input [`i_axi_x2p_X2P_AXI_SIDW-1:0] cmd_id;      // this is right from the cmd queue
   input resp_rdy_n;
   input save_id;
   
   output [`i_axi_x2p_X2P_AXI_SIDW-1:0] resp_id;
   output resp_status;
   output push_n;

  //When X2P is configured to single clock mode, the buffers are configured to pass through data without synchronization.
  //In this config the buffers can be configured to single entry deep. Waiving off the unused signals in this configuration.
   reg [`i_axi_x2p_X2P_AXI_SIDW-1:0] saved_cmd_id;
   reg saved_error;
   wire [`i_axi_x2p_X2P_AXI_SIDW-1:0]   next_saved_cmd_id;
   reg dlyd_resp,next_dlyd_resp;
   wire next_saved_error;

   
   // a push_req indicates that the control is finishing the last write
   // since a pop of the cmd queue may be occuring if te resp buff is not ready save the current
   // id and status and wait
   // register the id and the error, next cycle if the resp buff is ready push.
   assign   push_n =!((resp_rdy_n==1'b0) && dlyd_resp);

   assign   next_saved_cmd_id = (save_id == 1'b1) ? cmd_id : saved_cmd_id;
   assign   next_saved_error = (push_req_n == 1'b0) ? wr_error : saved_error;
   assign   resp_id = saved_cmd_id;
   assign   resp_status = next_saved_error; // any error is a SLVERR
  // spyglass disable_block W415a
  // SMD: Signal may be multiply assigned (beside initialization) in the same scope.
  // SJ : Here we are updating the signal next_dlyd_resp based on mutually dependent conditions. Hence waiving this warning. 
  always @(/*AS*/dlyd_resp or push_req_n or resp_rdy_n)
    begin:NEXT_DLYD_RESP_PROC
       next_dlyd_resp = dlyd_resp;
       if (push_req_n == 1'b0) next_dlyd_resp = 1'b1;
       if (dlyd_resp && (resp_rdy_n == 1'b0)) next_dlyd_resp = 1'b0;
    end
  // spyglass enable_block W415a 

  always @(posedge clk or negedge rstn)
    begin:SAVED_CMD_PROC
      if (!rstn)
        begin
          dlyd_resp <= 1'b0;
          saved_cmd_id <= {`i_axi_x2p_X2P_AXI_SIDW{1'b0}};
          saved_error <= 1'b0;
        end
      else
        begin
          dlyd_resp <= next_dlyd_resp;
          saved_cmd_id <= next_saved_cmd_id;
          saved_error <= next_saved_error;
        end // else: !if(rstn != 1'b1)
    end // always @ (posedge clk or negedge rstn)
  
endmodule // DW_axi_x2ps_response
























