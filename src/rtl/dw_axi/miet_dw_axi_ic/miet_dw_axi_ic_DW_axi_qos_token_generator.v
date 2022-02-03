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
// Revision: $Id: //dwh/DW_ocb/DW_axi/amba_dev/src/DW_axi_qos_token_generator.v#6 $ 
--
-- File     : DW_axi_qos_token_generator.v
//
//
-- Abstract : This module has following logic:        
--            1. Generates the token as per xct_rate and burstiness.
------------------------------------------------------------------------
*/
`include "miet_dw_axi_ic_DW_axi_all_includes.vh"

module miet_dw_axi_ic_DW_axi_qos_token_generator (

aclk_i                               ,
aresetn_i                            ,

reg_regulation_enable_i              ,
reg_xct_rate_i                       ,
reg_burstiness_i                     ,
reg_slv_rdy_i                        ,

req_i                                ,
slave_ready_i                        ,
grant_i                              ,
req_wire_i                           ,

next_token_o                         ,
slv_granted_pulse_o                  ,
valid_token_o                        ,
regulation_enabled_o
);

//------------------------------------------------------------------------------
// Parameters
//------------------------------------------------------------------------------
parameter NC = 4;
parameter PL_ARB = 0;

//------------------------------------------------------------------------------
// Input and Output signals.
//------------------------------------------------------------------------------
input                                    aclk_i                          ;
input                                    aresetn_i                       ;

input                                    reg_regulation_enable_i         ;
input    [`miet_dw_axi_ic_REG_XCT_RATE_W-1:0]           reg_xct_rate_i                  ;
input    [`miet_dw_axi_ic_REG_BURSTINESS_W-1:0]         reg_burstiness_i                ;
input                                    reg_slv_rdy_i                   ;

input    [NC-1:0]                        req_i                           ;
input    [NC-1:0]                        slave_ready_i                   ;
input                                    grant_i                         ;
input                                    req_wire_i                      ;

output                                   next_token_o                    ;
output                                   slv_granted_pulse_o             ;
output                                   valid_token_o                   ;
output                                   regulation_enabled_o            ;

//------------------------------------------------------------------------------
// Internal signals.
//------------------------------------------------------------------------------
// Based on the slave visibility to the master, the bits of signals are unused in the top level file 
reg                              reg_regulation_enable_r    ;
                 // registered reg_regulation_enable_i
wire                             slv_trgt_rdy               ;
                 // slave_ready targeted by req_i
wire   [`miet_dw_axi_ic_REG_XCT_RATE_W:0]       xct_rate_cnt               ;
                 // xct_rate_cnt counter  
wire                             any_slv_rdy                ;
                 // slave_ready from any of the slaves connected
wire                             slv_rdy                    ;
                 // slv_rdy used for the logic  
wire                             token_inc                  ;
                 // token incrementer  
reg   [`miet_dw_axi_ic_REG_XCT_RATE_W:0]        xct_rate_cnt_r             ;
                 // registered xct_rate_cnt  
reg   [`miet_dw_axi_ic_REG_BURSTINESS_W:0]      token_cnt                  ;
                 // token counter 
wire                             token_bucket_full          ;
                 // token bucket full signal 
wire                             slv_granted                ;
                 // requested slave is granted  
wire                             burstiness_dec             ;
                 // burstiness value decremented from previous programmed.
wire                             regulation_enabled_pulse   ;
                 // pulse for regulation_enabled signal
reg                              regulation_enabled_pulse_r ;
                 // registered regulation_enabled
reg                              valid_token_o              ;
wire                             next_token_o               ;

//------------------------------------------------------------------------------
// The grant_i is asserted whenever any request from the master port is granted
// by the arbiter.
//------------------------------------------------------------------------------
assign slv_granted = grant_i;

//------------------------------------------------------------------------------
// In case there is any request asserted by the master port, the particular
// slave_ready should be asserted if token generation need to be continued for
// reg_slv_rdy_i=1 scenario.
//------------------------------------------------------------------------------
assign slv_trgt_rdy = |(slave_ready_i & req_i);

//------------------------------------------------------------------------------
// In case there is no request asserted by the master port, all slave_ready
// should be asserted if token generation need to be continued for
// reg_slv_rdy_i=1 scenario.
//------------------------------------------------------------------------------
assign any_slv_rdy = |slave_ready_i;

//------------------------------------------------------------------------------
// Final slv_rdy for token generation logic using request input.
//------------------------------------------------------------------------------
assign slv_rdy = |req_i ? slv_trgt_rdy : any_slv_rdy;

