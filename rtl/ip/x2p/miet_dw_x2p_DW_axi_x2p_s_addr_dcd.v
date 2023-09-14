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
// File Version     :        $Revision: #12 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2p/amba_dev/src/DW_axi_x2p_s_addr_dcd.v#12 $ 
*/
//-----------------------------------------------------------------------------
//
//
//
// Filename    : DW_axi_x2ps_addr_dcd.v
// 
// Description : APB Address  generation and range checking for DW_axi_x2p bridge.
//-----------------------------------------------------------------------------

`include "miet_dw_x2p_DW_axi_x2p_all_includes.vh"

module miet_dw_x2p_DW_axi_x2p_s_addr_dcd (/*AUTOARG*/
  // Outputs
  dcd_error, 
                              paddr, 
                              psel, 
                              // Inputs
                              clk, 
                              rstn, 
                              cmd_addr, 
                              cmd_type, 
                              cmd_size, 
                              cmd_len, 
                              cmd_direction, 
                              incr_addr, 
                              incr_base_addr, 
                              set_addr, 
                              update_address
                              );

   input                              clk;
   input                              rstn;

// Interface to Common CMD Queue - the address field

   input [`X2P_CMD_ADDR_WIDTH-1:0] cmd_addr;   // starting address of corrent transaction
   input [1:0]                     cmd_type; // INCR,FIXED,WRAP
   input [2:0]                     cmd_size;
   input [`LEN_WIDTH-1:0]          cmd_len;
   input                           cmd_direction;
   
   input                           incr_addr;
   input                           incr_base_addr;
   input                           set_addr;
  
   
   input                           update_address;
   
   output                             dcd_error;
   output [`X2P_APB_ADDR_WIDTH-1:0]   paddr;
   output [`X2P_NUM_APB_SLAVES-1:0]   psel;     //results of the address decoder. 
 
   reg [`X2P_APB_ADDR_WIDTH-1:0]   paddr;
   wire [`X2P_APB_ADDR_WIDTH-1:0]  next_paddr; 
  
   
  reg [`X2P_NUM_APB_SLAVES-1:0]                       psel;   
  wire [`X2P_NUM_APB_SLAVES-1:0]                      next_psel,raw_psel;   
   

   wire  [`X2P_CMD_ADDR_WIDTH-1:0] cmd_addr;
   reg [`X2P_CMD_ADDR_WIDTH-1:0]   next_address, address_temp, address,
                                   next_address_from_set, next_base_address_from_set, 
                                   next_address_from_incr_base, next_base_address_from_incr_base,
                                   next_address_from_incr, next_base_address_from_incr,  
                                   base_addr, next_base_addr,addr_lsb_mask;
                                                          
   wire [1:0]                      cmd_type;
   wire [2:0]                      cmd_size;
   wire [`LEN_WIDTH-1:0]           cmd_len;
   wire                            dcd_error;
 // being explict in setting the priorites for next address generation;
   
   wire                            set_address = set_addr;
   wire                            incr_base_address = (!set_addr & incr_base_addr);
   wire                            incr_address = incr_addr & (!(set_addr | incr_base_addr));
   wire                            next_decode_error;
   
