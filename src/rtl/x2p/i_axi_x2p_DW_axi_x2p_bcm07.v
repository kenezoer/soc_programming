
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
// Filename    : DW_axi_x2p_bcm07.v
// Revision    : $Id: //dwh/DW_ocb/DW_axi_x2p/amba_dev/src/DW_axi_x2p_bcm07.v#16 $
// Author      : Vikas Gokhale       5/17/04
// Description : DW_axi_x2p_bcm07.v Verilog module for DW_axi_x2p
//
// DesignWare IP ID: 55f31ece
//
////////////////////////////////////////////////////////////////////////////////


module i_axi_x2p_DW_axi_x2p_bcm07 (
        clk_push,
        rst_push_n,
        init_push_n,
        push_req_n,
        push_empty,
        push_ae,
        push_hf,
        push_af,
        push_full,
        push_error,
        push_word_count,
        we_n,
        wr_addr,

        clk_pop,
        rst_pop_n,
        init_pop_n,
        pop_req_n,
        pop_empty,
        pop_ae,
        pop_hf,
        pop_af,
        pop_full,
        pop_error,
        pop_word_count,
        rd_addr
);

parameter DEPTH         =  8;   // RANGE 2 to 16777216
parameter ADDR_WIDTH    =  3;   // RANGE 1 to 24
parameter COUNT_WIDTH   =  4;   // RANGE 2 to 25
parameter PUSH_AE_LVL   =  2;   // RANGE 1 to DEPTH-1
parameter PUSH_AF_LVL   =  2;   // RANGE 1 to DEPTH-1
parameter POP_AE_LVL    =  2;   // RANGE 1 to DEPTH-1
parameter POP_AF_LVL    =  2;   // RANGE 1 to DEPTH-1
parameter ERR_MODE      =  0;   // RANGE 0 to 1
parameter PUSH_SYNC     =  2;   // RANGE 1 to 4
parameter POP_SYNC      =  2;   // RANGE 1 to 4
parameter EARLY_PUSH_STAT =  0;   // RANGE 0 to 15
parameter EARLY_POP_STAT  =  0;   // RANGE 0 to 15
parameter MEM_MODE      =  0;   // RANGE 0 to 3
parameter VERIF_EN      =  1;   // RANGE 0 to 5

localparam PIPE_GRAY_POP = (MEM_MODE==1 || MEM_MODE==3) ? 1 : 0;
localparam PIPE_GRAY_PUSH = (MEM_MODE==2 || MEM_MODE==3) ? 1 : 0;

input                           clk_push;       // Push domain clk input
input                           rst_push_n;     // Push domain active low async reset
input                           init_push_n;    // Push domain active low sync reset
input                           push_req_n;     // Push domain active high push reqest
output                          push_empty;     // Push domain Empty status flag
output                          push_ae;        // Push domain Almost Empty status flag
output                          push_hf;        // Push domain Half full status flag
output                          push_af;        // Push domain Almost full status flag
output                          push_full;      // Push domain Full status flag
output                          push_error;     // Push domain Error status flag
output [COUNT_WIDTH-1 : 0]      push_word_count;// Push domain word count
output                          we_n;           // Push domain active low RAM write enable
output [ADDR_WIDTH-1 : 0]       wr_addr;        // Push domain RAM write address

input                           clk_pop;        // Pop domain clk input
input                           rst_pop_n;      // Pop domain active low async reset
input                           init_pop_n;     // Pop domain active low sync reset
input                           pop_req_n;      // Pop domain active high pop request
output                          pop_empty;      // Pop domain Empty status flag
output                          pop_ae;         // Pop domain Almost Empty status flag
output                          pop_hf;         // Pop domain Half full status flag
output                          pop_af;         // Pop domain Almost full status flag
output                          pop_full;       // Pop domain Full status flag
output                          pop_error;      // Pop domain Error status flag
output [COUNT_WIDTH-1 : 0]      pop_word_count; // Pop domain word count
output [ADDR_WIDTH-1 : 0]       rd_addr;        // Pop domain RAM read address



