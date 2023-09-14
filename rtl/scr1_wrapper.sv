//|-----------------------------------------------------------------------------------
//| Author:      Kirill Lyubavin (kenezoer@gmail.com)
//| 
//| Module:      scr1_wrapper.sv
//| 
//| Purpose:     Wrapper for SCR1 Core
//| 
//| Functionality:   
//|      Translates inferred axi4 signals into AXI4 SV Interface
//| 
//|-----------------------------------------------------------------------------------


module scr1_wrapper
//|---------- Required packages -----------
import  axi4_pkg::*;
//|----------------------------------------
#(
    parameter           AXI_ADDR_WIDTH = 0,
    parameter           AXI_DATA_WIDTH = 0,
    parameter           AXI_ID_WIDTH   = 0,
    parameter           AXI_USER_WIDTH = 0
)(
    input               i_clk,
    input               i_cpu_rstn,
    input               i_sw_irq,

    axi4_if.Master      AXI4_IMEM,
    axi4_if.Master      AXI4_DMEM
);


    //|-------------------------------
    //| SCR1 Top module
    //|-------------------------------
    scr1_top_axi SCR1 (
        .pwrup_rst_n            ( i_cpu_rstn            ),
        .rst_n                  ( i_cpu_rstn            ),
        .cpu_rst_n              ( i_cpu_rstn            ),
        .test_mode              ( 1'b0                  ),
        .test_rst_n             ( 1'b1                  ),
        .clk                    ( i_clk                 ),
        .rtc_clk                ( i_clk                 ),
        .fuse_mhartid           ( '0                    ),
        // .ext_irq                ( '0                    ),
        .soft_irq               ( i_sw_irq              ),

        .fuse_idcode            ( '0                    ),
        .irq_lines              ( '0                    ),
        .trst_n                 ( '0                    ),
        .tck                    ( '0                    ),
        .tms                    ( '0                    ),
        .tdi                    ( '0                    ),

        .sys_rst_n_o            (                       ),
        .sys_rdc_qlfy_o         (                       ),
        .tdo                    (                       ),
        .tdo_en                 (                       ),

    //| Instruction MEMORY
        .io_axi_imem_awid       ( AXI4_IMEM.aw_id       ),
        .io_axi_imem_awaddr     ( AXI4_IMEM.aw_addr     ),
        .io_axi_imem_awlen      ( AXI4_IMEM.aw_len      ),
        .io_axi_imem_awsize     ( AXI4_IMEM.aw_size     ),
        .io_axi_imem_awburst    ( AXI4_IMEM.aw_burst    ),
        .io_axi_imem_awlock     ( AXI4_IMEM.aw_lock     ),
        .io_axi_imem_awcache    ( AXI4_IMEM.aw_cache    ),
        .io_axi_imem_awprot     ( AXI4_IMEM.aw_prot     ),
        .io_axi_imem_awregion   ( AXI4_IMEM.aw_region   ),
        .io_axi_imem_awuser     ( AXI4_IMEM.aw_user     ),
        .io_axi_imem_awqos      ( AXI4_IMEM.aw_qos      ),
        .io_axi_imem_awvalid    ( AXI4_IMEM.aw_valid    ),
        .io_axi_imem_awready    ( AXI4_IMEM.aw_ready    ),

        .io_axi_imem_wdata      ( AXI4_IMEM.w_data      ),
        .io_axi_imem_wstrb      ( AXI4_IMEM.w_strb      ),
        .io_axi_imem_wlast      ( AXI4_IMEM.w_last      ),
        .io_axi_imem_wuser      ( AXI4_IMEM.w_user      ),
        .io_axi_imem_wvalid     ( AXI4_IMEM.w_valid     ),
        .io_axi_imem_wready     ( AXI4_IMEM.w_ready     ),

        .io_axi_imem_bid        ( AXI4_IMEM.b_id        ),
        .io_axi_imem_bresp      ( AXI4_IMEM.b_resp      ),
        .io_axi_imem_bvalid     ( AXI4_IMEM.b_valid     ),
        .io_axi_imem_buser      ( AXI4_IMEM.b_user      ),
        .io_axi_imem_bready     ( AXI4_IMEM.b_ready     ),

        .io_axi_imem_arid       ( AXI4_IMEM.ar_id       ),
        .io_axi_imem_araddr     ( AXI4_IMEM.ar_addr     ),
        .io_axi_imem_arlen      ( AXI4_IMEM.ar_len      ),
        .io_axi_imem_arsize     ( AXI4_IMEM.ar_size     ),
        .io_axi_imem_arburst    ( AXI4_IMEM.ar_burst    ),
        .io_axi_imem_arlock     ( AXI4_IMEM.ar_lock     ),
        .io_axi_imem_arcache    ( AXI4_IMEM.ar_cache    ),
        .io_axi_imem_arprot     ( AXI4_IMEM.ar_prot     ),
        .io_axi_imem_arregion   ( AXI4_IMEM.ar_region   ),
        .io_axi_imem_aruser     ( AXI4_IMEM.ar_user     ),
        .io_axi_imem_arqos      ( AXI4_IMEM.ar_qos      ),
        .io_axi_imem_arvalid    ( AXI4_IMEM.ar_valid    ),
        .io_axi_imem_arready    ( AXI4_IMEM.ar_ready    ),

        .io_axi_imem_rid        ( AXI4_IMEM.r_id        ),
        .io_axi_imem_rdata      ( AXI4_IMEM.r_data      ),
        .io_axi_imem_rresp      ( AXI4_IMEM.r_resp      ),
        .io_axi_imem_rlast      ( AXI4_IMEM.r_last      ),
        .io_axi_imem_ruser      ( AXI4_IMEM.r_user      ),
        .io_axi_imem_rvalid     ( AXI4_IMEM.r_valid     ),
        .io_axi_imem_rready     ( AXI4_IMEM.r_ready     ),

    //| DATA MEMORY
        .io_axi_dmem_awid       ( AXI4_DMEM.aw_id       ),
        .io_axi_dmem_awaddr     ( AXI4_DMEM.aw_addr     ),
        .io_axi_dmem_awlen      ( AXI4_DMEM.aw_len      ),
        .io_axi_dmem_awsize     ( AXI4_DMEM.aw_size     ),
        .io_axi_dmem_awburst    ( AXI4_DMEM.aw_burst    ),
        .io_axi_dmem_awlock     ( AXI4_DMEM.aw_lock     ),
        .io_axi_dmem_awcache    ( AXI4_DMEM.aw_cache    ),
        .io_axi_dmem_awprot     ( AXI4_DMEM.aw_prot     ),
        .io_axi_dmem_awregion   ( AXI4_DMEM.aw_region   ),
        .io_axi_dmem_awuser     ( AXI4_DMEM.aw_user     ),
        .io_axi_dmem_awqos      ( AXI4_DMEM.aw_qos      ),
        .io_axi_dmem_awvalid    ( AXI4_DMEM.aw_valid    ),
        .io_axi_dmem_awready    ( AXI4_DMEM.aw_ready    ),

        .io_axi_dmem_wdata      ( AXI4_DMEM.w_data      ),
        .io_axi_dmem_wstrb      ( AXI4_DMEM.w_strb      ),
        .io_axi_dmem_wlast      ( AXI4_DMEM.w_last      ),
        .io_axi_dmem_wuser      ( AXI4_DMEM.w_user      ),
        .io_axi_dmem_wvalid     ( AXI4_DMEM.w_valid     ),
        .io_axi_dmem_wready     ( AXI4_DMEM.w_ready     ),

        .io_axi_dmem_bid        ( AXI4_DMEM.b_id        ),
        .io_axi_dmem_bresp      ( AXI4_DMEM.b_resp      ),
        .io_axi_dmem_bvalid     ( AXI4_DMEM.b_valid     ),
        .io_axi_dmem_buser      ( AXI4_DMEM.b_user      ),
        .io_axi_dmem_bready     ( AXI4_DMEM.b_ready     ),

        .io_axi_dmem_arid       ( AXI4_DMEM.ar_id       ),
        .io_axi_dmem_araddr     ( AXI4_DMEM.ar_addr     ),
        .io_axi_dmem_arlen      ( AXI4_DMEM.ar_len      ),
        .io_axi_dmem_arsize     ( AXI4_DMEM.ar_size     ),
        .io_axi_dmem_arburst    ( AXI4_DMEM.ar_burst    ),
        .io_axi_dmem_arlock     ( AXI4_DMEM.ar_lock     ),
        .io_axi_dmem_arcache    ( AXI4_DMEM.ar_cache    ),
        .io_axi_dmem_arprot     ( AXI4_DMEM.ar_prot     ),
        .io_axi_dmem_arregion   ( AXI4_DMEM.ar_region   ),
        .io_axi_dmem_aruser     ( AXI4_DMEM.ar_user     ),
        .io_axi_dmem_arqos      ( AXI4_DMEM.ar_qos      ),
        .io_axi_dmem_arvalid    ( AXI4_DMEM.ar_valid    ),
        .io_axi_dmem_arready    ( AXI4_DMEM.ar_ready    ),

        .io_axi_dmem_rid        ( AXI4_DMEM.r_id        ),
        .io_axi_dmem_rdata      ( AXI4_DMEM.r_data      ),
        .io_axi_dmem_rresp      ( AXI4_DMEM.r_resp      ),
        .io_axi_dmem_rlast      ( AXI4_DMEM.r_last      ),
        .io_axi_dmem_ruser      ( AXI4_DMEM.r_user      ),
        .io_axi_dmem_rvalid     ( AXI4_DMEM.r_valid     ),
        .io_axi_dmem_rready     ( AXI4_DMEM.r_ready     ));

endmodule : scr1_wrapper