parameter AXI_MOD = ((`X2P_AXI_DW > 256) ? 6 :((`X2P_AXI_DW > 128) ? 5 : ((`X2P_AXI_DW > 64) ? 4 : ((`X2P_AXI_DW > 32) ? 3 :((`X2P_AXI_DW > 16) ? 2 : 1)))));
   
     /* AUTO_CONSTANT (`APB_ADD_INC,`APB_IND, `X2P_CMD_ADDR_WIDTH, `AXI_MOD `X2P_APB_SIZE) */

parameter [8:0]                    APB_ADD_INC = 9'd1 << `X2P_APB_SIZE;
   
   
   reg [7:0]                       base_addr_inc;

   reg                             wrap_error;    // given when wrap len is not a power of 2
   

   
 /* AUTO_CONSTANT (`X2P_AXI_BLW) */
 // incriment the base address by the AXI beat size
 always @(/*AS*/cmd_size 
     or cmd_direction
     )
   begin: BASE_ADDR_INC_PROC
      base_addr_inc = 8'h01;

      // Intended to Shift by non-constant
   //spyglass disable_block W415a
   //SMD: Signal may be multiply assigned(beside initialization) in the same scope.
   //SJ : We are initializing base_addr_inc signal before assigning to avoid latches.
      base_addr_inc = (cmd_direction==1'b0)? (base_addr_inc << ((cmd_size < `APB_BUS_SIZE) ? `APB_BUS_SIZE : cmd_size)) : (base_addr_inc << cmd_size);
  //spyglass enable_block W415a
   end
// used in WRAP to mask the wrap address
   always @(/*AS*/cmd_len or cmd_size or cmd_type)
     begin: ADDR_LSB_MASK_PROC
       addr_lsb_mask = {`X2P_CMD_ADDR_WIDTH{1'b1}};//-1;
       wrap_error    = 1'b0;

        if (cmd_type == 2)
          begin
  //spyglass disable_block W415a
  //SMD: Signal may be multiply assigned(beside initialization) in the same scope.
  //SJ : We are masking the bits of addr_lsb_mask based on cmd_len value before  multiply the beats  by the size to get the total bytes in the transfer.
            // to do wrap set up the mask for the address
            // set to the number of beats.
     
     
     
     
            case(cmd_len)      
              1      : addr_lsb_mask[0]   = 1'b0;
              3      : addr_lsb_mask[1:0] = 2'b0;
              7      : addr_lsb_mask[2:0] = 3'b0;
              15     : addr_lsb_mask[3:0] = 4'b0;
              31     : addr_lsb_mask[4:0] = 5'b0;
              63     : addr_lsb_mask[5:0] = 6'b0;
              127    : addr_lsb_mask[6:0] = 7'b0;
              255    : addr_lsb_mask[7:0] = 8'b0;
              default:
                begin
                  wrap_error         = 1'b1;
                  addr_lsb_mask      = {`X2P_CMD_ADDR_WIDTH{1'b0}};
               end     
            endcase // case(cmd_len)
     
            // multiply the beats  by the size this will get the total bytes in the transfer
            // and the locs for the wrapping address 
            addr_lsb_mask = addr_lsb_mask << cmd_size;
    // spyglass enable_block W415a
          end // if (cmd_type == 2)
     end // always @ (...
   
       
   //********************************************************************************
   //
   //  Addresss generation
   //  Overriding in the following order
   //  if set_addr 
   //     comes when the cmd queue is popped and in Fixed types when the
   //     last apb transfer for the AXI word
   //  else if incr_base_addr
   //      on the last apb word transfer of the AXI word
   //      The base_addr is the calculation of the address by SIZE incrs.
   //      the next_address sent o the APB is the base address incrimented by the APB
   //  else if incr_addr
   //      comes with each apb transfer
   //         
   //  
   //
   
   // the address generated on set address
   // at this time the write buff is being popped
   always @(*)
     begin: NEXT_ADDR_SET_PROC
       next_base_address_from_set = cmd_addr; 
       // the base is the cmd_add address
       // indicatating the first beat address
       if (cmd_direction == 1'b1)
         begin
           // the address will be the base aligned to the AXI data 
           // width displaced by the first write strobe
           next_address_from_set = {cmd_addr[`X2P_CMD_ADDR_WIDTH-1:AXI_MOD], {AXI_MOD{1'b0}}};
         end
       else
         begin
           // read base is set to the cmd address
           next_address_from_set = cmd_addr;
        end // else: !if(cmd_direction == 1'b1)
     end // always @ (...

    // spyglass disable_block STARC-2.10.6.1
    // SMD: Possible loss of carry or borrow in addition or subtraction (Verilog)
    // SJ: Overflow will never happen functionally. RTL was written with a particular
    // function in mind so any concerns regarding loss of carry/borrow in addition/subtraction
    // can be ignored by spyglass.
    // spyglass disable_block W484
    // SMD: Possible loss of carry or borrow due to addition and subtraction.
    // SJ : Overflow will never happen functionally. RTL was written with a particular
    // function in mind so any concerns regarding loss of carry/borrow in addition/subtraction
    // can be ignored by spyglass.
    // the incrementing of the base is done when the write buffer
    // is being popped     
    // spyglass disable_block W164a
    // SMD: Possible loss of carry or borrow due to addition and subtraction.
    // SJ : Overflow will never happen functionally. RTL was written with a particular
    // function in mind so any concerns regarding loss of carry/borrow in addition/subtraction
    // can be ignored by spyglass.
    always @(*)
      begin: NEXT_ADDR_INCR_BASE_PROC
        next_address_from_incr_base = address;
        next_base_address_from_incr_base = base_addr;
        address_temp = {`X2P_CMD_ADDR_WIDTH{1'b0}}; 
        // a new beat from the AXI, calculate the address for the AXI beat
        // incriment the base to the next beat AXI address
        case (cmd_type)
          0: begin // Fixed
            next_base_address_from_incr_base = cmd_addr;
            next_address_from_incr_base = {`X2P_CMD_ADDR_WIDTH{1'b0}};
            if (cmd_direction == 1'b1)
              begin
                next_address_from_incr_base = {cmd_addr[`X2P_CMD_ADDR_WIDTH-1:AXI_MOD], {AXI_MOD{1'b0}}};
              end
            else 
              next_address_from_incr_base = cmd_addr;
          end
          1: begin
            // the next address is set to the AXI word boundary
            next_base_address_from_incr_base = base_addr + {{(`X2P_CMD_ADDR_WIDTH-8){1'b0}}, base_addr_inc};    
            // the wite strobes will indicate the displacement
            if (cmd_direction == 1'b1) 
              begin
                next_address_from_incr_base = {next_base_address_from_incr_base[`X2P_CMD_ADDR_WIDTH-1:AXI_MOD], {AXI_MOD{1'b0}}};
              end
            // read is just a increment of paddr b APB word
            else 
              next_address_from_incr_base = address + {{(`X2P_CMD_ADDR_WIDTH-9){1'b0}}, APB_ADD_INC};
          end // case: 1
          2: begin // WRAP     
          // the incrimented base address is wrapped base on 
          // incrementing the SIZE address bit
          
          address_temp = base_addr + {{(`X2P_CMD_ADDR_WIDTH-8){1'b0}}, base_addr_inc};
          // now restore the address outside the wrap making this wrap on the SIZE * LEN bits
          next_base_address_from_incr_base = base_addr & addr_lsb_mask;
          // spyglass disable_block W415a
          // SMD: Signal may be multiply assigned (beside initialization) in the same scope.
          // SJ : next_base_address_from_incr_base is updated to restore the address outside the wrap making this wrap on the SIZE * LEN bits.
          next_base_address_from_incr_base = next_base_address_from_incr_base 
                                          | (address_temp & (~addr_lsb_mask));    
          // spyglass enable_block W415a
          // the wite strobes will indicate the displacement
          if (cmd_direction == 1'b1)
            begin
              next_address_from_incr_base = {next_base_address_from_incr_base[`X2P_CMD_ADDR_WIDTH-1:AXI_MOD], {AXI_MOD{1'b0}}};
            end
          // read is just a increment of paddr 
          else 
            next_address_from_incr_base = next_base_address_from_incr_base;
          end // case: 2
          default: begin // all the others are considered to be INCR     
            next_base_address_from_incr_base = base_addr + {{(`X2P_CMD_ADDR_WIDTH-8){1'b0}}, base_addr_inc};
          end
        endcase // case(cmd_type)
      end // always @ (...\
    // spyglass enable_block W164a
    // spyglass enable_block W484
    // spyglass enable_block STARC-2.10.6.1

   // the incr address is used to just incriment the address by the apb word
   always @(*)
     begin:NEXT_ADDR_INCR_PROC
       next_base_address_from_incr = base_addr;
       next_address_from_incr = address + {{(`X2P_CMD_ADDR_WIDTH-9){1'b0}}, APB_ADD_INC};
     end

   // now select which one to send to address
   // spyglass disable_block W415a
   // SMD: Signal may be multiply assigned (beside initialization) in the same scope.
   // SJ : next_address and next_base_addr are updated based on mutually dependent conditions with highest priority given to incr_address in the same always block.
   always @(/*AS*/address or base_addr or incr_address
            or incr_base_address or next_address_from_incr
            or next_address_from_incr_base or next_address_from_set
            or next_base_address_from_incr
            or next_base_address_from_incr_base
            or next_base_address_from_set or set_address)
     begin: NEXT_ADDR_PROC
       // the following sets up the priority of choices
       // above I set it such that only one of the signals could be activ
       next_address = address;
       next_base_addr = base_addr;
       if ({set_address,incr_base_address,incr_address} == 3'b0)
         begin
           next_address = address;
           next_base_addr = base_addr;
         end
       if (set_address == 1'b1)
         begin
           next_address = next_address_from_set;
           next_base_addr = next_base_address_from_set;
         end
       if (incr_base_address == 1'b1)
         begin
           next_address = next_address_from_incr_base;
           next_base_addr = next_base_address_from_incr_base;
         end
       if (incr_address == 1'b1)
         begin
           next_address = next_address_from_incr;
           next_base_addr = next_base_address_from_incr;
         end
     end // always @ (...
     // spyglass enable_block W415a
 
   // get the psels from the address decoder
   miet_dw_x2p_DW_axi_x2p_dcdr
    U_apb_psel(.psel_addr({address[`X2P_CMD_ADDR_WIDTH-1:10]}),
                              .psel_err(next_decode_error),
                              .psel_int(raw_psel));
   assign dcd_error = next_decode_error | wrap_error;

   assign next_paddr = (update_address == 1'b1) ? next_address[`X2P_APB_ADDR_WIDTH-1:0] : paddr;
   assign next_psel = (update_address == 1'b1) ? raw_psel : psel;
 
  
   // now the register
   always @(posedge clk or negedge rstn)
     begin: S_REGS_PROC
       if (!rstn)
         begin
           base_addr <= {`X2P_CMD_ADDR_WIDTH{1'b0}};
           paddr <= {`X2P_APB_ADDR_WIDTH{1'b0}};
           psel <= {`X2P_NUM_APB_SLAVES{1'b0}};
           address <= {`X2P_CMD_ADDR_WIDTH{1'b0}};
         end
       else
         begin
           base_addr <= next_base_addr;
           paddr <= next_paddr;
           psel <= next_psel;
           address <= next_address;
         end // else: !if(!rstn)
     end // always @ (posedge clk or negedge rstn)

endmodule // DW_axi_x2ps_addr_dcd
























