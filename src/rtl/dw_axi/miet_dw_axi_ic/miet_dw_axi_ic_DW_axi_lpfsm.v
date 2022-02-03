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
// File Version     :        $Revision: #24 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi_common/amba_dev/src/DW_axi_lpfsm.v#24 $ 
// ---------------------------------------------------------------------
//
*/
/* 
//
// ---------------------------------------------------------------------
// Author: Jorge Duarte
// ---------------------------------------------------------------------
//
//
*/
`include "miet_dw_axi_ic_DW_axi_all_includes.vh"

module miet_dw_axi_ic_DW_axi_lpfsm (
  // Outputs
  cactive, csysack, ready,
  // Inputs
  aclk, aresetn, active_trans, csysreq
  );
  
  // -------------------------------------------------------------------
  // Parameters
  // -------------------------------------------------------------------
  
  parameter [32:0] LOWPWR_NOPX_CNT   = 0;
  parameter LOWPWR_NOPX_CNT_W = 1;
// spyglass disable_block ParamWidthMismatch-ML
// SMD: Parameter width does not match with the value assigned
// SJ: Width of LOWPWR_NOPX_CNT is always 32 bit. While LOWPWR_NOPX_CNT_W is
// log2 of LOWPWR_NOPX_CNT, causing value of LOWPWR_NOPX_CNT_INT and LOWPWR_NOPX_CNT
// to be eqaul. Hence, this can waived.
  parameter [LOWPWR_NOPX_CNT_W-1:0] LOWPWR_NOPX_CNT_INT = LOWPWR_NOPX_CNT;
// spyglass enable_block ParamWidthMismatch-ML
  
  // -------------------------------------------------------------------
  // Ports
  // -------------------------------------------------------------------
  
  // Global signals  
  input                          aclk;         // clock 
  input                          aresetn;      // asynchronous reset 
  
  input                          active_trans; // active transaction  
  input                          csysreq;      // low power request 
  
  output                         cactive;      // low power clock active 
  output                         csysack;      // low power acknowledge 
  output                         ready;        // ready signal
  
  reg                            csysack_delay;
  reg                            csysack_rise;
  reg                            cactive;      // See description above
  reg                            csysack;      // See description above
  reg                            ready;        // See description above

// assign statements

  always@(posedge aclk or negedge aresetn)
  begin : csysack_PROC
    if(~aresetn)
    begin
      csysack       <= 1'b1;
      csysack_delay <= 1'b1;
    end
    else
    begin
      csysack       <= csysreq;
      csysack_delay <= csysack;
    end
  end
  
  always@(*)
  begin : csysack_rise_PROC
    csysack_rise = csysack && (~csysack_delay);
  end

  generate

    if (LOWPWR_NOPX_CNT == 0) 
    
    begin : gen_nopx_0
      always@(*)
      begin : cactive_zero_PROC
        cactive = active_trans || csysack_rise;
      end
  
    end 
    
    else
    
    begin : gen_nopx_1
      reg csysreq_rise;
      reg nopx_end_cnt;
      reg    [LOWPWR_NOPX_CNT_W-1:0] nopx_cnt;      
      wire   [LOWPWR_NOPX_CNT_W-1:0] nopx_cnt_c;      
      assign nopx_cnt_c = nopx_cnt;
  
      always@(*)
      begin : csysreq_rise_PROC
        csysreq_rise = csysreq && ~csysack;
      end

      always@(posedge aclk or negedge aresetn)
      begin : nopx_cnt_PROC
        if ( ~aresetn )
          nopx_cnt <= LOWPWR_NOPX_CNT_INT-1;
        else
        begin
          if ( ~csysreq )
            nopx_cnt <= 0;
          else
          begin
            if ( csysreq_rise )
              nopx_cnt <= LOWPWR_NOPX_CNT_INT;
            else
            begin
              if ( active_trans )
                nopx_cnt <= LOWPWR_NOPX_CNT_INT-1;
              else
              begin
                if ( nopx_cnt > 0 )
                  nopx_cnt <= nopx_cnt_c-1;
              end
            end
          end
        end
      end

      always@(posedge aclk or negedge aresetn)
      begin : nopx_end_cnt_PROC
        if(~aresetn)
          nopx_end_cnt <= 1'b0;
        else
        begin
          if ( ( nopx_cnt == 0 ) && ( active_trans == 1'b0 ) )
            nopx_end_cnt <= 1'b1;
          else
            nopx_end_cnt <= 1'b0;
        end
      end  
  
      always@(*)
      begin : cactive_PROC
        cactive = active_trans || csysack_rise
                  || ( ~nopx_end_cnt && csysack );
      end
  
    end
 
  endgenerate
  
  always@(posedge aclk or negedge aresetn)
  begin : ready_PROC
    if ( ~aresetn )
      ready <= 1'b1;
    else
    begin
      if ( cactive )
        ready <= 1'b1;
      else
      begin
        if ( ~csysack )
          ready <= 1'b0;
      end
    end
  end

endmodule
  
