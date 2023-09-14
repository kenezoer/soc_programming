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
// File Version     :        $Revision: #11 $ 
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2p/amba_dev/src/DW_axi_x2p_s_control.v#11 $ 
*/
///slowfs/in01dwt2p108/DW_ocb/user/pande/anushka_axi_dev_ga_ccx_client/DW_ocb/DW_axi_x2p/lib/sim_code_cov_cconfig_axi4_max_cov2_base_config_0/src/DW_axi_x2p_s_control
//


//-----------------------------------------------------------------------------
// Filename    : DW_axi_x2ps_control.v
// Created     : Dec 19 2005
// Description : APB Master Control
//               The APB state machines 
//               
//----------------------------------------------------------------------------

/*********************************************************************/
/*                                                                   */
/*                  X2P_APB control module                           */
/*                                                                   */
/*                                                                   */
/*********************************************************************/

`include "miet_dw_x2p_DW_axi_x2p_all_includes.vh"

module miet_dw_x2p_DW_axi_x2p_s_control(/*AUTOARG*/
  // Outputs
  push_read_buffer_n, 
                            rd_error, 
                            enable_pack, 
                            last_push_read, 
                            clr_rd_data_reg, 
                            penable, 
                            psel_en, 
                            pwrite, 
                            pop_write_buff_n, 
                            pop_cmd_queue_n, 
                            push_rsp_buff_n, 
                            error, 
                            incr_addr, 
                            set_addr, 
                            incr_base_addr, 
                            save_id, 
                            set_data, 
                            next_apb_wd_sel, 
                            update_address, 
                            // Inputs
                            clk, 
                            rstn, 
                            cmd_queue_wd, 
                            cmd_queue_empty, 
                            write_buffer_last, 
                            next_write_buff_empty, 
                            selected_strobes, 
                            dcd_error, 
                            read_buffer_full, 
                            pready, 
                            pslverr,
                            last_strobes, 
                            resp_rdy_n
                            );

   input clk;
   input rstn; 
  // these are used for the command queue
  //Not all the bits of this signal are used in this module. (For example the AXI-ID bits and the higher addr MSbits are unused).
  input [`X2P_CMD_QUEUE_WIDTH:0] cmd_queue_wd;
  input                          cmd_queue_empty;
 
  //the write buffer
  input                       write_buffer_last;  // include the WSTRB and LAST
  input                       next_write_buff_empty;