wire                            reg_push_empty;         // Registered Push domain Empty status flag
wire                            reg_push_full;          // Registered Push domain Full status flag
wire                            reg_push_error;         // Registered Push domain Error status flag
wire   [COUNT_WIDTH-1 : 0]      reg_push_word_count;    // Registered Push domain word count
wire                            early_push_empty_n;     // Unregistered Push domain Empty status flag (active-low)
wire                            early_push_full;        // Unregistered Push domain Full status flag
wire                            early_push_error;       // Unregistered Push domain Error status flag
wire   [COUNT_WIDTH-1 : 0]      early_push_word_count;  // Unregistered Push domain word count

wire                            reg_pop_empty;          // Registered Pop domain Empty status flag
wire                            reg_pop_full;           // Registered Pop domain Full status flag
wire                            reg_pop_error;          // Registered Pop domain Error status flag
wire   [COUNT_WIDTH-1 : 0]      reg_pop_word_count;     // Registered Pop domain word count
wire                            early_pop_empty_n;      // Unregistered Pop domain Empty status flag (active-low)
wire                            early_pop_full;         // Unregistered Pop domain Full status flag
wire                            early_pop_error;        // Unregistered Pop domain Error status flag
wire   [COUNT_WIDTH-1 : 0]      early_pop_word_count;   // Unregistered Pop domain word count

wire [COUNT_WIDTH-1 : 0]        push_addr_g;
wire [COUNT_WIDTH-1 : 0]        pop_addr_g;


`ifndef SYNTHESIS
`ifndef DWC_DISABLE_CDC_METHOD_REPORTING
  initial begin
    if ((POP_SYNC > 0)&&(POP_SYNC < 8))
       $display("Information: *** Instance %m module is using the <Dual Clock FIFO Controller (11)> Clock Domain Crossing Method ***");
  end

`endif
`endif

  assign we_n = push_full | push_req_n;

i_axi_x2p_DW_axi_x2p_bcm05
 #(DEPTH, ADDR_WIDTH, COUNT_WIDTH, PUSH_AE_LVL, PUSH_AF_LVL, ERR_MODE, PUSH_SYNC, 1, PIPE_GRAY_PUSH, VERIF_EN ) U_PUSH_FIFOFCTL(
  .clk(clk_push),
  .rst_n(rst_push_n),
  .init_n(init_push_n),
  .inc_req_n(push_req_n),
  .other_addr_g(pop_addr_g),
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: Based on component configuration, this(these) signal(s) or parts of it will not be used to compute the final result.
  .word_count(reg_push_word_count),
  .empty(reg_push_empty),
// spyglass enable_block W528
  .almost_empty(push_ae),
  .half_full(push_hf),
  .almost_full(push_af),
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: Based on component configuration, this(these) signal(s) or parts of it will not be used to compute the final result.
  .full(reg_push_full),
  .error(reg_push_error),
// spyglass enable_block W528
  .this_addr(wr_addr),
  .this_addr_g(push_addr_g),
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: Based on component configuration, this(these) signal(s) or parts of it will not be used to compute the final result.
  .next_word_count(early_push_word_count),
  .next_empty_n(early_push_empty_n),
  .next_full(early_push_full),
// spyglass enable_block W528
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: Based on component configuration, this(these) signal(s) or parts of it will not be used to compute the final result.
  .next_error(early_push_error)
// spyglass enable_block W528
  );

  i_axi_x2p_DW_axi_x2p_bcm05
   #(DEPTH, ADDR_WIDTH, COUNT_WIDTH, POP_AE_LVL, POP_AF_LVL, ERR_MODE, POP_SYNC, 0, PIPE_GRAY_POP, VERIF_EN ) U_POP_FIFOFCTL(
  .clk(clk_pop),
  .rst_n(rst_pop_n),
  .init_n(init_pop_n),
  .inc_req_n(pop_req_n),
  .other_addr_g(push_addr_g),
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: Based on component configuration, this(these) signal(s) or parts of it will not be used to compute the final result.
  .word_count(reg_pop_word_count),
  .empty(reg_pop_empty),