//------------------------------------------------------------------------------
// A token need to be incremented in case xct_rate_cnt MSB becomes 1. It is 
// indicated by token_inc.
//------------------------------------------------------------------------------
assign token_inc = xct_rate_cnt[`miet_dw_axi_ic_REG_XCT_RATE_W];

//------------------------------------------------------------------------------
// Flopped signals.
//------------------------------------------------------------------------------
always @ (posedge aclk_i or negedge aresetn_i)
begin: REG_PROC
   if (~aresetn_i)
   begin
      xct_rate_cnt_r <= {(`miet_dw_axi_ic_REG_XCT_RATE_W+1){1'b0}};
      reg_regulation_enable_r <= 1'b0;
      regulation_enabled_pulse_r <= 1'b0;
   end
   else
   begin
      xct_rate_cnt_r <= xct_rate_cnt;
      reg_regulation_enable_r <= reg_regulation_enable_i;
      regulation_enabled_pulse_r <= regulation_enabled_pulse;
   end
end

//------------------------------------------------------------------------------
// Slave grant as output for peak_rate generation logic.
//------------------------------------------------------------------------------
assign slv_granted_pulse_o = slv_granted;

//------------------------------------------------------------------------------
// The xct_rate_cnt is dependent on:
// 1. reg_regulation_enable_i:
//    1. if 1, reg_slv_rdy_i:
//       1. if 1, either slv_rdy should be asserted or no token in
//          the token bucket:
//             the xct_rate_cnt keeps incrementing with every clock till either
//             slv_rdy asserts or at least one token is there in token_bucket.
//             The token generation stops later on and wait for slv_rdy.
//       2. if 0, token generation should not be stopped in any case and should
//          keep incrementing with every clock.
//    2. if 0, xct_rate_cnt is reset to 0 as regulation is disabled.  
//------------------------------------------------------------------------------

// spyglass disable_block W164b
// SMD: Identifies assignments in which the LHS width is greater than the RHS width
// SJ : This is not a functional issue, this is as per the requirement.
//      Hence this can be waived.  
assign xct_rate_cnt = reg_regulation_enable_i ? 
                         reg_slv_rdy_i ? 
                            (slv_rdy || (!valid_token_o)) ? 
                               (xct_rate_cnt_r[`miet_dw_axi_ic_REG_XCT_RATE_W-1:0] + 
                                reg_xct_rate_i) : 
                                {1'b0,xct_rate_cnt_r[`miet_dw_axi_ic_REG_XCT_RATE_W-1:0]} :
                            (xct_rate_cnt_r[`miet_dw_axi_ic_REG_XCT_RATE_W-1:0] + 
                            reg_xct_rate_i) :
                         {(`miet_dw_axi_ic_REG_XCT_RATE_W+1){1'b0}};
// spyglass enable_block W164b
                       
//------------------------------------------------------------------------------
// regulation enable can be asserted asynchronously so need to generate
// synchronous pulse to take care of it.
//------------------------------------------------------------------------------
assign regulation_enabled_o = reg_regulation_enable_i && (!reg_regulation_enable_r);

//------------------------------------------------------------------------------
// Exception: The regulation is enabled recently and a req_o is sent to the 
// arbiter for which grant has not been received. The req_o need to be asserted
// independent of token_cnt status till the request is granted.
//------------------------------------------------------------------------------
assign regulation_enabled_pulse = (regulation_enabled_o && req_wire_i && 
                                   (!slv_granted)) ? 1'b1 : 
                                    slv_granted ? 1'b0 : 
                                     regulation_enabled_pulse_r;
//------------------------------------------------------------------------------
// In case burstiness value changes and new value is less than the previous one
// the token bucket need to changed as per new value if it is more than the new
// limit.
//------------------------------------------------------------------------------
// spyglass disable_block SelfDeterminedExpr-ML
// SMD: Self determined expression present in the design.
// SJ: This violation can be ignored here.
assign burstiness_dec = (token_cnt > (reg_burstiness_i  + (1'b1)));


//------------------------------------------------------------------------------
// New generated tokens should be discarded in case token_bucket is full.
//------------------------------------------------------------------------------
assign token_bucket_full = (token_cnt >= (reg_burstiness_i+ 1'b1));
// spyglass enable_block SelfDeterminedExpr-ML

//------------------------------------------------------------------------------
// Token_cnt is changed as per following logic:
// 1. Tied to 1 in case regualtion is disabled or xct_rate is set to 0.
// 2. Burstiness value is decremented and token_cnt is more than that. The 
//    token_cnt should be set to new burstiness value + 1.
// 3. Token_inc asserted and token bucket is not full, token_cnt should be 
//    incremented by 1. The token_cnt should not be changed if there is
//    token_inc and slv_granted in the same clock cycle.
// 4. Slave is granted and no token_inc, token_cnt should be decremented by 1.
// 5. Exception if req_is asserted and didn't receive the grant but 
//    regulation_enables, the token_cnt kept to 1 till reqs get granted.
// 6. regulation is enabled recently and no request pending, the token_cnt
//    should reset to 0.
//
// valid_token_o is asserted in case token_cnt is more than 1.
//------------------------------------------------------------------------------
always @ (posedge aclk_i or negedge aresetn_i)
begin: token_cnt_PROC
   if (~aresetn_i)   
   begin
           token_cnt <= {(`miet_dw_axi_ic_REG_BURSTINESS_W+1){1'b0}};
           valid_token_o <= 1'b0;
   end
   else if (!reg_regulation_enable_i || 
           (reg_xct_rate_i == {`miet_dw_axi_ic_REG_XCT_RATE_W{1'b0}}) ||
            regulation_enabled_pulse)
   begin
           token_cnt <=  {{(`miet_dw_axi_ic_REG_BURSTINESS_W){1'b0}},1'b1};
           valid_token_o <= 1'b1;
   end
   else if (burstiness_dec)  
   begin
           token_cnt <= (reg_burstiness_i +( 1'b1));
           valid_token_o <= 1'b1;
   end
   else if (token_inc && (!slv_granted) && (!token_bucket_full)) 
   begin
           token_cnt <=  (token_cnt + ( 1'b1));
           valid_token_o <= 1'b1;
   end
   else if (!token_inc && slv_granted) 
   begin
           token_cnt <= (token_cnt - ( 1'b1));
           if (token_cnt == {{(`miet_dw_axi_ic_REG_BURSTINESS_W){1'b0}},1'b1})
           valid_token_o <= 1'b0;
   end
   else if (regulation_enabled_o) 
   begin
           token_cnt <= {(`miet_dw_axi_ic_REG_BURSTINESS_W+1){1'b0}};
           valid_token_o <= 1'b0;
   end
end

assign next_token_o = ((token_cnt > {{(`miet_dw_axi_ic_REG_BURSTINESS_W){1'b0}},1'b1}) || token_inc);

endmodule
