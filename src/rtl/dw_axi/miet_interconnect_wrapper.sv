//|-----------------------------------------------------------------------------------
//| Author:      Kirill Lyubavin (kenezoer@gmail.com)
//| 
//| Module:      miet_interconnect_wrapper.sv
//| 
//| Purpose:     Wrapper for synthesis DW_axi (coreAssembler DW AXI 4.04a)
//| 
//| Functionality:   
//|      Simple wrapper :L
//| 
//|-----------------------------------------------------------------------------------

module miet_interconnect_wrapper(

    input                   i_clk,
    input                   i_nrst,


    axi4_if.Slave           AXI4_DMEM,

    axi4_if.Master          AXI4_X2P,
    axi4_if.Master          AXI4_UART
);


    miet_dw_axi
    miet_dw_axi(
        .AXI4_ACLK_aclk                 ( i_clk                 ),
        .AXI4_ARESETn_aresetn           ( i_nrst                ),

        .AXI4_DMEM_araddr               ( AXI4_DMEM.ar_addr     ),
        .AXI4_DMEM_arburst              ( AXI4_DMEM.ar_burst    ),
        .AXI4_DMEM_arcache              ( AXI4_DMEM.ar_cache    ),
        .AXI4_DMEM_arid                 ( AXI4_DMEM.ar_id       ),
        .AXI4_DMEM_arlen                ( AXI4_DMEM.ar_len      ),
        .AXI4_DMEM_arlock               ( AXI4_DMEM.ar_lock     ),
        .AXI4_DMEM_arprot               ( AXI4_DMEM.ar_prot     ),
        .AXI4_DMEM_arsize               ( AXI4_DMEM.ar_size     ),
        .AXI4_DMEM_arvalid              ( AXI4_DMEM.ar_valid    ),
        .AXI4_DMEM_awaddr               ( AXI4_DMEM.aw_addr     ),
        .AXI4_DMEM_awburst              ( AXI4_DMEM.aw_burst    ),
        .AXI4_DMEM_awcache              ( AXI4_DMEM.aw_cache    ),
        .AXI4_DMEM_awid                 ( AXI4_DMEM.aw_id       ),
        .AXI4_DMEM_awlen                ( AXI4_DMEM.aw_len      ),
        .AXI4_DMEM_awlock               ( AXI4_DMEM.aw_lock     ),
        .AXI4_DMEM_awprot               ( AXI4_DMEM.aw_prot     ),
        .AXI4_DMEM_awsize               ( AXI4_DMEM.aw_size     ),
        .AXI4_DMEM_awvalid              ( AXI4_DMEM.aw_valid    ),
        .AXI4_DMEM_bready               ( AXI4_DMEM.b_ready     ),
        .AXI4_DMEM_rready               ( AXI4_DMEM.r_ready     ),
        .AXI4_DMEM_wdata                ( AXI4_DMEM.w_data      ),
        .AXI4_DMEM_wlast                ( AXI4_DMEM.w_last      ),
        .AXI4_DMEM_wstrb                ( AXI4_DMEM.w_strb      ),
        .AXI4_DMEM_wvalid               ( AXI4_DMEM.w_valid     ),
        .AXI4_DMEM_arready              ( AXI4_DMEM.ar_ready    ),
        .AXI4_DMEM_awready              ( AXI4_DMEM.aw_ready    ),
        .AXI4_DMEM_bid                  ( AXI4_DMEM.b_id        ),
        .AXI4_DMEM_bresp                ( AXI4_DMEM.b_resp      ),
        .AXI4_DMEM_bvalid               ( AXI4_DMEM.b_valid     ),
        .AXI4_DMEM_rdata                ( AXI4_DMEM.r_data      ),
        .AXI4_DMEM_rid                  ( AXI4_DMEM.r_id        ),
        .AXI4_DMEM_rlast                ( AXI4_DMEM.r_last      ),
        .AXI4_DMEM_rresp                ( AXI4_DMEM.r_resp      ),
        .AXI4_DMEM_rvalid               ( AXI4_DMEM.r_valid     ),
        .AXI4_DMEM_wready               ( AXI4_DMEM.w_ready     ),

        .AXI4_S1_X2P_arready            ( AXI4_X2P.ar_ready     ),
        .AXI4_S1_X2P_awready            ( AXI4_X2P.aw_ready     ),
        .AXI4_S1_X2P_bid                ( AXI4_X2P.b_id         ),
        .AXI4_S1_X2P_bresp              ( AXI4_X2P.b_resp       ),
        .AXI4_S1_X2P_bvalid             ( AXI4_X2P.b_valid      ),
        .AXI4_S1_X2P_rdata              ( AXI4_X2P.r_data       ),
        .AXI4_S1_X2P_rid                ( AXI4_X2P.r_id         ),
        .AXI4_S1_X2P_rlast              ( AXI4_X2P.r_last       ),
        .AXI4_S1_X2P_rresp              ( AXI4_X2P.r_resp       ),
        .AXI4_S1_X2P_rvalid             ( AXI4_X2P.r_valid      ),
        .AXI4_S1_X2P_wready             ( AXI4_X2P.w_ready      ),
        .AXI4_S1_X2P_araddr             ( AXI4_X2P.ar_addr      ),
        .AXI4_S1_X2P_arburst            ( AXI4_X2P.ar_burst     ),
        .AXI4_S1_X2P_arcache            ( AXI4_X2P.ar_cache     ),
        .AXI4_S1_X2P_arid               ( AXI4_X2P.ar_id        ),
        .AXI4_S1_X2P_arlen              ( AXI4_X2P.ar_len       ),
        .AXI4_S1_X2P_arlock             ( AXI4_X2P.ar_lock      ),
        .AXI4_S1_X2P_arprot             ( AXI4_X2P.ar_prot      ),
        .AXI4_S1_X2P_arsize             ( AXI4_X2P.ar_size      ),
        .AXI4_S1_X2P_arvalid            ( AXI4_X2P.ar_valid     ),
        .AXI4_S1_X2P_awaddr             ( AXI4_X2P.aw_addr      ),
        .AXI4_S1_X2P_awburst            ( AXI4_X2P.aw_burst     ),
        .AXI4_S1_X2P_awcache            ( AXI4_X2P.aw_cache     ),
        .AXI4_S1_X2P_awid               ( AXI4_X2P.aw_id        ),
        .AXI4_S1_X2P_awlen              ( AXI4_X2P.aw_len       ),
        .AXI4_S1_X2P_awlock             ( AXI4_X2P.aw_lock      ),
        .AXI4_S1_X2P_awprot             ( AXI4_X2P.aw_prot      ),
        .AXI4_S1_X2P_awsize             ( AXI4_X2P.aw_size      ),
        .AXI4_S1_X2P_awvalid            ( AXI4_X2P.aw_valid     ),
        .AXI4_S1_X2P_bready             ( AXI4_X2P.b_ready      ),
        .AXI4_S1_X2P_rready             ( AXI4_X2P.r_ready      ),
        .AXI4_S1_X2P_wdata              ( AXI4_X2P.w_data       ),
        .AXI4_S1_X2P_wlast              ( AXI4_X2P.w_last       ),
        .AXI4_S1_X2P_wstrb              ( AXI4_X2P.w_strb       ),
        .AXI4_S1_X2P_wvalid             ( AXI4_X2P.w_valid      ),

        .AXI4_S2_UART_arready           ( AXI4_UART.ar_ready    ),
        .AXI4_S2_UART_awready           ( AXI4_UART.aw_ready    ),
        .AXI4_S2_UART_bid               ( AXI4_UART.b_id        ),
        .AXI4_S2_UART_bresp             ( AXI4_UART.b_resp      ),
        .AXI4_S2_UART_bvalid            ( AXI4_UART.b_valid     ),
        .AXI4_S2_UART_rdata             ( AXI4_UART.r_data      ),
        .AXI4_S2_UART_rid               ( AXI4_UART.r_id        ),
        .AXI4_S2_UART_rlast             ( AXI4_UART.r_last      ),
        .AXI4_S2_UART_rresp             ( AXI4_UART.r_resp      ),
        .AXI4_S2_UART_rvalid            ( AXI4_UART.r_valid     ),
        .AXI4_S2_UART_wready            ( AXI4_UART.w_ready     ),
        .AXI4_S2_UART_araddr            ( AXI4_UART.ar_addr     ),
        .AXI4_S2_UART_arburst           ( AXI4_UART.ar_burst    ),
        .AXI4_S2_UART_arcache           ( AXI4_UART.ar_cache    ),
        .AXI4_S2_UART_arid              ( AXI4_UART.ar_id       ),
        .AXI4_S2_UART_arlen             ( AXI4_UART.ar_len      ),
        .AXI4_S2_UART_arlock            ( AXI4_UART.ar_lock     ),
        .AXI4_S2_UART_arprot            ( AXI4_UART.ar_prot     ),
        .AXI4_S2_UART_arsize            ( AXI4_UART.ar_size     ),
        .AXI4_S2_UART_arvalid           ( AXI4_UART.ar_valid    ),
        .AXI4_S2_UART_awaddr            ( AXI4_UART.aw_addr     ),
        .AXI4_S2_UART_awburst           ( AXI4_UART.aw_burst    ),
        .AXI4_S2_UART_awcache           ( AXI4_UART.aw_cache    ),
        .AXI4_S2_UART_awid              ( AXI4_UART.aw_id       ),
        .AXI4_S2_UART_awlen             ( AXI4_UART.aw_len      ),
        .AXI4_S2_UART_awlock            ( AXI4_UART.aw_lock     ),
        .AXI4_S2_UART_awprot            ( AXI4_UART.aw_prot     ),
        .AXI4_S2_UART_awsize            ( AXI4_UART.aw_size     ),
        .AXI4_S2_UART_awvalid           ( AXI4_UART.aw_valid    ),
        .AXI4_S2_UART_bready            ( AXI4_UART.b_ready     ),
        .AXI4_S2_UART_rready            ( AXI4_UART.r_ready     ),
        .AXI4_S2_UART_wdata             ( AXI4_UART.w_data      ),
        .AXI4_S2_UART_wlast             ( AXI4_UART.w_last      ),
        .AXI4_S2_UART_wstrb             ( AXI4_UART.w_strb      ),
        .AXI4_S2_UART_wvalid            ( AXI4_UART.w_valid     ),

        .miet_dw_axi_ic_dbg_araddr_s0   ( /* not used */        ),
        .miet_dw_axi_ic_dbg_arburst_s0  ( /* not used */        ),
        .miet_dw_axi_ic_dbg_arcache_s0  ( /* not used */        ),
        .miet_dw_axi_ic_dbg_arid_s0     ( /* not used */        ),
        .miet_dw_axi_ic_dbg_arlen_s0    ( /* not used */        ),
        .miet_dw_axi_ic_dbg_arlock_s0   ( /* not used */        ),
        .miet_dw_axi_ic_dbg_arprot_s0   ( /* not used */        ),
        .miet_dw_axi_ic_dbg_arready_s0  ( /* not used */        ),
        .miet_dw_axi_ic_dbg_arsize_s0   ( /* not used */        ),
        .miet_dw_axi_ic_dbg_arvalid_s0  ( /* not used */        ),
        .miet_dw_axi_ic_dbg_awaddr_s0   ( /* not used */        ),
        .miet_dw_axi_ic_dbg_awburst_s0  ( /* not used */        ),
        .miet_dw_axi_ic_dbg_awcache_s0  ( /* not used */        ),
        .miet_dw_axi_ic_dbg_awid_s0     ( /* not used */        ),
        .miet_dw_axi_ic_dbg_awlen_s0    ( /* not used */        ),
        .miet_dw_axi_ic_dbg_awlock_s0   ( /* not used */        ),
        .miet_dw_axi_ic_dbg_awprot_s0   ( /* not used */        ),
        .miet_dw_axi_ic_dbg_awready_s0  ( /* not used */        ),
        .miet_dw_axi_ic_dbg_awsize_s0   ( /* not used */        ),
        .miet_dw_axi_ic_dbg_awvalid_s0  ( /* not used */        ),
        .miet_dw_axi_ic_dbg_bid_s0      ( /* not used */        ),
        .miet_dw_axi_ic_dbg_bready_s0   ( /* not used */        ),
        .miet_dw_axi_ic_dbg_bresp_s0    ( /* not used */        ),
        .miet_dw_axi_ic_dbg_bvalid_s0   ( /* not used */        ),
        .miet_dw_axi_ic_dbg_rdata_s0    ( /* not used */        ),
        .miet_dw_axi_ic_dbg_rid_s0      ( /* not used */        ),
        .miet_dw_axi_ic_dbg_rlast_s0    ( /* not used */        ),
        .miet_dw_axi_ic_dbg_rready_s0   ( /* not used */        ),
        .miet_dw_axi_ic_dbg_rresp_s0    ( /* not used */        ),
        .miet_dw_axi_ic_dbg_rvalid_s0   ( /* not used */        ),
        .miet_dw_axi_ic_dbg_wdata_s0    ( /* not used */        ),
        .miet_dw_axi_ic_dbg_wid_s0      ( /* not used */        ),
        .miet_dw_axi_ic_dbg_wlast_s0    ( /* not used */        ),
        .miet_dw_axi_ic_dbg_wready_s0   ( /* not used */        ),
        .miet_dw_axi_ic_dbg_wstrb_s0    ( /* not used */        ),
        .miet_dw_axi_ic_dbg_wvalid_s0   ( /* not used */        ));


endmodule : miet_interconnect_wrapper