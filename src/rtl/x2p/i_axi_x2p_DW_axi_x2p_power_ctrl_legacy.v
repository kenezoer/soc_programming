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
// Revision: $Id: //dwh/DW_ocb/DW_axi_x2p/amba_dev/src/DW_axi_x2p_power_ctrl_legacy.v#11 $ 
*/

//
//
//-----------------------------------------------------------------------------
// Filename    : DW_axi_x2p_power_ctrl_legacy
// Created     : Wed March 15, 2006  19:30:00 GMT
// Description : AXI-to-APB bridge power control.
//               Constantly keeps a count (up to 32) of outstanding write and
//               read transactions. If any transactions are active the output
//               no_px will be inactive
//
//
//-----------------------------------------------------------------------------

`include "i_axi_x2p_DW_axi_x2p_all_includes.vh"

module i_axi_x2p_DW_axi_x2p_power_ctrl_legacy (/*AUTOARG*/
   // Outputs
   no_px,
   // Inputs
   aclk, aresetn, bready, bvalid, rvalid, rready, rlast,
   rd_push_cmd_queue_n, wr_push_cmd_queue_n
   );

  input aclk;
  input aresetn;
  input bready;              // master is ready for end of a write transfer
  input bvalid;              // end of the slaves write transfer
  input rvalid;              // slave indicating read data
  input rready;              // AXI master is accepting the read data
  input rlast;               // indication to AXI master that this is the last data
  input rd_push_cmd_queue_n; // pushing a read to the AHB slave side
  input wr_push_cmd_queue_n; // pushing a write to the AHB slave side
  output no_px;              // indicates that there are no pending operation
                             // in the bridge

  wire aresetn_int, bready_int, bvalid_int, rvalid_int, rready_int, rlast_int,
       rd_push_cmd_queue_n_int, wr_push_cmd_queue_n_int;

  assign aresetn_int = aresetn;
  assign bready_int  = bready;
  assign bvalid_int  = bvalid;
  assign rvalid_int  = rvalid;
  assign rready_int  = rready;
  assign rlast_int   = rlast;
  assign rd_push_cmd_queue_n_int = rd_push_cmd_queue_n;
  assign wr_push_cmd_queue_n_int = wr_push_cmd_queue_n;


  //
  //               Power control
  //
  // Monitor all operations for completion

  // The transaction counts are limited to 64 for reads and 48 for writes.
  // Since the maximum allowed cmd buffer depth is 32, the rdata buffer
  // depth is 32 (reads) and resp buffer depth is 16 (writes) this assures
  // a count of the outstanding reads and writes will not overflow the counts.
  reg [5:0]  ativ_writes_ns, ativ_writes;
  reg [6:0]  ativ_reads_ns, ativ_reads;

  wire       no_px;

  // count of outstanding writes
  // increment count when pushing a write on the command queue
  // decrement count when bvaild response is reconized with bready
  always @(*)
    begin: ACTIVE_CNTS_PROC
      ativ_writes_ns = ativ_writes;
      case ({wr_push_cmd_queue_n_int,bvalid_int,bready_int})
        3'b000, 3'b001, 3'b010: begin
        // pushing the cmd queue and no response
          ativ_writes_ns = ativ_writes + 1;
        end
        3'b111: begin
        // responding and no push this is for cases where BREADY is held on
          ativ_writes_ns = ativ_writes - 1;
        end
        default: begin
        // all others do nothing to the count
          ativ_writes_ns = ativ_writes;
        end
      endcase // case({wr_push_cmd_queue_n_int,bvalid_int,bready_int})


      // count of outstanding reads
      // increment on push to command queue
      // decrement when read responds with last
      case ({rd_push_cmd_queue_n_int,rvalid_int,rready_int,rlast_int})
        4'b0000, 4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b0110:  begin
          // pushing
          ativ_reads_ns = ativ_reads + 1;

        end
        4'b1111: begin
          // No new AXI read ( no push on cmd queue)
          //last read response only
            ativ_reads_ns = ativ_reads - 1;
        end
        default: begin // anything else is a noop
          ativ_reads_ns = ativ_reads;
        end
      endcase // case({rd_push_cmd_queue_n_int,rvalid_int,rready_int,rlast_int})
    end // block: ACTIVE_CNTS

  // if either writes or reads have not completed the AXI Slave is active
  assign  no_px = !((ativ_writes != 0) || (ativ_reads != 0));

  // path from read data fifo to ativ_reads, rlast from rdata fifo used
  // in path. Data from fifo is only used when fifo is not empty, and empty
  // signal is synchronised.
  always @(posedge aclk or negedge aresetn_int)
    if (aresetn_int == 1'b0)
      begin
        ativ_writes <= 6'b000000;
        ativ_reads <= 7'b0000000;
      end
    else
      begin
        ativ_writes <= ativ_writes_ns ;
        ativ_reads <= ativ_reads_ns;
      end // else: !if(aresetn_int == 1'b0)

endmodule // DW_axi_x2p_power_ctrl

