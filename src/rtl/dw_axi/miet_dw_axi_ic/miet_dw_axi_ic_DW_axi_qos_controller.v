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
// Component Name   : DW_axi
// Component Version: 4.04a
// Release Type     : GA
// ------------------------------------------------------------------------------

// 
// Release version :  4.04a
// File Version     :        $Revision: #4 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi/amba_dev/src/DW_axi_qos_controller.v#4 $ 
--
-- File     : DW_axi_qos_controller.v
//
//
-- Abstract : Top Level File for DW_axi_qos_controller
--
------------------------------------------------------------------------
*/

`include "miet_dw_axi_ic_DW_axi_all_includes.vh"
module miet_dw_axi_ic_DW_axi_qos_controller (

aclk_i                               ,
aresetn_i                            ,

priority_i                           ,
req_i                                ,
grant_i                              ,
slave_ready_i                        ,

priority_o                           ,
req_o                                ,

reg_regulation_enable_i              ,
reg_peak_rate_i                      ,
reg_xct_rate_i                       ,
reg_burstiness_i                     ,
reg_slv_rdy_i
);

//------------------------------------------------------------------------------
// Parameters
//------------------------------------------------------------------------------
parameter NC = 4;
parameter PL_ARB = 0;

//------------------------------------------------------------------------------
// Input and Output signals.
//------------------------------------------------------------------------------
input                                       aclk_i                       ;
input                                       aresetn_i                    ;

input    [3:0]                              priority_i                   ;
input    [NC-1:0]                           req_i                        ;
input    [NC-1:0]                           grant_i                      ;
input    [NC-1:0]                           slave_ready_i                ;

output   [3:0]                              priority_o                   ;
output   [NC-1:0]                           req_o                        ;

input                                       reg_regulation_enable_i      ;
input    [`miet_dw_axi_ic_REG_PEAK_RATE_W-1:0]             reg_peak_rate_i              ;
input    [`miet_dw_axi_ic_REG_XCT_RATE_W-1:0]              reg_xct_rate_i               ;
input    [`miet_dw_axi_ic_REG_BURSTINESS_W-1:0]            reg_burstiness_i             ;
input                                       reg_slv_rdy_i                ;

//------------------------------------------------------------------------------
// Internal signals.
//------------------------------------------------------------------------------
wire  valid_token           ;   // Valid token from token_generator.
wire  slv_granted_pulse     ;   // slave granted pulse as input to req_filter.
wire  grant_int             ;   // Internal grant signal (wired OR of grant_i).
wire  req_wire              ;   // Wired req_o (wired OR).
wire  regulation_enabled    ;   // regulation is enabled recently.
wire  next_token            ;
//------------------------------------------------------------------------------
// grant_int is wired OR of grant_i input. Any grant coming to this master will
// be asserted only when there is a request asserted by the master.
//------------------------------------------------------------------------------
assign grant_int = |grant_i;

//------------------------------------------------------------------------------
// Pass through signals.
//------------------------------------------------------------------------------
assign priority_o = priority_i;

//------------------------------------------------------------------------------
// Module generates the token depending on xct_rate and burstiness programmed.
//------------------------------------------------------------------------------
miet_dw_axi_ic_DW_axi_qos_token_generator
 #(
   .NC(NC),
   .PL_ARB(PL_ARB)
   ) 
U_DW_axi_qos_token_generator (

   .aclk_i                    ( aclk_i                     ),
   .aresetn_i                 ( aresetn_i                  ),

   .reg_regulation_enable_i   ( reg_regulation_enable_i    ),
   .reg_xct_rate_i            ( reg_xct_rate_i             ),
   .reg_burstiness_i          ( reg_burstiness_i           ),
   .reg_slv_rdy_i             ( reg_slv_rdy_i              ),

   .req_i                     ( req_i                      ),
   .slave_ready_i             ( slave_ready_i              ),
   .grant_i                   ( grant_int                  ),
   .req_wire_i                (req_wire                    ),

   .next_token_o              ( next_token                 ),
   .slv_granted_pulse_o       ( slv_granted_pulse          ),
   .valid_token_o             ( valid_token                ),
   .regulation_enabled_o      ( regulation_enabled         )

);

//------------------------------------------------------------------------------
// Module filters the request based on token and peak_rate_flg availability.
//------------------------------------------------------------------------------
miet_dw_axi_ic_DW_axi_qos_req_filter
 #(
   .NC(NC),
   .PL_ARB(PL_ARB)
   ) 
U_DW_axi_qos_req_filter (

   .aclk_i                    ( aclk_i                     ),
   .aresetn_i                 ( aresetn_i                  ),

   .reg_regulation_enable_i   ( reg_regulation_enable_i    ),
   .reg_peak_rate_i           ( reg_peak_rate_i            ),
   //.grant_i                   ( grant_int                  ),
   .req_i                     ( req_i                      ),
   .slv_granted_pulse_i       ( slv_granted_pulse          ),
   .valid_token_i             ( valid_token                ),
   .regulation_enabled_i      ( regulation_enabled         ),
   .next_token_i              ( next_token                 ),

   .req_o                     ( req_o                      ),
   .req_wire_o                ( req_wire                   )
);


endmodule