// coming from the  data unpacking module
// strobes set for current APB word to write 
// address decode error from the address generation
   input [(`X2P_APB_DATA_WIDTH/8)-1:0] selected_strobes; // strobes for current APB word to write 
// address decode error from the address generation
   input                      dcd_error;

   // interface to the read buffer
   input                      read_buffer_full;
   output                     push_read_buffer_n;
   reg                        push_read_buffer_n,push_read_buffer_reg;
  // When X2P is configured to single clock mode, the buffers are configured to pass through data without synchronization.
  // In this config the buffers can be configured to single entry deep. Waiving off the unused signals in this configuration.
   output                     rd_error;  
   
   // issues an update in the read buffer packer
   output                     enable_pack;
   output                     last_push_read;
   output                     clr_rd_data_reg;
      
 // from the APB
   input                      pready;
   input                      pslverr;

   // the index pointing to the firstf non-zero strobes
   // points to the first of the last  0'd APB strobes
   input [7:0]                last_strobes;
   
   
   // to the APB
   output                     penable;
   output                     psel_en;    // this will enable the slect
   output                     pwrite;
   

   // to pop the next write data word
   output                     pop_write_buff_n;
   // pop the cmd queue
   output                     pop_cmd_queue_n;
   // for pushing into the response buffer
   input                      resp_rdy_n;
   output                     push_rsp_buff_n;
   output                     error;
// to address generator to incriment address
   output                     incr_addr;   // incriment address
   output                     set_addr;    // set in th epopped address
   wire                       set_addr;
   output                     incr_base_addr; // incriments per AXI beat
   output                    save_id;  // time to save he cmd_id
   
   // indicates the data is to be set
   output                    set_data;
   
   // this will count the APB words
   output [7:0]              next_apb_wd_sel;
   output                    update_address;

   wire                       update_address;
   
   reg                        pwrite;
   reg                        pop_write_buff_n;
 
   reg [7:0]                  next_apb_wd_sel, apb_wd_sel;
   reg [7:0]                  next_apb_wd_sel_sparse, apb_wd_sel_sparse;
   reg                        psel_en;
  
   reg                        penable;
  
   
   reg [7:0]                  apb_wds_in_axi_wd, next_apb_wds_in_axi_wd; 
   reg [7:0]                  apb_wds_in_axi_wd_sparse, next_apb_wds_in_axi_wd_sparse; 

   wire  [`X2P_CMD_QUEUE_WIDTH:0] cmd_queue_wd;
   wire                       write_buffer_last; 

   // break up the command word
   wire       cmd_direction = cmd_queue_wd[0];
   wire [1:0] cmd_type = cmd_queue_wd[2:1];
   wire [2:0] cmd_size = cmd_queue_wd[5:3];
   
   wire [`LEN_WIDTH-1:0]      cmd_len = cmd_queue_wd[`LEN_WIDTH+5:6];
//   wire [`X2P_AXI_AW-1:0]       cmd_addr;
   wire [`APB_BUS_SIZE+7:0]   cmd_addr;
   
   wire                       wr_pop_cmd, save_id;
   reg                        rd_pop_cmd;
   
   reg                        next_error, error;
  
//   reg                        write_active, next_write_active;
   wire                       wr_incr_base_addr;
   reg                        pop_wr_buff_request,next_pop_wr_buff_request;
     
   wire                       any_error;
   reg                        next_rd_err;
   reg                        rd_error;    // becomes read response
   

   // last apb word of the axi read buffer
   reg                        next_apb_read_last, apb_read_last;
   reg                        next_apb_read_last_sparse, apb_read_last_sparse;
   reg                        last_push_read,next_last_push_read;
   wire                       next_push_read_buffer_n;
   
   // keeps count of the rmaning words to transfer in a read
   reg [`LEN_WIDTH-1:0]       apb_axi_beat, next_apb_axi_beat;


   reg                        write_buff_empty,write_buff_empty_ns;
   reg                        write_buffer_last_reg,next_write_buffer_last_reg;
   
   wire                       next_wr_set_addr,
                              rd_set_addr,rd_incr_base_addr;
   wire                       apb_finished;
   wire                       initial_cmd_error;
   wire                       wr_incr_addr,rd_incr_addr;
   
                               
  /* AUTO_CONSTANT (`APB_BUS_SIZE, `X2P_MAX_AXI_SIZE, `X2P_APB_DATA_WIDTH) */
//    assign cmd_addr = cmd_queue_wd >> (`X2P_AXI_SIDW + `LEN_WIDTH + 6);
    assign cmd_addr = cmd_queue_wd[(`X2P_AXI_SIDW + `LEN_WIDTH + 6) + (`APB_BUS_SIZE+7) : (`X2P_AXI_SIDW + `LEN_WIDTH + 6)];


   reg [5:0]                  next_state, state, next_state_check_on_strobes;
   
   //  bit 4 = 1 is a write
   parameter                   IDLE   = 6'b000000;
   parameter                   WSEL   = 6'b010010; // bit 1 is PSEL
   parameter                   WEN    = 6'b010011; // bit 0 is PENABLE 
   parameter                   WDTWT  = 6'b010000;
   parameter                   NWSEL  = 6'b010100;
   parameter                   WRESP  = 6'b011000;
   parameter                   NWEN   = 6'b011100; // forces a pop of the write buffer WSEL in time
   parameter                   WTSTART= 6'b110000; // waiting for wr buff on stsrt   
   parameter                   PURGE  = 6'b001100;
   parameter                   RSEL   = 6'b000010;
   parameter                   REN    = 6'b000011;
   parameter                   NREN   = 6'b101100;//used for initial address checks
   parameter                   RBUFWT = 6'b000100;
   parameter                   PREPURGE= 6'b100000; // used to put a blank cycle to allow a push before a purge
   

//   wire [(`X2P_APB_DATA_WIDTH/8)-1:0] all_apb_strobes = {(`X2P_APB_DATA_WIDTH/8){1'b1}}; //-1;
   
// function to get the initial APB WD SEL
   function automatic [7:0] get_initial_apb_wd_sel;
      input [2:0] size;
      input [`APB_BUS_SIZE+7:0] addr;
      // set the initial wd sel based on the address SIZE and the APB size
      // adjusts the count based on the address displacement
      // the value will end up pointing to the first byte of the first beat
      // to unpack from the write buffer
      integer sel_index;
      
      begin
        get_initial_apb_wd_sel = 8'h00;
        for(sel_index= 0; sel_index < 8; sel_index = sel_index+1)
          begin
             //spyglass disable_block SelfDeterminedExpr-ML
             //SMD: Self determined expression present in the design.
             //SJ : The expression used in if condition is intented as per design requirement, hence design remains unchanged.
           if ((sel_index+`APB_BUS_SIZE) < size) 
             get_initial_apb_wd_sel[sel_index] = addr[`APB_BUS_SIZE + sel_index];
             //spyglass enable_block SelfDeterminedExpr-ML
         end
      end
   endfunction // get_initial_apb_wd_sel

   
   //***************************************************************************
   // 
   //  The state machines 
   // 
   // 
   // ***************************************************************************/

   //  
   // the state machine for all controls in the X2XS
  
   always @(*)
     begin: X2XS_FSM_PROC
       next_state = state;
       penable = 1'b0;
       pwrite = 1'b0;
       psel_en = 1'b0;
       
     case(state)
       IDLE: begin
         next_state = IDLE;
         if (cmd_queue_empty == 1'b0)
           begin
             if (cmd_direction == 1)
               begin        
                 if (next_write_buff_empty == 1'b0)
                   begin
                     // the cmd queue contains a write command and the write data 
                     // is available advance the write data buffer to the next word 
                     // while regestering the wr data this will sync up to the APB ops.
                     next_state = NWEN;
                   end
                 else 
                   next_state = WTSTART;
             end // if (cmd_direction == 1)
             else
               begin
                 // The cmd queue is requesting a read operation
                 next_state = NREN;          
                 // address not aligned to the APB will reject this AXI transaction
                 // write will do this check during the NWEN
                 if (initial_cmd_error == 1'b1) 
                   next_state = PURGE;
             end // else: !if(cmd_direction == 1)
         end // if (cmd_queue_empty == 1'b0)
      end // case: IDLE
      PURGE:begin
        next_state = PURGE;
        if (cmd_direction == 1'b1)
          begin
            if (write_buffer_last == 1'b1)
              next_state = WRESP;
          end
          else // a read purge requires the rd buffer be pushed
            begin
              // counting to len 
              if (apb_axi_beat == cmd_len)
                begin
                  next_state = IDLE;
                  // check if the read buffer will take the last push
                  // if its full keep looping
                  if (read_buffer_full == 1'b1)
                  next_state = PURGE;
                end
        end // else: !if(cmd_direction == 1'b1)
      end // case: PURGE
      
    
      //**********************************************************************
      //*
      //*           Write State Machine
      //*
      //**********************************************************************

      WSEL: begin
        pwrite = 1'b1;
        psel_en = 1'b1;
        // this is when spel is asserted for one cycle before penable
        next_state = WEN;
      end
    
      WEN: begin
        penable = 1'b1;
        pwrite = 1'b1;
        psel_en = 1'b1;
        // this is the time where penable will normally be asserted
        // if not writting to the APB this will just do the checks on the next
        // while doing an APB access wait for PREADY before proceeding
        // the NWEN is non APB transactionsfrom the AXI
        if ((pready == 1'b1) && (state == WEN))
            begin
              next_state = WSEL;
              // issuing the data
              // now decide to continue with the issue of data
              // apb_wd_sel 0 indicates done unpacking and presenting 
              // the AXI wd on the APB
              // last strobes 0 ndicates the AXI wd strobes are all 0
              // in all these cases time to pop the write data buffer to 
              // get the next AXI word
              if (pop_wr_buff_request == 1'b0) 
                begin
                  next_state = next_state_check_on_strobes;
                end
              else
                // getting here indicates that the write buffer needs popping
                // check if the current registered buffer data is last
                // if not last need to get the current buffer data register it 
                // and pop it to the next
                // if the current status of the write buff is empty
                // have to go and wait for it to have something befor doing the pop
                // next_write_buff_empty is the empty status direct from the write buff
                begin
                  if (write_buffer_last_reg == 1'b1) 
                    next_state = WRESP;
                  else
                    begin
                      if (write_buff_empty == 1'b1)
                        next_state = WDTWT;
                      else 
                        next_state = next_state_check_on_strobes;
                   end
               end // else: !if(pop_wr_buff_request == 1'b0)
         end // if (((pready == 1'b1) && (state == WEN)) || (state == NWEN))
       end // case: WEN,NWEN
          
       NWEN: begin
         // this is the time where penable will normally be asserted
         // if not writting to the APB this will just do the checks on the next
         // while doing an APB access wait for PREADY before proceeding
         // the NWEN is non APB transactionsfrom the AXI
         if (state == NWEN)
           begin
             next_state = WSEL;
             // issuing the data
             // now decide to continue with the issue of data
             // apb_wd_sel 0 indicates done unpacking and presenting 
             // the AXI wd on the APB
             // last strobes 0 ndicates the AXI wd strobes are all 0
             // in all these cases time to pop the write data buffer to 
             // get the next AXI word
             if (pop_wr_buff_request == 1'b0) 
               begin
                 next_state = next_state_check_on_strobes;
               end
             else
             // getting here indicates that the write buffer needs popping
             // check if the current registered buffer data is last
             // if not last need to get the current buffer data register it 
             // and pop it to the next
             // if the current status of the write buff is empty
             // have to go and wait for it to have something befor doing the pop
             // next_write_buff_empty is the empty status direct from the write buff
               begin
                 if (write_buffer_last_reg == 1'b1) 
                   next_state = WRESP;
                 else
                   begin
                     if (write_buff_empty == 1'b1)
                       next_state = WDTWT;
                     else 
                       next_state = next_state_check_on_strobes;
                   end
               end // else: !if(pop_wr_buff_request == 1'b0)
         end // if (((pready == 1'b1) && (state == WEN)) || (state == NWEN))
      end // case: WEN,NWEN

      WDTWT: begin
        // getting ere the write buffer is empty and the transaction has not finished
        // used while into the transfer
        next_state = WDTWT;
        if (next_write_buff_empty == 1'b0)
          begin
            next_state = NWEN;  // pop the write buff and register the current write data
          end
      end
      WTSTART:
        // needed to differiate waiting for the write buffer on start
        // used to initialize to addressing
        begin
          next_state = WTSTART;
          if (next_write_buff_empty == 1'b0)
            begin
              next_state = NWEN;
            end
        end
      WRESP: begin
         if (resp_rdy_n == 1'b0) next_state = IDLE;
         else next_state = WRESP;
      end
      NWSEL:
        // fougrep_nd that the strobes are all off
        // get the next data
        // should act the same a WEN but don't look for pready
        begin
           next_state = NWEN;
        end
    
          //**********************************************************************
      //*
      //*          Read State Machine
      //*
      //**********************************************************************
      RSEL: begin
        psel_en = 1'b1;
        next_state = REN;
      end
      REN: begin
        penable = 1'b1;
        psel_en = 1'b1;
           
        // this is the penable time in the APB read
        // NREN is used only on startup. This functions as the REN
        // in the final next address. psel and decode checks
        next_state = state;
        // wait for PREADY before proceding
         if ((pready == 1'b1) && (state==REN))
           begin
             next_state = RSEL;
             // if the APB has reached the AXI word size
             // check to see if the read data can be pushed into the read buffer
             // if it can be pushed then check to see if the AXI 
             // transaction is finished
             if (apb_read_last == 1'b1)
               // time to push the read buffer
               begin
                 if(read_buffer_full == 1'b1) 
                   next_state = RBUFWT;
                 else 
                   if (apb_axi_beat == cmd_len)
                     next_state = IDLE;
                   else
                   // errror is pslverr registered. pslverr comes only on the
                   // single apb transaction so any error has to be saved
                   // the end of the fill of the axi word
                     if(dcd_error || pslverr || error) next_state = PREPURGE;
             end // if (apb_read_last == 1'b1)
             // if the next APB address dcds out of range
             // push te read buffer with SLVERR 
             else if (any_error == 1'b1) next_state =PREPURGE;
           end // if (((pready == 1'b1) && (state==REN)) || (state == NREN))
      end // case: REN,NREN
      NREN: begin
         // this is the penable time in the APB read
         // NREN is used only on startup. This functions as the REN
         // in the final next address. psel and decode checks
         next_state = state;
         // wait for PREADY before proceding
         if (state == NREN)
           begin
             next_state = RSEL;
             // if the APB has reached the AXI word size
             // check to see if the read data can be pushed into the read buffer
             // if it can be pushed then check to see if the AXI 
             // transaction is finished
             if (apb_read_last == 1'b1)
               // time to push the read buffer
               begin
                 if(read_buffer_full == 1'b1) 
                   next_state = RBUFWT;
                 else 
                   if (apb_axi_beat == cmd_len)
                     next_state = IDLE;
                   else
                   // errror is pslverr registered. pslverr comes only on the
                   // single apb transaction so any error has to be saved
                   // the end of the fill of the axi word
                   // CRM_9000501730 - Nov 2011
                     if(dcd_error || pslverr || error) next_state = PREPURGE;
             end // if (apb_read_last == 1'b1)
             // if the next APB address dcds out of range
             // push te read buffer with SLVERR 
             else if (any_error == 1'b1) next_state =PREPURGE;
           end // if (((pready == 1'b1) && (state==REN)) || (state == NREN))
      end // case: REN,NREN          
          // PREPURGE is used to allow a pending good push read buffer
      // to complete.
      PREPURGE:begin          
        next_state = PURGE;
      end
      RBUFWT: begin
        // need to do a push but the read buffer id full
        // keep looping here until the read buffer has space
        if (read_buffer_full) next_state = RBUFWT;
        else
          begin
          // returning from the push
          // act as if this was the REN state      
            if (apb_axi_beat == cmd_len)
              next_state = IDLE; // finished exit
            else
              begin
                // more to come get ack to accessing
                next_state = RSEL;
                // going to purge have to delay a cycle
                // to alow the previous op to finish. Equivalent to
                // a RSEL in a normal operation
                if (any_error == 1'b1) next_state = PREPURGE;
              end
          end // else: !if(read_buffer_full)
      end // case: RBUFWT
      default: next_state = IDLE;
    endcase // case(state)
    end // always @ (...
   
  

   //******************************************************************************
   //      initial_cmd_error 
   //      
   // check for address alignment size smaller than the APB size
   // 
    // if the SIZE is less than the APB error or any other error
      assign  initial_cmd_error = (cmd_addr[1:0] != 2'b00) ? 1'b1 : 1'b0;
    
      
   //******************************************************************************
   //      next_state_check_on_strobes 
   //      
   /// free running check on the strobes as they arrive
   //
   always @(*)
     begin: CHK_ON_STROBES_PROC
    // check the selected strobes if all 0 get the next APB size wd
    // all 1's go and issue to APB
    // if there is a mix of strobes this is an error
    //  also any error will be checked
       next_state_check_on_strobes = WSEL; //if all is OK continue
    // if the last strobe indicates none in the AXI were found (0)
    // then its on to the next AXI word
    if (last_strobes == 0)
      begin: NS_CHK_ON_STROBES_PROC
        if (write_buffer_last == 1'b1)
        // this was the last for this AXI xaction
        // issue the resp
           next_state_check_on_strobes = WRESP;
         else
           // tis is not the last, advance and pop the next APB word
           begin
             if (next_write_buff_empty == 1'b1)
                next_state_check_on_strobes = WDTWT;
             else next_state_check_on_strobes = NWSEL; // will pop another
          end // else: !if(write_buffer_last == 1'b1)
      end // if (last_strobes == 0)
    else
      begin
        // there are strobes set check
        // to see if this goes on to the APB 
        if (|selected_strobes)
          next_state_check_on_strobes = WSEL;
        else
          if (selected_strobes == 0)
            begin
            next_state_check_on_strobes = NWSEL;
            // nothing here to write
            // if last apb write go to pop the next
            // if not continuue advancing in the word
            if (apb_finished == 1'b1)
              begin
              // time to go out and pop if not the last
              if (write_buffer_last ==1'b1) 
                next_state_check_on_strobes = WRESP;
              else
                if (next_write_buff_empty == 1'b1) 
                  next_state_check_on_strobes = WDTWT;
                else 
                  next_state_check_on_strobes = NWSEL;
                end // if (apb_finished == 1'b1)
            end // if (selected_strobes == 0)
          else 
            next_state_check_on_strobes = PURGE;
      end // else: !if(last_strobes == 0)
     // error will overide the previous
     // CRM_9000501730 - Nov 2011
     // spyglass disable_block W415a
     // SMD: Signal may be multiply assigned (beside initialization) in the same scope.
     // SJ : State of the signal next_state_check_on_strobes is updated according to mutually dependent conditions. Hence warning can be ignored. 
     if ((any_error == 1'b1) || ((pslverr == 1'b1) && (pready == 1'b1) && ((state == WEN) || (state == REN))))
       next_state_check_on_strobes = PURGE;
    // spyglass enable_block W415a
     end // always @ (...

   // also fre run the calculation on the last APB write for the AXI word
   //spyglass disable_block SelfDeterminedExpr-ML
   //SMD: Self determined expression present in the design.
   //SJ : apb_finished is 1 bit wire, the result of expression in RHS results in either 1 or 0.
   assign apb_finished = (apb_wd_sel + 1 == last_strobes);
   //spyglass enable_block SelfDeterminedExpr-ML

   //******************************************************************************
   //      next_apb_axi_beat 
   //      
   /// as the read buffer is pushed count this as a beat for the axi from the apb
   always @(/*AS*/apb_axi_beat or next_push_read_buffer_n
            or next_state or read_buffer_full or state)
     begin: NEXT_APB_AXI_BEAT_PROC
     next_apb_axi_beat = apb_axi_beat;
     // initialize the beat count
       if (state == IDLE)
       begin
         next_apb_axi_beat = {`LEN_WIDTH{1'b0}};
         // if going to PURGE adjust the beat for the early push
         if (next_state == PURGE) next_apb_axi_beat = {`LEN_WIDTH{1'b0}};
       end
       // incriment the beat count
       // spyglass disable_block W415a
       // SMD: Signal may be multiply assigned (beside initialization) in the same scope.
       // SJ : next_apb_axi_beat is initialized based on state before incrementing.
       if (((state == PURGE) && (read_buffer_full == 1'b0)) 
              || (next_push_read_buffer_n == 1'b0))
         next_apb_axi_beat = apb_axi_beat + 1;
      // spyglass enable_block W415a
     end // always @ (...

   //******************************************************************************
   //      next_apb_axi_beat 
   //      
   /// as the read buffer is pushed count this as a beat for the axi from the apb

   always @(*)
   begin: S_NEXT_APB_WD_SEL_SPARSE_PROC 
     next_apb_wd_sel_sparse = 8'h00;
     if(state == IDLE)
       begin
         next_apb_wd_sel_sparse = 8'h00;
       end
     else if (state == RSEL)
     begin
       //spyglass disable_block SelfDeterminedExpr-ML
       //SMD: Self determined expression present in the design
       //SJ : The expression used in if condition is intented as per design requirement, hence design remains unchanged. 
       if(apb_wd_sel_sparse+1 == apb_wds_in_axi_wd_sparse)
       //spyglass enable_block SelfDeterminedExpr-ML
           next_apb_wd_sel_sparse = 8'h00;
       else
           next_apb_wd_sel_sparse = apb_wd_sel_sparse + 8'h01;
     end
     else
       next_apb_wd_sel_sparse = apb_wd_sel_sparse;
   end // always @ (...
   
   //******************************************************************************
   //      next_apb_wd_sel 
   //      
   // keep track of the APB words that are unpacked from the Write Data Buffer
   // set when the write buffer is available. set to point at the first non 0 strobes
   // incrmented as the APB words are advanced
   // The same for the reads but keep track of the read data for packing
  
   always @(*)
     begin: STATE_FSM_PROC
     case(state)
       IDLE,WDTWT,WTSTART: begin
         // when starting initialize to the starting APB word in the AXI word
         // after finished waiting for the buffer go not empty
         if(cmd_direction == 1'b1)
           begin
             // in a write using the location of the first strobe
             // to set the word sel
             next_apb_wd_sel = 8'h00;
           end
         else
           begin
             // in a read set from the cmd_addr
             // the start is based on the address dislacement in the AXI addres
             next_apb_wd_sel = get_initial_apb_wd_sel(((cmd_size >= `APB_BUS_SIZE) ? cmd_size : `APB_BUS_SIZE),cmd_addr);
           end // else: !if(cmd_direction == 1'b1)
      end // case: IDLE,WDTWT,WTSTART
      WSEL,NWSEL: begin
        // a write needs to get the strobe each time it pops a new word
        // the first strobe will set the wrd sel
        // the pop will not occur when the write buff is empty  
        // spyglass disable_block SelfDeterminedExpr-ML
        // SMD: Self determined expression present in the design
        // SJ: The expression used in if condition is intented as per design requirement, hence design remains unchanged.
        if ((apb_wd_sel + 1 == last_strobes)
               || (last_strobes == 0) || (state == WDTWT)) 
        // spyglass enable_block SelfDeterminedExpr-ML
         begin
        // APB finished with the current AXI word
        // get the new displacement from the strobes 
        // before popping the write buff
           next_apb_wd_sel = 8'h00;
         end
         else
           begin
             // haven't finished unpacking the AXI word
             next_apb_wd_sel = apb_wd_sel + 1;
         end // else: !if((apb_wd_sel + 1 == last_strobes)...
      end // case: WSEL,NWSEL
      RSEL: begin
        // if the read is finished reset
        // spyglass disable_block SelfDeterminedExpr-ML
        // SMD: Self determined expression present in the design
        // SJ : The expression used in if condition is intented as per design requirement, hence design remains unchanged.
        if (apb_wd_sel+1 == apb_wds_in_axi_wd)
        // spyglass enable_block SelfDeterminedExpr-ML
          begin
             next_apb_wd_sel = 8'h00;
         if (cmd_type == 0) // if fixed go back to the cmd addr
           next_apb_wd_sel = get_initial_apb_wd_sel(cmd_size,cmd_addr);
          end
        else
          begin
            next_apb_wd_sel = apb_wd_sel + 1;
          end
      end // case: RSEL
      default:
        next_apb_wd_sel = apb_wd_sel;
    endcase // case(state)
    end // always @ (...

   //**********************************************************************************
   //
   // next_apb_wds_in_axi_wd
   // this will indicate the last apb word positioned in the axi word
   // find the apb words in this series of transfers
   // the write uses the strobes to figure both first and last
   // so this is dynamically set every time the write data is fetched
   // 
   // the read sets first always to 0 and last the number of
   // axi transfers per AXI word this will never change from the command
    
   always @(/*AS*/apb_wd_sel or apb_wds_in_axi_wd 
       or cmd_direction
          or apb_wds_in_axi_wd_sparse
            or cmd_size or last_strobes or state)
     begin: NEXT_APB_WDS_PROC
    next_apb_wds_in_axi_wd = apb_wds_in_axi_wd;
    next_apb_wds_in_axi_wd_sparse = apb_wds_in_axi_wd_sparse;
    if (cmd_direction == 1'b1)
      begin
        // for writes any time new  write buffer data could occurr
        if ((state==NWEN) || (apb_wd_sel == 0))
          begin
            next_apb_wds_in_axi_wd = last_strobes;
          end
      end
    else
      begin
        // for reads
        if (state == IDLE)
        begin
          // Shifting by non-constant is intended operation
   //spyglass disable_block TA_09
   //SMD: Reports cause of uncontrollability or unobservability and estimates the number of nets whose controllability / observability is impacted.
   //SJ : Tool will give uncontrollability warning if any one of the bits of both operands are always tied to ground or VCC.
   //spyglass disable_block SelfDeterminedExpr-ML
   //SMD: Self determined expression present in the design
   //SJ : RHS will never exceed the boundary of LHS. 
          next_apb_wds_in_axi_wd = ( 8'd1 << (((cmd_size >= `APB_BUS_SIZE) ? cmd_size : `APB_BUS_SIZE) - `APB_BUS_SIZE));
          next_apb_wds_in_axi_wd_sparse = (1 << (`APB_BUS_SIZE - cmd_size));
   //spyglass enable_block SelfDeterminedExpr-ML
   //spyglass enable_block TA_09
        end
      end // else: !if(cmd_direction == 1'b1)
     end // always @ (...
   
   
   //**********************************************************************************
   //
   // apb_read_last
   // last APB word in the current AXI word
   // spyglass disable_block W415a
   // SMD: Signal may be multiply assigned (beside initialization) in the same scope.
   // SJ : Here we are updating the next_apb_read_last and next_apb_read_last_sparse based on mutually dependent conditions. Hence waiving this warning.
   // spyglass disable_block SelfDeterminedExpr-ML
   // SMD: Self determined expression present in the design
   // SJ : The expression used in if condition is intented as per design requirement, hence design remains unchanged.
   always @(*)
     begin: NEXT_APB_READ_LAST_PROC
       next_apb_read_last = apb_read_last;
       if ((state == RSEL) && (apb_wd_sel+1 == apb_wds_in_axi_wd)) next_apb_read_last = 1'b1;
         if ((state == REN) && (pready == 1'b1)) next_apb_read_last = 1'b0;
         next_apb_read_last_sparse = apb_read_last_sparse;
       if ((state == RSEL) && (apb_wd_sel_sparse+1 == apb_wds_in_axi_wd_sparse)) next_apb_read_last_sparse = 1'b1;
         if ((state == REN) && (pready == 1'b1)) next_apb_read_last_sparse = 1'b0;
   // spyglass enable_block SelfDeterminedExpr-ML
   // spyglass enable_block W415a
     end
   
   //*********************************************************************************
   // pop_wr_buff_request
   // need to pop the next apb word from the write data buffer
   // 
   always @(/*AS*/apb_wd_sel or last_strobes or pop_wr_buff_request
            or state)
     begin: NEXT_POP_WR_PROC
       next_pop_wr_buff_request = pop_wr_buff_request;
       // this will set if a pop is needed
       // reset if a po is not needed
       if ((state == WSEL) 
            || (state == NWSEL))
         begin
   // spyglass disable_block SelfDeterminedExpr-ML
   // SMD: Self determined expression present in the design
   // SJ : The output from RHS will be either 1 or 0 hence it will not exceed the boundary of 1 bit register next_pop_wr_buff_request
           next_pop_wr_buff_request = (((apb_wd_sel+1) == last_strobes) 
                                 && (last_strobes != 0));
   // spyglass enable_block SelfDeterminedExpr-ML
         end
         // reset when exiting
   // spyglass disable_block W415a
   // SMD: Signal may be multiply assigned (beside initialization) in the same scope.
   // SJ : Here we are updating the next_apb_read_last and next_apb_read_last_sparse based on mutually dependent conditions. Hence waiving this warning.
         if (state == WRESP) next_pop_wr_buff_request = 1'b0;
   // spyglass enable_block W415a
     end // always @ (...

   //**********************************************************************************
   //
   // Addressing controls follow
   // 
   // in the LAST AXI word
   //
 

   // set and increment the address paddr
   // incr_addr is an APB address incriment
   // during write should be active only when not incr_base (popping the write buff)

   assign wr_incr_addr = ((state==WSEL) || (state == NWSEL));
   // spyglass disable_block SelfDeterminedExpr-ML
   // SMD: Self determined expression present in the design
   // SJ : The output from RHS will be either 1 or 0 hence it will not exceed the boundary of 1 bit wire rd_incr_addr
    assign rd_incr_addr = ((cmd_size < `APB_BUS_SIZE) ? (((apb_wd_sel_sparse+1 == apb_wds_in_axi_wd_sparse) && (state == RSEL)) ? 1 : 0) : ((state == RSEL) ? 1 : 0));
   // spyglass enable_block SelfDeterminedExpr-ML
   
   // www.joe CRM_9000235907 - Sept 2008
   // replaced commented line with line below 
   assign incr_addr = wr_incr_addr | (rd_incr_addr && ((next_last_push_read==1'b0) || (next_last_push_read==1'b1 && next_apb_read_last==1'b0)));
   //assign incr_addr = wr_incr_addr | rd_incr_addr;
   // www.joe - end
   
   // set when the next AXI word has been popped, advances to the next AXI word address
   // not used in Read INCR
   
   // www.joe CRM_9000235907 - Sept 2008
   // replaced commented line with line below
   assign rd_incr_base_addr = (((cmd_size < `APB_BUS_SIZE) ? (next_apb_read_last_sparse == 1'b1) : (next_apb_read_last == 1'b1)) && (state == RSEL) && (next_last_push_read == 1'b0));
   //assign rd_incr_base_addr = ((next_apb_read_last == 1'b1) && (state == RSEL));
   // www.joe - end

   assign wr_incr_base_addr = !(pop_write_buff_n);
   assign incr_base_addr = ((state != PURGE) &&
                             ((rd_incr_base_addr == 1'b1) 
                              || (wr_incr_base_addr == 1'b1)));
   
   // the inital setting of the address from the cmd queue
   // will be issued to set the starting address of the transaction
   // In FIXED this will also be issued on each AXI beat
   assign next_wr_set_addr = ((cmd_direction == 1'b1) 
                   && ((state == IDLE) || (state == WTSTART)));
   assign rd_set_addr = ((cmd_direction == 1'b0) && (state == IDLE) 
                        && (cmd_queue_empty == 1'b0));
   assign set_addr = ((rd_set_addr == 1'b1) || (next_wr_set_addr == 1'b1));

   // using a seperate paddr register to keep the address transitions down
   assign update_address = ((next_state == WSEL) || (next_state == RSEL));  
  
   //
   // write error setting. Any error from the APB or an internal error will be held
   // untill the end of the transaction
   // errrors detected upon obtaining the command are issued right away
   // errors found during the read transfer are delayed one cycle into the purge
   // this is because the push to the read data buffer is in progress with
   //  the last good address data
   // spyglass disable_block W415a
   // SMD: Signal may be multiply assigned (beside initialization) in the same scope.
   // SJ : Here we are updating the signal next_error based on mutually dependent conditions. Hence waiving this warning.
   always @(*)
     begin: NEXT_ERROR_PROC
       next_error = error;
       // during a write the error has to be presented with the push to the write resp buffer
       if ((cmd_direction == 1'b1) && (next_state == PURGE))
       next_error = 1'b1;

       // into a purge during a transfer delay the err to keep away from the push read buff
       // jstokes, 10/3/2010, STAR 9000377785
       // pslverr should not be considered here unless pready == 1 also.
       // Code for this process cleaned up also.
       // CRM_9000501730 - Nov 2011
         if ((state == PURGE) || (state == PREPURGE) || ((pslverr & pready) && (state == WEN || state == REN))) 
         next_error = 1'b1;

         // read or write bad from the start imeadiatly issue the error
         if ((state == IDLE) && (next_state == PURGE)) 
          next_error = 1'b1;

         // clear when exiting purge
         //cg if ((next_state == IDLE) && (state == PURGE))  next_error = 1'b0;
       if (next_state == IDLE)  next_error = 1'b0;
     end // always @ (...
  // spyglass enable_block W415a
/*   
   // write_active
   always @(*)
     begin: NEXT_WRITE_ACTIVE_PROC
    next_write_active = write_active;
    if (next_state == IDLE) next_write_active = 1'b0;
    if ((state == IDLE) && (next_state != IDLE) && (cmd_direction == 1))
      next_write_active = 1'b1;
     end
*/
   //
   // read error response setting
   // spyglass disable_block W415a
   // SMD: Signal may be multiply assigned (beside initialization) in the same scope.
   // SJ : Here we are updating the signal next_rd_err  based on mutually dependent conditions. Hence waiving this warning.
   always @(*)
     begin: NEXT_RD_ERROR_PROC
       next_rd_err = rd_error;
       if (state == IDLE) next_rd_err = 1'b0;
         if (cmd_queue_empty==1'b0 && cmd_direction == 0)
           begin
             if(((dcd_error ==1) && (state != IDLE)) || (initial_cmd_error == 1'b1)) 
               next_rd_err = 1'b1;
           end
       if ((state == REN) && (pready== 1'b1) && (pslverr == 1)) next_rd_err = 1'b1;
     end    
   // spyglass enable_block W415a 

            
// address decode error or write strobe error
   assign any_error = dcd_error || error || initial_cmd_error;
              
   // pop the write data buffer
   // the pop will cause the curret data to be registered and processed
   // if this is the last don't pop until starting the next AXI xfer
   // pop if the buff returns from empty or idle
   always @(/*AS*/apb_wd_sel or cmd_direction or cmd_queue_empty
            or last_strobes or next_write_buff_empty or state
            or write_buffer_last or write_buffer_last_reg)
     begin: POP_WRITE_BUS_PROC
       pop_write_buff_n = 1'b1;
       if (cmd_direction == 1'b1)
         begin
           case(state)
             WSEL,NWSEL: begin
               // need the next AXI word to unpace
               // and not the last AXI word
               // spyglass disable_block SelfDeterminedExpr-ML
               // SMD: Self determined expression present in the design
               // SJ : The expression used in if condition is as per design requirement and hence design remains unchanged. 
               if ((((apb_wd_sel+1 == last_strobes) || (last_strobes == 0)) 
                                     && (write_buffer_last_reg == 1'b0))
                                     && (next_write_buff_empty == 1'b0))
               // spyglass enable_block SelfDeterminedExpr-ML
                 pop_write_buff_n = 1'b0;
             end
             IDLE,WDTWT,WTSTART: begin
               // starting the xfer, need a pop and the buffer is got something
               if ((cmd_queue_empty == 1'b0) && (next_write_buff_empty == 1'b0))
                 pop_write_buff_n = 1'b0;
             end
             PURGE: begin
               // keep popping if not empty an not last
               if((write_buffer_last == 1'b0)
                                     && (next_write_buff_empty == 1'b0))
                 pop_write_buff_n = 1'b0;
                end
              default: pop_write_buff_n = 1'b1;
            endcase // case(state)
         end // if (cmd_direction == 1'b1)
     end // always @ (...

   // used to register the current ID
   // for the write response
   assign save_id = (state == IDLE);

   // the pop of the CMD Queue
   assign wr_pop_cmd = ((state == WRESP) && (resp_rdy_n == 1'b0));

always @(*)     
  begin: FSM_STATE_RD_POP_CMD_PROC
    case(state)
      PURGE: begin
        rd_pop_cmd = ((apb_axi_beat == cmd_len) 
                     && (read_buffer_full == 0)
                     && (cmd_queue_empty == 0)
                     && (cmd_direction == 0));
      end
      REN: begin
        rd_pop_cmd = (apb_read_last == 1'b1) &&
                     (pready == 1'b1) &&
                     (read_buffer_full == 0)
                     && (cmd_queue_empty == 0) 
                     && (apb_axi_beat == cmd_len);
      end
      RBUFWT: begin
        rd_pop_cmd = ((read_buffer_full == 0)
                     && (cmd_queue_empty == 0) 
                     && (apb_axi_beat == cmd_len));
       end
       default: rd_pop_cmd = 1'b0;
     endcase // case(state)
  end // always @ (...
 
   assign pop_cmd_queue_n = !((wr_pop_cmd | rd_pop_cmd));
   
 
   // telling the read buffer to pack the data
   assign enable_pack = pready & penable & (~cmd_direction);
   // telling the packer this is the last apb for the transaction
   // during the purge since this is an error condition the push will occur disregarding the data
   
   // setting the rlast to be pushed
   always @(/*AS*/cmd_direction or cmd_len or last_push_read
            or next_apb_axi_beat or next_state or state)
    begin: FSM_STATE_LAST_PUSH_RD_PROC
     if(cmd_direction == 1'b0)
       begin
          case(state)
            RSEL,PURGE,PREPURGE:begin       
              next_last_push_read = (next_apb_axi_beat == cmd_len);
            end
            IDLE: begin
              next_last_push_read = 1'b0;
              // one beat get the last now, it will be too late otherwize
              if ((next_state == PURGE) && (cmd_len == 0))
                next_last_push_read = 1'b1;    
            end
            default:     next_last_push_read = last_push_read;
          endcase // case(state)
       end // if (cmd_direction == 1'b0)
     else
       next_last_push_read = 1'b0;
   end // always @ (...
   
   
   // clears the packer data reg
   assign clr_rd_data_reg = (state == IDLE);
   
   // pushing the read data buffer
   assign next_push_read_buffer_n = ~(((cmd_direction == 1'b0) && (read_buffer_full == 0)) && ((((state == REN) && (apb_read_last) && (pready == 1'b1)) || ((state == RBUFWT) && (next_state != RBUFWT)))));
   
  // a push to the read buffer on an error is issued without registering it
   always @(/*AS*/cmd_direction or push_read_buffer_reg
            or read_buffer_full or state)
     begin: PUSH_RD_BUFFER_PROC
       if ((state == PURGE) && (cmd_direction == 1'b0))
         push_read_buffer_n = read_buffer_full;
       else
         begin
          push_read_buffer_n = push_read_buffer_reg;
         end
     end


   // issue a request to push the resp buffer when the last appears
   // going to idle from issuing the resp in write implies that the LAST has come and last 
   // the last apb word hase gone out
   assign push_rsp_buff_n = !((state == WRESP) && (resp_rdy_n == 1'b0));
      
   // set the write data
   // when the next cycle will be a write sel
   assign set_data = (next_state == WSEL);
         

   //*****************************************************************
   //
   // syncing the write buf status to the appropriate APB transaction
   //
   //****************************************************************

   
 // take the popped status and position it such that it goes with
   // the APB transaction avoiding the previous
   // write_buffer_last is the popped last registered//
   // spyglass disable_block W415a
   // SMD: Signal may be multiply assigned (beside initialization) in the same scope.
   // SJ : Here we are updating the signal next_write_buffer_last_reg based on mutually dependent conditions. Hence waiving this warning.
  always @(*)
  begin: BUFFER_LAST_REG_PROC
     next_write_buffer_last_reg = write_buffer_last_reg;
     // sets to write buffer last reg
     // check after the pop and position with the first popped APB transaction
     if (((state == WEN) && (pready == 1'b1)) || (state == NWEN))
         next_write_buffer_last_reg = write_buffer_last;
     if (next_state == IDLE) next_write_buffer_last_reg = 1'b0;
  end
   // spyglass enable_block W415a

   
// the just popped write buffer empty is delayed until the current APB write is finised
   // with the previous popped transaction on the APB
   // spyglass disable_block W415a
   // SMD: Signal may be multiply assigned (beside initialization) in the same scope.
   // SJ : Here we are updating the signal write_buff_empty_ns based on mutually dependent conditions. Hence waiving this warning.
   always @(*)
     begin: WRITE_BUFF_EMPTY_NS_PROC
       write_buff_empty_ns = write_buff_empty;
       // setting just as the last APB finishes
       // or after popping or after waiting for the the buffer to fill
       if (((state == WEN) && (pready == 1'b1)) || (state == NWEN) || (state == WDTWT))
         write_buff_empty_ns = next_write_buff_empty;
       // reset when the write buff is popped implies not empty
       if (pop_write_buff_n == 1'b0) write_buff_empty_ns = 1'b0;
     end // always @ (...
   // spyglass enable_block W415a
  
   // all the FFs are here

   always @(posedge clk or negedge rstn)
     begin: S_FF_PROC
       if (rstn == 1'b0)
         begin
           state <= IDLE;
           apb_read_last <= 1'b0;
           apb_read_last_sparse <= 1'b0;
           apb_wd_sel_sparse <= 8'h00;
           apb_wds_in_axi_wd_sparse <= 8'h00;
           apb_wd_sel <= 8'h00;
           error <= 1'b0;
           apb_wds_in_axi_wd <= 8'h00;
           push_read_buffer_reg <= 1'b1;
           apb_axi_beat <= {`LEN_WIDTH{1'b0}};
           last_push_read <= 1'b0;
           write_buff_empty <= 1'b0; 
           write_buffer_last_reg <= 1'b0;
           pop_wr_buff_request <= 1'b0;
           rd_error <= 1'b0;
         end // if (rstn == 1'b0)
       else
         begin
           state <= next_state;
           apb_read_last <= next_apb_read_last;
           apb_read_last_sparse <= next_apb_read_last_sparse;
           apb_wd_sel_sparse <= next_apb_wd_sel_sparse;
           apb_wds_in_axi_wd_sparse <= next_apb_wds_in_axi_wd_sparse;
           apb_wd_sel <= next_apb_wd_sel;
           error <= next_error;
//         write_active <= next_write_active;
           apb_wds_in_axi_wd <= next_apb_wds_in_axi_wd;
           push_read_buffer_reg <= next_push_read_buffer_n;
           apb_axi_beat  <= next_apb_axi_beat;
           last_push_read <= next_last_push_read;
           write_buff_empty <= write_buff_empty_ns;
           write_buffer_last_reg <= next_write_buffer_last_reg;
           pop_wr_buff_request <= next_pop_wr_buff_request;
           rd_error <= next_rd_err;
         end // else: !if(rstn == 1'b0)
     end // always @ (posedge clk or negedge rstn)

   
endmodule // DW_axi_x2ps_control



