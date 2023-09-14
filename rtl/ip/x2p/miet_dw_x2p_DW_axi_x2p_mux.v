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
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2p/amba_dev/src/DW_axi_x2p_mux.v#8 $ 
*/
//-----------------------------------------------------------------------------
//
//
// Description : Output multiplexor.
//-----------------------------------------------------------------------------

`include "miet_dw_x2p_DW_axi_x2p_all_includes.vh"

module miet_dw_x2p_DW_axi_x2p_mux (/*AUTOARG*/
  // Outputs
  prdata, 
                       pready,
                       pslverr, 
                       prdata_s1_s,
                       pready_s0_s, 
                       pready_s1_s, 
                       pslverr_s0_s,
                       pslverr_s1_s,
                       // Inputs
                       psel, 
                       prdata_s0_s
                       );
  
  input [`X2P_NUM_APB_SLAVES-1:0]        psel;
  input [`X2P_APB_DATA_WIDTH-1:0]        prdata_s0_s;
  input [`X2P_APB_DATA_WIDTH-1:0]        prdata_s1_s;
  
  input                                  pready_s0_s;
  input                                  pready_s1_s;  

  input                                  pslverr_s0_s;
  input                                  pslverr_s1_s;  
  
  output [`X2P_APB_DATA_WIDTH-1:0]       prdata;
  output                                 pready;
  output                                 pslverr;

  reg [`X2P_APB_DATA_WIDTH-1:0]          prdata_s;
  reg                                    pready_s;
  reg                                    pslverr_s;

  assign                                 prdata = prdata_s;
  assign                                 pready = pready_s;
  assign                                 pslverr = pslverr_s;
  
    always@(*)
        begin: PRDATA_PROC
            case (psel)
              1:     prdata_s = prdata_s0_s;
              2:     prdata_s = prdata_s1_s;
              default:  prdata_s = {`X2P_APB_DATA_WIDTH{1'b0}};
            endcase // case(psel)
        end // always@ (prdata_s0 or prdata_s1 or prdata_s10...


   always @(*)
     begin:PREADY_S_PROC
     case(psel)
          1:     pready_s = pready_s0_s;
          2:     pready_s = pready_s1_s;
        default: pready_s = 1'b0;
     endcase // case(psel)
   end // always @ (...   

   always @(*)
     begin: PSLVERR_S_PROC
     case(psel)
          1:     pslverr_s = pslverr_s0_s;
          2:     pslverr_s = pslverr_s1_s;
       default: pslverr_s = 1'b0;
     endcase // case(psel)
   end // always @ (...  
  
//       
endmodule // DW_axi_x2p_mux
