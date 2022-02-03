
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
// File Version     :        $Revision: #6 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi/amba_dev/src/DW_axi_qos_req_filter.v#6 $ 
--
-- File     : DW_axi_qos_req_filter.v
//
//
-- Abstract : This module has following logic:        
--            1. Generates the peak rate flag as per the peak_rate.
--            2. Filters the request based on token and peak_rate_flg.
--
------------------------------------------------------------------------
*/
`include "miet_dw_axi_ic_DW_axi_all_includes.vh"
module miet_dw_axi_ic_DW_axi_qos_req_filter (

aclk_i                               ,
aresetn_i                            ,

reg_regulation_enable_i              ,
reg_peak_rate_i                      ,
//grant_i                              ,

req_i                                ,
slv_granted_pulse_i                  ,
valid_token_i                        ,
regulation_enabled_i                 ,
next_token_i                         , 

req_o                                ,
req_wire_o
);

//------------------------------------------------------------------------------
// Parameters
//------------------------------------------------------------------------------
parameter NC = 4;
parameter [0:0] PL_ARB = 0;
 
//------------------------------------------------------------------------------
// Input and Output signals.
//------------------------------------------------------------------------------
input                                    aclk_i                          ;
input                                    aresetn_i                       ;

//spyglass disable_block W240
//SMD: An input has been declared but is not read
//SJ: This port is used in specific configuration only 
input                                    reg_regulation_enable_i         ;
input    [`miet_dw_axi_ic_REG_PEAK_RATE_W-1:0]          reg_peak_rate_i                 ;

//input                                    grant_i                         ;
input    [NC-1:0]                        req_i                           ;
input                                    slv_granted_pulse_i             ;
input                                    valid_token_i                   ;
input                                    regulation_enabled_i            ;
input                                    next_token_i                    ;
//spyglass enable_block W240
// Based on the slave visibility, the particular request is unconnected in the top level DW_axi file.
output   [NC-1:0]                        req_o                           ;
output                                   req_wire_o                      ;

//------------------------------------------------------------------------------
// Internal signals.
//------------------------------------------------------------------------------
// Based on the slave visibility, the particular request is unconnected in the top level DW_axi file.
wire   [`miet_dw_axi_ic_REG_PEAK_RATE_W:0]      peak_rate_cnt     ; // peak rate counter
wire                             peak_rate_flg_set ; // peak rate flag set
reg    [`miet_dw_axi_ic_REG_PEAK_RATE_W:0]      peak_rate_cnt_r   ; // registered peak_rate_cnt
reg                              peak_rate_flg     ; // peak rate flag
wire                             req_wire_o        ; // wired OR req_o
wire                             next_req          ;
wire                             next_token_i      ;

//------------------------------------------------------------------------------
// Peak_rate counter incremented every clock if regulation is enabled.
//------------------------------------------------------------------------------
// Due to addition one of the selects is having higher width.
// spyglass disable_block W164b
// SMD: Identifies assignments in which the LHS width is greater than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
//      Hence this can be waived.  
assign peak_rate_cnt = reg_regulation_enable_i ? 
                       (peak_rate_cnt_r[`miet_dw_axi_ic_REG_PEAK_RATE_W-1:0] + 
                       reg_peak_rate_i) :{`miet_dw_axi_ic_REG_PEAK_RATE_W{1'b0}};
// spyglass enable_block W164b

//------------------------------------------------------------------------------
// peak_rate_flg_set is asserted when peak_rate_cnt MSB is set to 1.
//------------------------------------------------------------------------------
assign peak_rate_flg_set = peak_rate_cnt[`miet_dw_axi_ic_REG_PEAK_RATE_W];

//------------------------------------------------------------------------------
// Flopped stage.
//------------------------------------------------------------------------------
always @ (posedge aclk_i or negedge aresetn_i)
begin: peak_rate_cnt_r_PROC
   if (~aresetn_i)   peak_rate_cnt_r <= {(`miet_dw_axi_ic_REG_PEAK_RATE_W+1){1'b0}};
   else              peak_rate_cnt_r <= peak_rate_cnt;
end

//------------------------------------------------------------------------------
// peak_rate_flg is updated as per following:
// 1. regulation is not enabled or peak_rate set to 0, should be set to 1.
// 2. peak_rate_flg_set is asserted. req_wire_o is checked to make sure
//    peak_rate_flg is set in case the the peak_rate_flg was asserted earlier
//    (then only req_wire_o is asserted) and slave_grant has come in the same
//    clock.
// 3. Set to 1 in case of exception the req_o asserted previously didn't get
//    the grant when regulation was not enabled and regulation enables recently.
// 4. Reset to 0 in case slave is granted or regulation enabled recently.
//------------------------------------------------------------------------------
always @ (posedge aclk_i or negedge aresetn_i)
begin:peak_rate_flg_PROC 
   if (~aresetn_i)   peak_rate_flg <= 1'b0;
   else if ((!reg_regulation_enable_i || 
           (reg_peak_rate_i == {`miet_dw_axi_ic_REG_PEAK_RATE_W{1'b0}}))) peak_rate_flg <= 1'b1;
   else if ((peak_rate_flg_set && req_wire_o) || 
           (!slv_granted_pulse_i && 
           (req_wire_o || peak_rate_flg_set))) peak_rate_flg <= 1'b1;
   else if (slv_granted_pulse_i || regulation_enabled_i) peak_rate_flg <= 1'b0;
end

//------------------------------------------------------------------------------
// req_i is passed to req_o in case there is at least one token and 
// peak_rate_flg asserted else set to 0.
//------------------------------------------------------------------------------
assign req_o = next_req ? req_i : {NC{1'b0}};

assign req_wire_o = |req_o;

assign next_req = (PL_ARB && slv_granted_pulse_i) ? 
                             (next_token_i && peak_rate_flg_set) : 
(valid_token_i && peak_rate_flg);

endmodule


