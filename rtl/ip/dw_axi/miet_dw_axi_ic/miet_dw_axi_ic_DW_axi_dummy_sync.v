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
// File Version     :        $Revision: #4 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi/amba_dev/src/DW_axi_dummy_sync.v#4 $ 
**
** ---------------------------------------------------------------------
**
** File     : DW_axi_dummy_sync.v
//
//
** Created  : Thu Nov 17 13:27:47 MEST 2011
** Modified : $Date: 2020/03/22 $
** Abstract : Dummy module kept for CDC check purpose.
**            This module list all the signals corssing clock domain.
**            All the CDC signals are qualified by a qualifier (handshake mechanism)
**            hence synchronization is not required.
** ---------------------------------------------------------------------
*/

`include "miet_dw_axi_ic_DW_axi_all_includes.vh"

module miet_dw_axi_ic_DW_axi_dummy_sync (
     data_reg_in_aclk,
     data_reg_o_pclk,
     qos_reg_wen_pclk,
     qos_reg_rdn_pclk,
     qos_reg_offset_pclk,
     data_reg_in_pclk,
     data_reg_o_aclk,
     qos_reg_wen_aclk,
     qos_reg_rdn_aclk,
     qos_reg_offset_aclk
     );

   //----------------------------------------------------
   //---Port declaraion-----------------
   //------------------------------------------------------
    input  [31:0]                     data_reg_in_aclk; // data reg 
    output [31:0]                     data_reg_o_aclk; 
    output                            qos_reg_wen_aclk; // qos register write enable 
    output                            qos_reg_rdn_aclk;  // qos register read enable
    output [7:0]                      qos_reg_offset_aclk; // qos registers offset
    output [31:0]                     data_reg_in_pclk; 
    input  [31:0]                     data_reg_o_pclk; 
    input                             qos_reg_wen_pclk; 
    input                             qos_reg_rdn_pclk; 
    input  [7:0]                      qos_reg_offset_pclk; 
         
   // ----------------------------------------------------------
   // -- local registers and wires
   // ----------------------------------------------------------
   //
     wire [31:0]                      data_reg_o_pclk; 
     wire                             qos_reg_wen_pclk; 
     wire [7:0]                       qos_reg_offset_pclk; 
     wire [31:0]                      data_reg_in_aclk; 
     
          
     assign data_reg_o_aclk      =  data_reg_o_pclk ;
     assign qos_reg_wen_aclk     =  qos_reg_wen_pclk ;
     assign qos_reg_rdn_aclk     =  qos_reg_rdn_pclk ;
     assign qos_reg_offset_aclk  =  qos_reg_offset_pclk ;
     assign data_reg_in_pclk     =  data_reg_in_aclk ;

    
                        
  endmodule