// spyglass enable_block W528
  .almost_empty(pop_ae),
  .half_full(pop_hf),
  .almost_full(pop_af),
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: Based on component configuration, this(these) signal(s) or parts of it will not be used to compute the final result.
  .full(reg_pop_full),
  .error(reg_pop_error),
// spyglass enable_block W528
  .this_addr(rd_addr),
  .this_addr_g(pop_addr_g),
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: Based on component configuration, this(these) signal(s) or parts of it will not be used to compute the final result.
  .next_word_count(early_pop_word_count),
  .next_empty_n(early_pop_empty_n),
  .next_full(early_pop_full),
// spyglass enable_block W528
// spyglass disable_block W528
// SMD: A signal or variable is set but never read
// SJ: Based on component configuration, this(these) signal(s) or parts of it will not be used to compute the final result.
  .next_error(early_pop_error)
// spyglass enable_block W528
  );

generate
  if ((EARLY_PUSH_STAT & 1) == 1) begin : GEN_EARLY_PSH_EMPTY
    wire   early_push_empty;
    assign early_push_empty = ~early_push_empty_n;
    assign push_empty = early_push_empty;
  end else begin : GEN_REG_PSH_EMPTY
    assign push_empty = reg_push_empty;
  end
  if ((EARLY_PUSH_STAT & 2) == 2) begin : GEN_EARLY_PSH_FULL
    assign push_full = early_push_full;
  end else begin : GEN_REG_PSH_FULL
    assign push_full = reg_push_full;
  end
  if ((EARLY_PUSH_STAT & 4) == 4) begin : GEN_EARLY_PSH_WC
    assign push_word_count = early_push_word_count;
  end else begin :  GEN_REG_PSH_WC
    assign push_word_count = reg_push_word_count;
  end
  if ((EARLY_PUSH_STAT & 8) == 8) begin : GEN_EARLY_PSH_ERR
    assign push_error = early_push_error;
  end else begin : GEN_REG_PSH_ERR
    assign push_error = reg_push_error;
  end

  if ((EARLY_POP_STAT & 1) == 1) begin : GEN_EARLY_POP_EMPTY
    wire   early_pop_empty;
    assign early_pop_empty = ~early_pop_empty_n;
    assign pop_empty = early_pop_empty;
  end else begin : GEN_REG_POP_EMPTY
    assign pop_empty = reg_pop_empty;
  end
  if ((EARLY_POP_STAT & 2) == 2) begin : GEN_EARLY_POP_FULL
    assign pop_full = early_pop_full;
  end else begin : GEN_REG_POP_FULL
    assign pop_full = reg_pop_full;
  end
  if ((EARLY_POP_STAT & 4) == 4) begin : GEN_EARLY_POP_WC
    assign pop_word_count = early_pop_word_count;
  end else begin : GEN_REG_POP_WC
    assign pop_word_count = reg_pop_word_count;
  end
  if ((EARLY_POP_STAT & 8) == 8) begin : GEN_EARLY_POP_ERR
    assign pop_error = early_pop_error;
  end else begin : GEN_REG_POP_ERR
    assign pop_error = reg_pop_error;
  end
endgenerate

`ifdef DWC_BCM_SNPS_ASSERT_ON
`ifndef SYNTHESIS

  DW_axi_x2p_sva07 #(
    .F_SYNC_TYPE (PUSH_SYNC  ),
    .R_SYNC_TYPE (POP_SYNC   )
  ) P_CDC_CLKCOH (
      .clk_s     (clk_push   )
    , .clk_d     (clk_pop    )
    , .rst_s_n   (rst_push_n )
    , .rst_d_n   (rst_pop_n  )
  );

  DW_axi_x2p_sva12_c P_RESET_PUSH(
    .clk(clk_push),
    .rst_n(rst_push_n),
    .init_n(init_push_n),
    .req_n(push_req_n)
  );

  DW_axi_x2p_sva12_c P_RESET_POP(
    .clk(clk_pop),
    .rst_n(rst_pop_n),
    .init_n(init_pop_n),
    .req_n(pop_req_n)
  );

`endif // SYNTHESIS
`endif // DWC_BCM_SNPS_ASSERT_ON
endmodule
