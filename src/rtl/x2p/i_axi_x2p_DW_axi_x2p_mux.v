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

`include "i_axi_x2p_DW_axi_x2p_all_includes.vh"

module i_axi_x2p_DW_axi_x2p_mux (/*AUTOARG*/
  // Outputs
  prdata, 
                       // Inputs
                       psel, 
                       prdata_s0_s
                       );
  
  input [`i_axi_x2p_X2P_NUM_APB_SLAVES-1:0]        psel;
  input [`i_axi_x2p_X2P_APB_DATA_WIDTH-1:0]        prdata_s0_s;
  

  
  output [`i_axi_x2p_X2P_APB_DATA_WIDTH-1:0]       prdata;

  reg [`i_axi_x2p_X2P_APB_DATA_WIDTH-1:0]          prdata_s;

  assign                                 prdata = prdata_s;
  
    always@(*)
        begin: PRDATA_PROC
            case (psel)
              1:     prdata_s = prdata_s0_s;
              default:  prdata_s = {`i_axi_x2p_X2P_APB_DATA_WIDTH{1'b0}};
            endcase // case(psel)
        end // always@ (prdata_s0 or prdata_s1 or prdata_s10...



  
//       
endmodule // DW_axi_x2p_mux
