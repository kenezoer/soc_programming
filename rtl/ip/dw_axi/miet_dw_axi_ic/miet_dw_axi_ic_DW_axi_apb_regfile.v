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
// File Version     :        $Revision: #8 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi/amba_dev/src/DW_axi_apb_regfile.v#8 $ 
**
** ---------------------------------------------------------------------
**
** File     : DW_axi_apb_regfile.v
//
//
** Created  : Thu Nov 17 13:27:47 MEST 2011
** Modified : $Date: 2020/03/22 $
** Abstract : apb register file
** ---------------------------------------------------------------------
*/

`include "miet_dw_axi_ic_DW_axi_all_includes.vh"
// APB module specific constant//
`define miet_dw_axi_ic_REG_VID             4'h0
`define miet_dw_axi_ic_REG_HWC             4'h4
`define miet_dw_axi_ic_REG_CMD             4'h8
`define miet_dw_axi_ic_REG_DATA            4'hC
`define miet_dw_axi_ic_COMMAND_EN_BIT      31
`define miet_dw_axi_ic_WR_BIT              30
`define miet_dw_axi_ic_SR_BIT              29
`define miet_dw_axi_ic_MID_BIT_MSB         11
`define miet_dw_axi_ic_CH_ID_BIT           7
`define miet_dw_axi_ic_QOS_REG_OFFSET      3 

module miet_dw_axi_ic_DW_axi_apb_regfile (
     pclk,
     presetn,
     wr_en,
     rd_en,
     byte_en,
     reg_addr,
     ipwdata,
     iprdata,
     err_bit,
     data_reg_in,
     data_reg_out,
     qosreg_wr_en,
     qosreg_rd_en,
     qosreg_offset,
     internal_reg_rst,
     command_en,
     command_en_ack
     );

   //----------------------------------------------------
   //---Port declaraion-----------------
   //------------------------------------------------------
     input                              pclk;           //apb clock    
     input                              presetn;        //apb reset
     input                              wr_en;          //write en ,generated from Bus Interface Module
     input                              rd_en;          //read enable, generated from Bus Interface Module      
     input  [3:0]                       byte_en;        //Byte enable,
     input  [`miet_dw_axi_ic_IC_ADDR_SLICE_LHS-2:0]    reg_addr;       //APB register offset
     input  [`miet_dw_axi_ic_MAX_APB_DATA_WIDTH-1:0]   ipwdata;        //Write data from APB BIU 
     output [`miet_dw_axi_ic_MAX_APB_DATA_WIDTH-1:0]   iprdata;        //Internal read data bus
     input                              err_bit;        //Error bit signal genrated from qos command decoder logic
     input  [31:0]                      data_reg_in;    //qos data register input
     output [31:0]                      data_reg_out;   //qos data register output
     output                             qosreg_wr_en;   //qos register write en
     output                             qosreg_rd_en;   //qos register read en
     output [7:0]                       qosreg_offset;  //qos register offset
     output                             internal_reg_rst;     //APB soft reset
     output                             command_en;     //command enable output to aclk domain
     input                              command_en_ack; //command enable acknowledgement from aclk domain

   // ----------------------------------------------------------
   // -- local registers and wires
   // ----------------------------------------------------------
   //
   wire                                 apb_reg_vid_en;
   wire                                 apb_reg_hwconfig_en;
   wire                                 apb_reg_cmd_en;
   wire                                 apb_reg_data_en;

   // spyglass disable_block W497
   // SMD: Not all bits of the bus are set
   // SJ : The bits which are not set are never used in the design.
   reg     [31:0]                       cmd_reg;
   // spyglass enable_block W497
   wire    [6:0]                        cmd_dec ;
   reg     [31:0]                       data_reg;
   wire    [7:0]                        qos_reg_offset;
   reg     [31:0]                       data_reg_out;
   wire    [31:0]                       vid_reg;
   wire    [31:0]                       hwc_reg;
   wire                                 command_en;
   wire                                 internal_reg_rst;
   wire                                 internal_rst ;
   wire                                 qosreg_wr_en; //qos register write en
   wire                                 qosreg_rd_en; //qos register read en
   reg     [31:0]                       iprdata;

   wire                                 apb3bit;
   wire                                 axi4bit;
   wire                                 qosbit;
   wire                                 lockenbit;
   wire                                 tzenbit  ;
   wire                                 extdecbit;
   wire                                 remapenbit;
   wire                                 bicmdenbit;
   wire                                 lpenbit ;  
   wire    [4:0]                        mst_num ;
   wire   [4:0]                         slv_num  ;

  //Local Parameters
  localparam [31:0] VID_REG         = `miet_dw_axi_ic_DW_AXI_VERSION_ID; //  version id of corekit , driven by coreConsultant param
  localparam        APB3BIT         = `miet_dw_axi_ic_AXI_HAS_APB3;
  localparam        QOSBIT          = `miet_dw_axi_ic_AXI_HAS_QOS;
  localparam        LOCKENBIT       = `miet_dw_axi_ic_AXI_HAS_LOCKING;
  localparam        TZENBIT         = `miet_dw_axi_ic_AXI_HAS_TZ_SUPPORT;
  localparam        EXTDECBIT       = `miet_dw_axi_ic_AXI_HAS_XDCDR;
  localparam        REMAPENBIT      = `miet_dw_axi_ic_AXI_REMAP_EN;
  localparam        BICMDENBIT      = `miet_dw_axi_ic_AXI_HAS_BICMD;
  localparam  [0:0] AXI_HAS_AXI4    = (`miet_dw_axi_ic_AXI_INTERFACE_TYPE == 0) ? 0 : 1;
  localparam        LPENBIT         = `miet_dw_axi_ic_AXI_LOWPWR_HS_IF; 
  localparam  [4:0] MST_NUM         = `miet_dw_axi_ic_AXI_NUM_MASTERS;
  localparam  [4:0] SLV_NUM         = `miet_dw_axi_ic_AXI_NUM_SLAVES;


  // ------------------------------------------------------
   // -- Address decoder
   //
   //  Decodes the register address offset input(reg_addr)
   //  to produce enable (select) signals for each of the
   //  SW-registers 
   // ------------------------------------------------------
   assign apb_reg_vid_en       = (reg_addr == (`miet_dw_axi_ic_REG_VID >> 2));
   assign apb_reg_hwconfig_en  = (reg_addr == (`miet_dw_axi_ic_REG_HWC >> 2));
   assign apb_reg_cmd_en       = (reg_addr == (`miet_dw_axi_ic_REG_CMD >> 2));
   assign apb_reg_data_en      = (reg_addr == (`miet_dw_axi_ic_REG_DATA >> 2));

   //spyglass disable_block FlopEConst
   //SMD: Enable pin EN on Flop is  always enabled (tied high)
   //SJ: This warning can be ignored
   //-----------------------------------------------------
   //apbwr_cmdreg_write module implement command regiter write operation
   //on APB interface.
   //reserved bits of command register are not assigned by ipwdata( flip
   //flop saving)
   //Command enable bit and soft reset bits are auto cleared on
   //acknowledgement
   //-------------------------------------------------------
   always @(posedge pclk or negedge presetn) begin : APBWR_CMDREG_WRITE_PROC
        if(presetn == 1'b0) 
            {cmd_reg[31:29],cmd_reg[11:7], cmd_reg[2:0]} <= 11'b0;  // reserved bits of command_reg 
        else if (internal_rst == 1'b1)  // soft reset
            {cmd_reg[31:29],cmd_reg[11:7], cmd_reg[2:0]} <= 11'b0;
        else if ((apb_reg_cmd_en == 1 && wr_en ==1 && command_en ==0)) //register write is not allowed when command_en is high
            begin       
            case(byte_en)
             4'b0001 : {cmd_reg[7],cmd_reg[2:0]}   <= {ipwdata[7],ipwdata[2:0]};  // 8 bit apb write
             4'b0010 :  cmd_reg[11:8]              <= ipwdata[11:8]; // 8 bit apb write
             4'b1000 :  cmd_reg[31:29]             <= ipwdata[31:29];// 8 bit apb write 
             4'b0011 : {cmd_reg[11:7],cmd_reg[2:0]}  
                                                   <= {ipwdata[11:7],ipwdata[2:0]}; // 16 bit apb write
             4'b1100 :  cmd_reg[31:29]             <= ipwdata[31:29];// 16 bit apb write
             default : {cmd_reg[31:29],cmd_reg[11:7],cmd_reg[2:0]}  
                                                   <= {ipwdata[31:29],ipwdata[11:7],ipwdata[2:0]}; // 32 bit apb write
             endcase
            end
       else 
            {cmd_reg[31],cmd_reg[29]}              <= {(cmd_reg[31] & ((~command_en_ack) | (cmd_reg[`miet_dw_axi_ic_SR_BIT] & (~internal_rst)))), 
                                                       (cmd_reg[31] & (~command_en_ack) & cmd_reg[`miet_dw_axi_ic_SR_BIT])}; //Auto clearing of cmd_reg bits  
  end //apb_cmdreg_write
   //spyglass enable_block FlopEConst

                
  //-----------------------------------------------------
   //apbwr_cmdreg_write module implement data register write operation
   //on APB interface.
  //----------------------------------------------------

  always @(posedge pclk or negedge presetn) begin : APBWR_DATAREG_WRITE_PROC
        if (presetn == 1'b0) 
            data_reg_out <= 32'b0;
        else if (internal_rst == 1'b1)  //soft reset
            data_reg_out <= 32'b0; 
        else if ((apb_reg_data_en == 1 && wr_en ==1 && command_en ==0)) begin //Data reg register is not allowed when command_en bit is low.
            case(byte_en)
             4'b0001 : data_reg_out[7:0]   <= ipwdata[7:0];  // 8 bit apb write
             4'b0010 : data_reg_out[15:8]  <= ipwdata[15:8]; // 8 bit apb write
             4'b0100 : data_reg_out[23:16] <= ipwdata[23:16];// 8 bit apb write
             4'b1000 : data_reg_out[31:24] <= ipwdata[31:24];// 8 bit apb write 
             4'b0011 : data_reg_out[15:0]  <= ipwdata[15:0]; // 16 bit apb write
             4'b1100 : data_reg_out[31:16] <= ipwdata[31:16];// 16 bit apb write
             default : data_reg_out[31:0]  <= ipwdata[31:0]; // 32 bit apb write
            endcase
           end
        else if (qosreg_rd_en == 1'b1 )
                data_reg_out <= data_reg_in; // data_reg content can be changed qos read command excution or by apb
                                             // write on data regiter.
                                             // Both of the above can take place in any order, 
   end //apb_data_reg_write
  

   


    
    //apb registers read
    always @(*)       begin : APB_REG_READ_PROC
        if (rd_en ==1'b1) begin
        case (1'b1) 
            apb_reg_vid_en     : iprdata   = vid_reg;
            apb_reg_hwconfig_en: iprdata   = hwc_reg;
            apb_reg_cmd_en     : iprdata   = {(cmd_reg[31] | command_en_ack),cmd_reg[30:29],err_bit, 16'b0, cmd_reg[11:7], 4'b0 ,cmd_reg[2:0]};
            apb_reg_data_en    : iprdata   = data_reg_out;
            default            : iprdata = 32'b0;
        endcase 
        end
        else   iprdata = 32'b0;
    end


    
 
     assign vid_reg         = VID_REG  ;  
     assign apb3bit         = APB3BIT   ;
     assign axi4bit         = AXI_HAS_AXI4;
     assign qosbit          = QOSBIT    ;
     assign lockenbit       = LOCKENBIT ;
     assign tzenbit         = TZENBIT   ;
     assign extdecbit       = EXTDECBIT ;
     assign remapenbit      = REMAPENBIT;
     assign bicmdenbit      = BICMDENBIT;
     assign lpenbit         = LPENBIT   ;
     assign mst_num         = MST_NUM   ;
     assign slv_num         = SLV_NUM   ;
 

     
     assign hwc_reg = {7'b0,
                       slv_num,
             3'b0,
                       mst_num, 
                       3'b0,
                       lpenbit,
                       bicmdenbit,
                       remapenbit,
                       extdecbit,
                       tzenbit,
                       lockenbit,   
                       axi4bit ,
                       apb3bit,
                       qosbit} ;// hardware configuration register

     assign command_en       =   cmd_reg[`miet_dw_axi_ic_COMMAND_EN_BIT]; 
            // command_en will be asserted high as and when command regiter bit index COMMAND_EN_BIT is set high. 
            // It will be high till the handshake acknowledgement from aclk-->pclk-->aclk-->pclk is not recieved.
     
     assign internal_rst =   command_en_ack & cmd_reg[`miet_dw_axi_ic_SR_BIT];
     assign internal_reg_rst =   cmd_reg[`miet_dw_axi_ic_SR_BIT];
            // internal soft reset genration. 
            // internal_rst will be asserted high as and when command regiter bit  index SR_BIT is set high and command completeion acknowledgement.
            // It will be  high when acknowledgement is recieved.
    
     assign qosreg_wr_en      =   cmd_reg[`miet_dw_axi_ic_WR_BIT]  &  command_en ; 
            // write command for internal qos register
     
     assign qosreg_rd_en      =   (~cmd_reg[`miet_dw_axi_ic_WR_BIT])  & command_en ;
            // read command for internal qos register
     
     assign qosreg_offset   =   {cmd_reg[`miet_dw_axi_ic_MID_BIT_MSB],cmd_reg[`miet_dw_axi_ic_MID_BIT_MSB-1],cmd_reg[`miet_dw_axi_ic_MID_BIT_MSB-2] ,cmd_reg[`miet_dw_axi_ic_MID_BIT_MSB-3], cmd_reg[`miet_dw_axi_ic_CH_ID_BIT] ,cmd_reg[`miet_dw_axi_ic_QOS_REG_OFFSET-1:0] }; 
            //internal qos regiters offset


    endmodule
