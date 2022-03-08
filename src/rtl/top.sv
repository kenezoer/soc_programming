//|-----------------------------------------------------------------------------------
//| Author:      Kirill Lyubavin (kenezoer@gmail.com)
//| 
//| Module:      top.sv
//| 
//| Purpose:     Top Level for MIET Master's course 
//|                 "Development of SoC with programmable architecture"
//| 
//| Functionality:   
//|      Contains SCR1 RISC-V Core, Generic (inferred) SRAM Memory for CPU (bootrom?)
//|         AXI4-to-APB3 Interconnect
//| 
//|-----------------------------------------------------------------------------------


module top;


    //| Clock and reset generation
    logic   i_clk   = '0;
    logic   i_rst_n = '0;

    logic   uart_rx = '0;
    logic   uart_tx;

    always #10ns   i_clk   = ~i_clk; //| lets imagine frequency of 100 MHz
    always #20ns   i_rst_n = '1;

    always#30us $stop;

    //| BUS Width Parameters
    localparam      //| AXI4
                    AXI4_ADDR_WIDTH     = 32,
                    AXI4_DATA_WIDTH     = 32,
                    AXI4_MID_WIDTH      = 4,
                    AXI4_SID_WIDTH      = 5,
                    AXI4_USER_WIDTH     = 4,

                    //| APB3
                    APB3_ADDR_WIDTH     = 32,
                    APB3_DATA_WIDTH     = 32;

    //|------------------------
    //| Interfaces instances
    //|------------------------
    apb3_if#(
        .APB3_ADDR_WIDTH    ( APB3_ADDR_WIDTH   ),
        .APB3_DATA_WIDTH    ( APB3_DATA_WIDTH   )
    ) APB3 (
        .PCLK               ( i_clk             ),
        .PRESETN            ( i_rst_n           ));

    //| CPU Data Memory AXI4
    axi4_if#(
        .AXI_ADDR_WIDTH     ( AXI4_ADDR_WIDTH   ),
        .AXI_DATA_WIDTH     ( AXI4_DATA_WIDTH   ),
        .AXI_ID_WIDTH       ( AXI4_MID_WIDTH    ),
        .AXI_USER_WIDTH     ( AXI4_USER_WIDTH   )
    ) AXI4_DMEM ();

    //| CPU Instruction Memory AXI4
    axi4_if#(
        .AXI_ADDR_WIDTH     ( AXI4_ADDR_WIDTH   ),
        .AXI_DATA_WIDTH     ( AXI4_DATA_WIDTH   ),
        .AXI_ID_WIDTH       ( AXI4_MID_WIDTH    ),
        .AXI_USER_WIDTH     ( AXI4_USER_WIDTH   )
    ) AXI4_IMEM ();

    //| CPU Instruction Memory AXI4
    axi4_if#(
        .AXI_ADDR_WIDTH     ( AXI4_ADDR_WIDTH   ),
        .AXI_DATA_WIDTH     ( AXI4_DATA_WIDTH   ),
        .AXI_ID_WIDTH       ( AXI4_SID_WIDTH    ),
        .AXI_USER_WIDTH     ( AXI4_USER_WIDTH   )
    ) AXI4_UART ();

    //| AXI to APB3
    axi4_if#(
        .AXI_ADDR_WIDTH     ( AXI4_ADDR_WIDTH   ),
        .AXI_DATA_WIDTH     ( AXI4_DATA_WIDTH   ),
        .AXI_ID_WIDTH       ( AXI4_SID_WIDTH    ),
        .AXI_USER_WIDTH     ( AXI4_USER_WIDTH   )
    ) AXI4_X2P ();

    //| CPU SRAM Memory
    axi4_if#(
        .AXI_ADDR_WIDTH     ( AXI4_ADDR_WIDTH   ),
        .AXI_DATA_WIDTH     ( AXI4_DATA_WIDTH   ),
        .AXI_ID_WIDTH       ( AXI4_SID_WIDTH    ),
        .AXI_USER_WIDTH     ( AXI4_USER_WIDTH   )
    ) AXI4_SRAM ();

    //|------------------------
    //| Internal variables definition
    //|------------------------
    logic       software_irq = 0;



    //|------------------------
    //| Interfaces instances
    //|------------------------
    scr1_wrapper#(
        .AXI_ADDR_WIDTH     ( AXI4_ADDR_WIDTH   ),
        .AXI_DATA_WIDTH     ( AXI4_DATA_WIDTH   ),
        .AXI_ID_WIDTH       ( AXI4_MID_WIDTH    ),
        .AXI_USER_WIDTH     ( AXI4_USER_WIDTH   )
    ) scr1_wrapper (
        .i_clk              ( i_clk             ),
        .i_cpu_rstn         ( i_rst_n           ),
        .i_sw_irq           ( software_irq      ),

        .AXI4_IMEM          ( AXI4_IMEM.Master  ),
        .AXI4_DMEM          ( AXI4_DMEM.Master  ));


    //|------------------------
    //| Simple interconnect
    //| 1 AXI4 -> 2 AXI4
    //|------------------------
    //| X2P BADDR:  32'h0000_0000 (range 1000)
    //| UART BADDR: 32'h0000_1000 (range 1000)
    //| SRAM BADDR: 32'h0010_0000 (range 500000)
    //|------------------------
    miet_interconnect_wrapper
    miet_interconnect_wrapper(

        .i_clk              ( i_clk             ),
        .i_nrst             ( i_rst_n           ),

        .AXI4_DMEM          ( AXI4_DMEM.Slave   ),
        .AXI4_IMEM          ( AXI4_IMEM.Slave   ),

        .AXI4_X2P           ( AXI4_X2P.Master   ),
        .AXI4_UART          ( AXI4_UART.Master  ),
        .AXI4_SRAM          ( AXI4_SRAM.Master  ));

    //|------------------------
    //| Student's module place
    //|------------------------

    APB #(
        .ADDR_WIDTH         ( APB3_ADDR_WIDTH   ),
        .DATA_WIDTH         ( APB3_DATA_WIDTH   )
    ) APB3_sec (
        .PCLK               ( i_clk             ),
        .PRESETn            ( i_rst_n           ));

    APB_slave#(
        .ADDR_WIDTH         ( APB3_ADDR_WIDTH   ),
        .DATA_WIDTH         ( APB3_DATA_WIDTH   )
    ) crc_apb_slave (
        .APB_if             ( APB3_sec.Slave    ));

    always_comb APB3_sec.PADDR      = APB3.PADDR;
    always_comb APB3_sec.PSEL       = APB3.PSEL;
    always_comb APB3_sec.PENABLE    = APB3.PENABLE;
    always_comb APB3_sec.PWRITE     = APB3.PWRITE;
    always_comb APB3_sec.PWDATA     = APB3.PWDATA;

    always_comb APB3.PREADY         = APB3_sec.PREADY;
    always_comb APB3.PSLVERR        = APB3_sec.PSLVERR;
    always_comb APB3.PRDATA         = APB3_sec.PRDATA;

    //|------------------------
    //| DW AXI X2P 
    //|------------------------
    i_axi_x2p_DW_axi_x2p
    DW_axi_x2p(

    // Outputs
        .rdata      ( AXI4_X2P.r_data       ),
        .bresp      ( AXI4_X2P.b_resp       ),
        .rresp      ( AXI4_X2P.r_resp       ),
        .bid        ( AXI4_X2P.b_id         ),
        .rid        ( AXI4_X2P.r_id         ),
        .awready    ( AXI4_X2P.aw_ready     ),
        .wready     ( AXI4_X2P.w_ready      ),
        .bvalid     ( AXI4_X2P.b_valid      ),
        .arready    ( AXI4_X2P.ar_ready     ),
        .rlast      ( AXI4_X2P.r_last       ),
        .rvalid     ( AXI4_X2P.r_valid      ),
        .psel_s0    ( APB3.PSEL             ),
        .paddr      ( APB3.PADDR            ),
        .penable    ( APB3.PENABLE          ),
        .pwdata     ( APB3.PWDATA           ),
        .pwrite     ( APB3.PWRITE           ),
    // Inputs
        .aclk       ( i_clk                 ),
        .aresetn    ( i_rst_n               ),
        .awaddr     ( AXI4_X2P.aw_addr      ),
        .wdata      ( AXI4_X2P.w_data       ),
        .araddr     ( AXI4_X2P.ar_addr      ),
        .awvalid    ( AXI4_X2P.aw_valid     ),
        .arvalid    ( AXI4_X2P.ar_valid     ),
        .wlast      ( AXI4_X2P.w_last       ),
        .wvalid     ( AXI4_X2P.w_valid      ),
        .bready     ( AXI4_X2P.b_ready      ),
        .rready     ( AXI4_X2P.r_ready      ),
        .awburst    ( AXI4_X2P.aw_burst     ),
        .awlock     ( AXI4_X2P.aw_lock      ),
        .arburst    ( AXI4_X2P.ar_burst     ),
        .arlock     ( AXI4_X2P.ar_lock      ),
        .awsize     ( AXI4_X2P.aw_size      ),
        .awprot     ( AXI4_X2P.aw_prot      ),
        .arsize     ( AXI4_X2P.ar_size      ),
        .arprot     ( AXI4_X2P.ar_prot      ),
        .awid       ( AXI4_X2P.aw_id        ),
        .awlen      ( AXI4_X2P.aw_len       ),
        .awcache    ( AXI4_X2P.aw_cache     ),
        .wstrb      ( AXI4_X2P.w_strb       ),
        .arid       ( AXI4_X2P.ar_id        ),
        .arlen      ( AXI4_X2P.ar_len       ),
        .arcache    ( AXI4_X2P.ar_cache     ),
        .prdata_s0  ( APB3.PRDATA           ));

    //|------------------------
    //| AXI4 To memory 
    //|------------------------
    localparam  SRAM_BANKS_ROWS         = 1,
                SRAM_BANKS_COLS         = 1,
                SRAM_BANK_ADDR_WIDTH    = 32,
                SRAM_BANK_DATA_WIDTH    = 32,
                SRAM_READ_LATENCY       = 2;

    logic   [SRAM_BANK_ADDR_WIDTH-1:0]                                                          bank_addr;
    logic   [SRAM_BANKS_ROWS-1:0]       [SRAM_BANKS_COLS-1:0]                                   bank_cs;
    logic   [SRAM_BANKS_ROWS-1:0]       [SRAM_BANKS_COLS-1:0]                                   bank_we;
    logic   [SRAM_BANKS_ROWS-1:0]       [SRAM_BANKS_COLS-1:0]   [(SRAM_BANK_DATA_WIDTH/8)-1:0]  bank_be;
    logic                               [SRAM_BANKS_COLS-1:0]   [SRAM_BANK_DATA_WIDTH-1:0]      bank_wdata;
    logic   [SRAM_BANKS_ROWS-1:0]       [SRAM_BANKS_COLS-1:0]   [SRAM_BANK_DATA_WIDTH-1:0]      bank_rdata;

    logic   [SRAM_BANK_ADDR_WIDTH-1:0]      mem_addr;
    logic   [SRAM_BANK_DATA_WIDTH-1:0]      mem_wdata;
    logic   [SRAM_BANK_DATA_WIDTH-1:0]      mem_rdata;
    logic                                   mem_we;
    logic                                   mem_ce;

    always_comb mem_addr            = bank_addr;
    always_comb mem_wdata           = bank_wdata;
    always_comb bank_rdata          = '0 + mem_rdata;
    always_comb mem_we              = bank_we;
    always_comb mem_ce              = bank_cs;


    axi_sram #(
        .AXI_ADDR_WIDTH         ( AXI4_ADDR_WIDTH       ),
        .AXI_DATA_WIDTH         ( AXI4_DATA_WIDTH       ),
        .AXI_ID_WIDTH           ( AXI4_SID_WIDTH        ),
        .AXI_USER_WIDTH         ( AXI4_USER_WIDTH       ),
        .SRAM_BANKS_ROWS        ( SRAM_BANKS_ROWS       ),
        .SRAM_BANKS_COLS        ( SRAM_BANKS_COLS       ),
        .SRAM_BANK_ADDR_WIDTH   ( SRAM_BANK_ADDR_WIDTH  ),
        .SRAM_BANK_DATA_WIDTH   ( SRAM_BANK_DATA_WIDTH  ),
        .SRAM_READ_LATENCY      ( SRAM_READ_LATENCY     )
    ) axi2mem (
        .clk_i                  ( i_clk                 ),
        .rst_ni                 ( i_rst_n               ),

    // AXI slave interface
        .axi                    ( AXI4_SRAM.Slave       ),

    // SRAM bank interface
        .bank_addr              ( bank_addr             ),
        .bank_cs                ( bank_cs               ),
        .bank_we                ( bank_we               ),
        .bank_be                ( bank_be               ),
        .bank_wdata             ( bank_wdata            ),
        .bank_rdata             ( bank_rdata            ));

    //|------------------------
    //| Generic SRAM Bank
    //|------------------------
    generic_memory#(
        .SRAM_BANK_ADDR_WIDTH   ( 12                    ),
        .SRAM_BANK_DATA_WIDTH   ( SRAM_BANK_DATA_WIDTH  )
    ) generic_memory (
        .i_clk                  ( i_clk                 ),

        .mem_addr               ( mem_addr              ),
        .mem_wdata              ( mem_wdata             ),
        .mem_we                 ( mem_we                ),
        .mem_ce                 ( mem_ce                ),

        .mem_rdata              ( mem_rdata             ));


    //|--------------------------
    //| AXI4 Lite UART
    //|--------------------------
    axiluart #(
        .C_AXI_ADDR_WIDTH       ( AXI4_ADDR_WIDTH       )
    ) axiluart_inst (
        .S_AXI_ACLK             ( i_clk                 ),
        .S_AXI_ARESETN          ( i_rst_n               ),
        .S_AXI_AWVALID          ( AXI4_UART.aw_valid    ),
        .S_AXI_AWREADY          ( AXI4_UART.aw_ready    ),
        .S_AXI_AWADDR           ( AXI4_UART.aw_addr     ),
        .S_AXI_AWPROT           ( AXI4_UART.aw_prot     ),
        .S_AXI_WVALID           ( AXI4_UART.w_valid     ),
        .S_AXI_WREADY           ( AXI4_UART.w_ready     ),
        .S_AXI_WDATA            ( AXI4_UART.w_data      ),
        .S_AXI_WSTRB            ( AXI4_UART.w_strb      ),
        .S_AXI_BVALID           ( AXI4_UART.b_valid     ),
        .S_AXI_BREADY           ( AXI4_UART.b_ready     ),
        .S_AXI_BRESP            ( AXI4_UART.b_resp      ),
        .S_AXI_ARVALID          ( AXI4_UART.ar_valid    ),
        .S_AXI_ARREADY          ( AXI4_UART.ar_ready    ),
        .S_AXI_ARADDR           ( AXI4_UART.ar_addr     ),
        .S_AXI_ARPROT           ( AXI4_UART.ar_prot     ),
        .S_AXI_RVALID           ( AXI4_UART.r_valid     ),
        .S_AXI_RREADY           ( AXI4_UART.r_ready     ),
        .S_AXI_RDATA            ( AXI4_UART.r_data      ),
        .S_AXI_RRESP            ( AXI4_UART.r_resp      ),
        .i_uart_rx              ( uart_rx               ),
        .o_uart_tx              ( uart_tx               ),
        .i_cts_n                ( '0                    ),
        .o_rts_n                ( /* not used */        ),
        .o_uart_rx_int          ( /* not used */        ),
        .o_uart_tx_int          ( /* not used */        ),
        .o_uart_rxfifo_int      ( /* not used */        ),
        .o_uart_txfifo_int      ( /* not used */        ));

    // uart_sim_rx #(
    //     .UART_CLK_HPER          ( 10ns                  )
    // ) uart_sim_log (
    //     .i_rst_n                ( i_rst_n               ),
    //     .i_uart_rx              ( uart_tx               ));

endmodule : top