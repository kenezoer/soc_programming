//|-----------------------------------------------------------------------------------
//|
//| Author:      Kirill Lyubavin (kenezoer@gmail.com)
//| 
//| Module:      top.sv
//| 
//| Purpose:     Top Level for MIET Master's course 
//|                 "Development of SoC with programmable architecture"
//| 
//| Functionality:   
//|      Contains Syntacore's SCR1 RISC-V Core, 
//|         Generic (inferred) SRAM Memory for CPU, AXI4-to-APB3 Interconnect
//| 
//|-----------------------------------------------------------------------------------


module top;

    //| Clock and reset generation
    logic   i_clk   = '0;
    logic   i_rst_n = '0;

    logic   uart_rx = '0;
    logic   uart_tx;
    logic   uart_cts;
    logic   uart_irq;

    always #10ns   i_clk   = ~i_clk; //| lets imagine frequency of 50 MHz
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


    localparam string PROGRAMM_FILE = "../../software/user_programm/build/user_programm2.hex";

    //|------------------------
    //| Interfaces instances
    //|------------------------
    apb3_if#(
        .APB3_ADDR_WIDTH    ( APB3_ADDR_WIDTH   ),
        .APB3_DATA_WIDTH    ( APB3_DATA_WIDTH   )
    ) APB3_UART (
        .PCLK               ( i_clk             ),
        .PRESETN            ( i_rst_n           ));

    apb3_if#(
        .APB3_ADDR_WIDTH    ( APB3_ADDR_WIDTH   ),
        .APB3_DATA_WIDTH    ( APB3_DATA_WIDTH   )
    ) APB3_USER (
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
    /*
     *  Device   | Address       | Size      | Size (bytes)
     *  -------------------------------------------------------
     *  SRAM     | 0x0           | 0x10000   | 64K
     *  UART     | 0x10000       | 0x1000    | 4K
     *  USER_MOD | 0x11000       | 0x1000    | 4K
     *  -------------------------------------------------------
     */

    miet_interconnect_wrapper
    miet_interconnect_wrapper(

        .i_clk              ( i_clk             ),
        .i_nrst             ( i_rst_n           ),

        .AXI4_DMEM          ( AXI4_DMEM.Slave   ),
        .AXI4_IMEM          ( AXI4_IMEM.Slave   ),

        .AXI4_X2P           ( AXI4_X2P.Master   ),
        .AXI4_SRAM          ( AXI4_SRAM.Master  ));

    //|------------------------
    //| Student's module place
    //|------------------------


    //| !!!!!!!!!!!!!!!!!!!
    //| !!!!!!!!!!!!!!!!!!!
    //| !!!!!!!!!!!!!!!!!!!
    //| !!!!!!!!!!!!!!!!!!!
    //| PUT YOUR MODULE HERE
    //| !!!!!!!!!!!!!!!!!!!
    //| !!!!!!!!!!!!!!!!!!!
    //| !!!!!!!!!!!!!!!!!!!
    //| !!!!!!!!!!!!!!!!!!!
    //| !!!!!!!!!!!!!!!!!!!

    //|------------------------
    //| DW AXI X2P 
    //|------------------------
    miet_dw_x2p_DW_axi_x2p
    DW_axi_x2p(
        .aclk       ( i_clk                 ),
        .aresetn    ( i_rst_n               ),

        //| AXI4
        .awaddr     ( AXI4_X2P.aw_addr      ),
        .awvalid    ( AXI4_X2P.aw_valid     ),
        .awready    ( AXI4_X2P.aw_ready     ),
        .awburst    ( AXI4_X2P.aw_burst     ),
        .awlock     ( AXI4_X2P.aw_lock      ),
        .awsize     ( AXI4_X2P.aw_size      ),
        .awprot     ( AXI4_X2P.aw_prot      ),
        .awid       ( AXI4_X2P.aw_id        ),
        .awlen      ( AXI4_X2P.aw_len       ),
        .awcache    ( AXI4_X2P.aw_cache     ),
        .wdata      ( AXI4_X2P.w_data       ),
        .wlast      ( AXI4_X2P.w_last       ),
        .wvalid     ( AXI4_X2P.w_valid      ),
        .wstrb      ( AXI4_X2P.w_strb       ),
        .wready     ( AXI4_X2P.w_ready      ),
        .bid        ( AXI4_X2P.b_id         ),
        .bready     ( AXI4_X2P.b_ready      ),
        .bresp      ( AXI4_X2P.b_resp       ),
        .bvalid     ( AXI4_X2P.b_valid      ),

        .araddr     ( AXI4_X2P.ar_addr      ),
        .arvalid    ( AXI4_X2P.ar_valid     ),
        .arburst    ( AXI4_X2P.ar_burst     ),
        .arlock     ( AXI4_X2P.ar_lock      ),
        .arsize     ( AXI4_X2P.ar_size      ),
        .arprot     ( AXI4_X2P.ar_prot      ),
        .arid       ( AXI4_X2P.ar_id        ),
        .arlen      ( AXI4_X2P.ar_len       ),
        .arcache    ( AXI4_X2P.ar_cache     ),
        .arready    ( AXI4_X2P.ar_ready     ),
        .rdata      ( AXI4_X2P.r_data       ),
        .rresp      ( AXI4_X2P.r_resp       ),
        .rid        ( AXI4_X2P.r_id         ),
        .rlast      ( AXI4_X2P.r_last       ),
        .rvalid     ( AXI4_X2P.r_valid      ),
        .rready     ( AXI4_X2P.r_ready      ),

    //| APBs
        .paddr      ( APB3_UART.PADDR       ),
        .penable    ( APB3_UART.PENABLE     ),
        .pwdata     ( APB3_UART.PWDATA      ),
        .pwrite     ( APB3_UART.PWRITE      ),
        .prdata_s0  ( APB3_UART.PRDATA      ),
        .psel_s0    ( APB3_UART.PSEL        ),
        .pslverr_s0 ( APB3_UART.PSLVERR     ),
        .pready_s0  ( APB3_UART.PREADY      ),
        .psel_s1    ( APB3_USER.PSEL        ),
        .pslverr_s1 ( APB3_USER.PSLVERR     ),
        .pready_s1  ( APB3_USER.PREADY      ),
        .prdata_s1  ( APB3_USER.PRDATA      ));

    always_comb APB3_USER.PADDR     = APB3_UART.PADDR;
    always_comb APB3_USER.PENABLE   = APB3_UART.PENABLE;
    always_comb APB3_USER.PWDATA    = APB3_UART.PWDATA;
    always_comb APB3_USER.PWRITE    = APB3_UART.PWRITE;

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
    generic_memory #(
        .SRAM_BANK_ADDR_WIDTH   ( 12                    ),
        .SRAM_BANK_DATA_WIDTH   ( SRAM_BANK_DATA_WIDTH  ),
        .INIT_FILE              ( PROGRAMM_FILE         )
    ) generic_memory (
        .i_clk                  ( i_clk                 ),

        .mem_addr               ( mem_addr[11:0]        ),
        .mem_wdata              ( mem_wdata             ),
        .mem_we                 ( mem_we                ),
        .mem_ce                 ( mem_ce                ),

        .mem_rdata              ( mem_rdata             ));


    //|--------------------------
    //| YetAnotherUART
    //|--------------------------

    uart_top #(

        .APB_ADDR_WIDTH             ( APB3_ADDR_WIDTH   ),
        .APB_DATA_WIDTH             ( APB3_DATA_WIDTH   ),
        .FIFO_PARITY_CHECK_EN       ( 0                 )

    ) UART_INST (

    //| APB3 Interface Signals
        .i_apb_pclk                 ( APB3_UART.PCLK    ),
        .i_apb_presetn              ( APB3_UART.PRESETN ),

        .i_apb_paddr                ( APB3_UART.PADDR   ),
        .i_apb_pwdata               ( APB3_UART.PWDATA  ),
        .i_apb_pwrite               ( APB3_UART.PWRITE  ),
        .i_apb_psel                 ( APB3_UART.PSEL    ),
        .i_apb_penable              ( APB3_UART.PENABLE ),
    
        .o_apb_pslverr              ( APB3_UART.PSLVERR ),
        .o_apb_prdata               ( APB3_UART.PRDATA  ),
        .o_apb_pready               ( APB3_UART.PREADY  ),

    //| UART Signals
        .o_tx                       ( uart_tx           ),
        .i_rx                       ( uart_rx           ),

        .o_rts                      ( uart_rts          ),
        .i_cts                      ( uart_rts          ),

    //| Misc
        .o_irq                      ( uart_irq          ));


endmodule : top