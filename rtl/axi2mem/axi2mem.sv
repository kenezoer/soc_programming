//
// AXI multi-cycle latency SRAM wrapper using pulp_platform axi interfaces
//
// Author: Eugene Feinberg <eugene@recogni.com>
// Copyright Recogni, Inc 2020
//


import axi4_pkg::*;

module axi_sram #(
    parameter integer AXI_ADDR_WIDTH=64,
    parameter integer AXI_DATA_WIDTH=64,
    parameter integer AXI_ID_WIDTH=4,
    parameter integer AXI_USER_WIDTH=4,
    parameter integer SRAM_BANKS_ROWS=1,
    parameter integer SRAM_BANKS_COLS=1,
    parameter integer SRAM_BANK_ADDR_WIDTH=16,
    parameter integer SRAM_BANK_DATA_WIDTH=32,
    parameter integer SRAM_READ_LATENCY=2,
    parameter integer WRITE_REQUEST_FIFO_DEPTH=2,
    parameter integer READ_REQUEST_FIFO_DEPTH=4
) (
    input logic clk_i,
    input logic rst_ni,

    // AXI slave interface
    axi4_if.Slave axi,

    // SRAM bank interface
    output logic [SRAM_BANK_ADDR_WIDTH-1:0]                                                     bank_addr,
    output logic [SRAM_BANKS_ROWS-1:0][SRAM_BANKS_COLS-1:0]                                     bank_cs,
    output logic [SRAM_BANKS_ROWS-1:0][SRAM_BANKS_COLS-1:0]                                     bank_we,
    output logic [SRAM_BANKS_ROWS-1:0][SRAM_BANKS_COLS-1:0][(SRAM_BANK_DATA_WIDTH/8)-1:0]       bank_be,
    output logic                      [SRAM_BANKS_COLS-1:0][SRAM_BANK_DATA_WIDTH-1:0]           bank_wdata,
    input  logic [SRAM_BANKS_ROWS-1:0][SRAM_BANKS_COLS-1:0][SRAM_BANK_DATA_WIDTH-1:0]           bank_rdata
);
    genvar i,j;

    logic write_request_tick, read_request_tick;
    logic read_request_free;
    logic write_request_free;

    //
    // Read result pipeline
    //
    // To support SRAM macros with read latency > 1 cycle, the read data must be internally
    // buffered if the AXI read response interface is not ready to accept the result
    // when it is available from the memory macro
    //
    localparam READ_FIFO_DEPTH=4;

    //
    // The data fifo holds read results from the memory core 
    //
    logic [AXI_DATA_WIDTH-1:0] read_data_fifo_in, read_data_fifo_out;

    fifo_v3 #(
        .DATA_WIDTH ( SRAM_BANKS_COLS * SRAM_BANK_DATA_WIDTH ),
        .DEPTH      ( SRAM_READ_LATENCY + READ_FIFO_DEPTH    )
    ) read_data_fifo (
        .clk_i(clk_i),
        .rst_ni(rst_ni),

        .flush_i(1'b0),
        .testmode_i(1'b0),

        .full_o(),
        .empty_o(read_data_fifo_empty),

        .usage_o(),

        .data_i(read_data_fifo_in),
        .push_i(read_data_fifo_push),

        .data_o(read_data_fifo_out),
        .pop_i(read_data_fifo_pop)
    );

    assign read_data_fifo_pop = axi.r_ready && axi.r_valid;
    
    assign axi.r_data  = read_data_fifo_out;
    assign axi.r_valid = !read_data_fifo_empty;
    assign axi.r_resp  = axi4_pkg::RESP_OKAY;

    //
    // The read id fifo holds master IDs and last flags for each beat of a read response.
    // The two FIFOs must always be popped together and the ID fifo is always 
    // non-empty if the data fifo is non-empty because of the shorter latency
    //
    typedef struct packed {
        logic [AXI_ID_WIDTH-1:0] id;
        logic last;
    } read_id_fifo_entry_t;

    read_id_fifo_entry_t read_id_fifo_in, read_id_fifo_out;

    assign read_id_fifo_in.id   = read_request_data_out.id;
    assign read_id_fifo_in.last = read_request_free;

    fifo_v3 #(
        .DATA_WIDTH ( $bits(read_id_fifo_entry_t) ),
        .DEPTH      ( SRAM_READ_LATENCY + READ_FIFO_DEPTH    )
    ) read_id_fifo (
        .clk_i(clk_i),
        .rst_ni(rst_ni),

        .flush_i(1'b0),
        .testmode_i(1'b0),

        .full_o(read_id_fifo_full),
        .empty_o(),

        .usage_o(),

        .data_i(read_id_fifo_in),
        .push_i(read_request_tick),

        .data_o(read_id_fifo_out),
        .pop_i(read_id_fifo_pop)
    );

    assign read_id_fifo_pop = axi.r_ready && axi.r_valid;

    assign axi.r_id   = read_id_fifo_out.id;
    assign axi.r_last = read_id_fifo_out.last;

    //
    // Read or write request entry
    //
    typedef struct packed {
        logic [AXI_ADDR_WIDTH-1:0] addr;
        logic [AXI_ID_WIDTH-1:0]   id;
        axi4_pkg::len_t             len;
        axi4_pkg::size_t            size;
        axi4_pkg::burst_t           burst;
    } mem_request_t;

    mem_request_t read_request_data_in, read_request_data_out;

    logic [$clog2(READ_REQUEST_FIFO_DEPTH)-1:0] read_request_fifo_occupancy;

    fifo_v3 #(
        .DATA_WIDTH ( $bits(mem_request_t) ),
        .DEPTH      ( READ_REQUEST_FIFO_DEPTH )
    ) read_request_fifo (
        .clk_i(clk_i),
        .rst_ni(rst_ni),

        .flush_i(1'b0),
        .testmode_i(1'b0),

        .full_o(read_request_fifo_full),
        .empty_o(read_request_fifo_empty),

        .usage_o(read_request_fifo_occupancy),

        .data_i(read_request_data_in),
        .push_i(axi.ar_valid && axi.ar_ready),

        .data_o(read_request_data_out),
        .pop_i(read_request_free)
    );

    mem_request_t write_request_data_in, write_request_data_out;

    logic [$clog2(WRITE_REQUEST_FIFO_DEPTH)-1:0] write_request_fifo_occupany;

    fifo_v3 #(
        .DATA_WIDTH ( $bits(mem_request_t) ),
        .DEPTH      ( WRITE_REQUEST_FIFO_DEPTH )
    ) write_request_fifo (
        .clk_i(clk_i),
        .rst_ni(rst_ni),

        .flush_i(1'b0),
        .testmode_i(1'b0),

        .full_o(write_request_fifo_full),
        .empty_o(write_request_fifo_empty),

        .usage_o(write_request_fifo_occupany),

        .data_i(write_request_data_in),
        .push_i(axi.aw_valid && axi.aw_ready),

        .data_o(write_request_data_out),
        .pop_i(write_request_free)
    );
    //
    // AR channel management
    //
    assign axi.ar_ready = !read_request_fifo_full;
    assign read_request_data_in.addr = axi.ar_addr;
    assign read_request_data_in.id   = axi.ar_id;
    assign read_request_data_in.len  = axi.ar_len;
    assign read_request_data_in.size = axi.ar_size;
    assign read_request_data_in.burst = axi.ar_burst; 

    //
    // AW channel management
    //
    assign axi.aw_ready = !write_request_fifo_full;
    assign write_request_data_in.addr = axi.aw_addr;
    assign write_request_data_in.id   = axi.aw_id;
    assign write_request_data_in.len  = axi.aw_len;
    assign write_request_data_in.size = axi.aw_size;
    assign write_request_data_in.burst = axi.aw_burst; 


    //
    // Write Data Input FIFO
    //
    typedef struct packed {
        logic [AXI_DATA_WIDTH-1:0] data;
        logic [(AXI_DATA_WIDTH/8)-1:0] strb;
    } write_data_fifo_entry_t;

    write_data_fifo_entry_t write_data_fifo_in;
    write_data_fifo_entry_t write_data_fifo_out;

    assign write_data_fifo_in.data = axi.w_data;
    assign write_data_fifo_in.strb = axi.w_strb;

    logic write_data_fifo_empty;

    fifo_v3 #(
        .DATA_WIDTH ( $bits(write_data_fifo_entry_t) ),
        .DEPTH      ( 2                              )
    ) write_data_fifo (
        .clk_i(clk_i),
        .rst_ni(rst_ni),

        .flush_i(1'b0),
        .testmode_i(1'b0),

        .full_o(write_data_fifo_full),
        .empty_o(write_data_fifo_empty),

        .usage_o(),

        .data_i( write_data_fifo_in ),
        .push_i( axi.w_ready && axi.w_valid ),

        .data_o( write_data_fifo_out ),
        .pop_i( write_request_tick )
    );

    assign axi.w_ready = !write_data_fifo_full;

    //
    // Write Response FIFO
    //
    typedef struct packed {
        logic [AXI_ID_WIDTH-1:0] id;
    } write_resp_fifo_entry_t;

    
    fifo_v3 #(
        .DATA_WIDTH ( $bits(write_resp_fifo_entry_t) ),
        .DEPTH      ( 2                              )
    ) write_resp_fifo (
        .clk_i(clk_i),
        .rst_ni(rst_ni),

        .flush_i(1'b0),
        .testmode_i(1'b0),

        .full_o(write_resp_fifo_full),
        .empty_o(write_resp_fifo_empty),

        .usage_o(),

        .data_i( write_request_data_out.id ),
        .push_i( write_request_free ),

        .data_o( axi.b_id ),
        .pop_i( axi.b_ready && axi.b_valid && !(rst_ni==0) )
    );

    assign axi.b_valid = !write_resp_fifo_empty;
    assign axi.b_resp  = axi4_pkg::RESP_OKAY;

    //
    // Burst counter management
    //
    axi4_pkg::len_t burst_counter;

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (rst_ni == 0) begin
            burst_counter <= 0;
        end else begin
            if (write_request_free || read_request_free) begin
                burst_counter <= 0;
            end else if (write_request_tick || read_request_tick) begin
                burst_counter <= burst_counter + 1;
            end
        end
    end

    //
    // Transaction selector
    //
    typedef enum { IDLE, READ, WRITE } state_t;

    state_t state, next_state;

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (rst_ni == 0) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end
 
    logic read_last_beat;
    logic [AXI_ADDR_WIDTH-1:0] transaction_addr;
    logic transaction_valid;
    logic transaction_write;

    always_comb begin 
        next_state = state;

        read_request_tick = 1'b0;
        read_last_beat    = 1'b0;
        read_request_free = 1'b0;

        write_request_tick = 1'b0;
        write_request_free = 1'b0;

        transaction_valid = 1'b0;
        transaction_write = 1'b0;

        transaction_addr  = '0;

        unique case (state)

            IDLE: begin
                if (!read_request_fifo_empty) begin
                    next_state = READ;
                end else if (!write_data_fifo_empty && !write_resp_fifo_full) begin
                    next_state = WRITE;
                end
            end

            READ: begin
                transaction_addr = axi4_pkg::beat_addr(
                    read_request_data_out.addr,
                    read_request_data_out.size,
                    read_request_data_out.len,
                    read_request_data_out.burst,
                    burst_counter );

                // SRAM_READ_LATENCY is taken care of in the FIFO sizing
                transaction_valid = !read_id_fifo_full;

                if (transaction_valid) begin
                    read_request_tick = 1'b1;
                    if (burst_counter == read_request_data_out.len) begin
                        read_last_beat = 1'b1;
                        read_request_free = 1'b1;
                        if (!write_data_fifo_empty && !write_resp_fifo_full) begin
                            next_state = WRITE;
                        end else if (read_request_fifo_occupancy > 1) begin
                            next_state = READ;
                        end else begin
                            next_state = IDLE;
                        end
                    end 
                end
            end

            WRITE: begin
                transaction_addr = axi4_pkg::beat_addr(
                    write_request_data_out.addr,
                    write_request_data_out.size,
                    write_request_data_out.len,
                    write_request_data_out.burst,
                    burst_counter );

                if ( !write_data_fifo_empty ) begin
                    transaction_valid = 1'b1; 
                    write_request_tick = 1'b1;
                    if (burst_counter == write_request_data_out.len) begin
                        write_request_free = 1'b1;
                        if (!read_request_fifo_empty) begin
                            next_state = READ;
                        end else if (write_request_fifo_occupany > 1) begin
                            next_state = WRITE;
                        end else begin
                            next_state = IDLE;
                        end
                    end 
                end
            end

        endcase 
    end

    //
    // Address decoder 
    //
    localparam integer ADDRESS_SHIFT = $clog2(AXI_DATA_WIDTH/8);
    localparam integer BANK_SHIFT    = ADDRESS_SHIFT + $clog2(SRAM_BANKS_ROWS);
    localparam logic [SRAM_BANK_ADDR_WIDTH-1:0] SRAM_BANK_ADDRESS_MASK = 
        ~({SRAM_BANK_ADDR_WIDTH{1'b1}} << $clog2(SRAM_BANKS_ROWS));

    typedef logic [$clog2(SRAM_BANKS_ROWS)-1:0] sram_row_addr_t;

    // Fixed latency pipeline which tracks reads in flight
    sram_row_addr_t [SRAM_READ_LATENCY:0] sram_row_addr_pipe;
    logic [SRAM_READ_LATENCY:0] sram_read_pipe;

    integer row,col;
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (rst_ni == 0) begin
            sram_row_addr_pipe <= 0;
            sram_read_pipe <= 0;
            for(row=0;row<SRAM_BANKS_ROWS;row++) begin      
                for(col=0;col<SRAM_BANKS_COLS;col++) begin
                    bank_cs[row][col] <= 1'b0;
                end
            end
        end else begin

            // Send transactions down the pipeline
            sram_row_addr_pipe[SRAM_READ_LATENCY:1] <= sram_row_addr_pipe[SRAM_READ_LATENCY-1:0];
            sram_read_pipe[SRAM_READ_LATENCY:1]     <= sram_read_pipe[SRAM_READ_LATENCY-1:0];
            sram_read_pipe[0]                       <= read_request_tick;

            if (transaction_valid) begin
                bank_addr <= transaction_addr >> BANK_SHIFT;
            end

            for(row=0;row<SRAM_BANKS_ROWS;row++) begin      
                for(col=0;col<SRAM_BANKS_COLS;col++) begin
                    if (transaction_valid &&
                        ((((transaction_addr >> $clog2(SRAM_BANKS_ROWS)) << $clog2(SRAM_BANKS_ROWS)) | (row << ADDRESS_SHIFT)) == transaction_addr)
                        ) begin
                        bank_cs[row][col] <= 1'b1;
                        bank_we[row][col] <= write_request_tick;
                        if (write_request_tick == 1'b1) begin

                            bank_be[row][col][(SRAM_BANK_DATA_WIDTH/8)-1:0] <= 
                                (write_data_fifo_out.strb >> (col * ($clog2(SRAM_BANK_DATA_WIDTH/8)-1)));
                            bank_wdata[col] <= write_data_fifo_out.data >> (col * SRAM_BANK_DATA_WIDTH);
                        end else begin
                            sram_row_addr_pipe[0] <= row;
                        end
                    end else begin
                        bank_cs[row][col] <= 1'b0;
                    end
                end
            end
        end
    end

    //
    // Read data mux
    //
    logic [(SRAM_BANK_DATA_WIDTH*SRAM_BANKS_COLS)-1:0] read_data_out;

    for(i=0;i<SRAM_BANKS_COLS;i++) begin
        assign read_data_out[SRAM_BANK_DATA_WIDTH*(i+1)-1:SRAM_BANK_DATA_WIDTH*(i)] = bank_rdata[sram_row_addr_pipe[0]][i];
    end

    assign read_data_fifo_push = sram_read_pipe[SRAM_READ_LATENCY];
    assign read_data_fifo_in   = read_data_out;


endmodule