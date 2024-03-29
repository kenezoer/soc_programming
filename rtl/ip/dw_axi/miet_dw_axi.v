
module miet_dw_axi (// Ports for Interface AXI4_ACLK
                    AXI4_ACLK_aclk, // AXI clock signal.
                    // Ports for Interface AXI4_ARESETn
                    AXI4_ARESETn_aresetn, // AXI reset signal (low active).
                    // Ports for Interface AXI4_DMEM
                    // Read address.
                    // The read address bus gives the initial address of a read burst 
                    // transaction. Only the start address of the burst is provided 
                    // and the control signals that are issued alongside the address
                    // detail how the address is calculated for the remaining transfers
                    // in the burst.
                    AXI4_DMEM_araddr,
                    // Burst type.
                    // The burst type, coupled with the size information, details how 
                    // the address for each transfer within the burst is calculated.
                    AXI4_DMEM_arburst,
                    // Cache type.
                    // This signal provides additional information about the cacheable
                    // characteristics of the transfer.
                    AXI4_DMEM_arcache,
                    // Read address ID.
                    // This signal is the identification tag for the read address group of
                    // signals.
                    AXI4_DMEM_arid,
                    // Burst length.
                    // The burst length gives the exact number of transfers in a burst.
                    // This information determines the number of data transfers
                    // associated with the address.
                    AXI4_DMEM_arlen,
                    // Lock type.
                    // This signal provides additional information about the atomic
                    // characteristics of the transfer.
                    AXI4_DMEM_arlock,
                    // Protection type.
                    // This signal provides protection unit information for the transaction.
                    AXI4_DMEM_arprot,
                    // Burst size.
                    // This signal indicates the size of each transfer in the burst.
                    AXI4_DMEM_arsize,
                    // Read address valid.
                    // This signal indicates, when HIGH, that the read address and control
                    // information is valid and will remain stable until the address 
                    // acknowledge signal, ARREADY, is high.
                    //     1 = address and control information valid
                    //     0 = address and control information not valid.
                    AXI4_DMEM_arvalid,
                    // Write address. 
                    // The write address bus gives the address of the first transfer in a 
                    // write burst transaction. The associated control signals are used to 
                    // determine the addresses of the remaining transfers in the burst.
                    AXI4_DMEM_awaddr,
                    // Burst type. 
                    // The burst type, coupled with the size information, details how
                    // the address for each transfer within the burst is calculated.
                    AXI4_DMEM_awburst,
                    // Cache type. 
                    // This signal indicates the bufferable, cacheable, write-through,
                    // write-back, and allocate attributes of the transaction.
                    AXI4_DMEM_awcache,
                    // Write address ID. 
                    // This signal is the identification tag for the write address group of signals.
                    AXI4_DMEM_awid,
                    // Burst length. 
                    // The burst length gives the exact number of transfers in a burst.
                    // This information determines the number of data transfers associated
                    // with the address.
                    AXI4_DMEM_awlen,
                    // Lock type. 
                    // This signal provides additional information about the atomic
                    // characteristics of the transfer.
                    AXI4_DMEM_awlock,
                    // Protection type. 
                    // This signal indicates the normal, privileged, or secure
                    // protection level of the transaction and whether the
                    // transaction is a data access or an instruction access.
                    AXI4_DMEM_awprot,
                    // Burst size. 
                    // This signal indicates the size of each transfer in the burst.
                    // Byte lane strobes indicate exactly which byte lanes to update.
                    AXI4_DMEM_awsize,
                    // Write address valid. 
                    // This signal indicates that valid write address and control
                    // information are available:
                    //     1 = address and control information available
                    //     0 = address and control information not available.
                    // The address and control information remain stable until
                    // the address acknowledge signal, AWREADY, goes HIGH.
                    AXI4_DMEM_awvalid,
                    // Response ready.
                    // This signal indicates that the master can accept the response information.
                    //     1 = master ready
                    //     0 = master not ready.
                    AXI4_DMEM_bready,
                    // Read ready.
                    // This signal indicates that the master can accept the
                    // read data and response information:
                    //     1 = master ready
                    //     0 = master not ready.
                    AXI4_DMEM_rready,
                    // Write data.
                    // The write data bus can be 8, 16, 32, 64, 128, 256, 512, or 1024 bits wide.
                    AXI4_DMEM_wdata,
                    // Write last.
                    // This signal indicates the last transfer in a write burst.
                    AXI4_DMEM_wlast,
                    // Write strobes.
                    // This signal indicates which byte lanes to update in memory.
                    // There is one write strobe for each eight bits of the write data bus.
                    // Therefore, WSTRB[n] corresponds to WDATA[(8 × n) + 7:(8 × n)].
                    AXI4_DMEM_wstrb,
                    // Write valid.
                    // This signal indicates that valid write data and strobes are available:
                    //     1 = write data and strobes available
                    //     0 = write data and strobes not available.
                    AXI4_DMEM_wvalid,
                    // Read address ready.
                    // This signal indicates that the slave is ready to accept an
                    // address and associated control signals:
                    //     1 = slave ready
                    //     0 = slave not ready.
                    AXI4_DMEM_arready,
                    // Write address ready. 
                    // This signal indicates that the slave is ready to accept an address
                    // and associated control signals:
                    //     1 = slave ready
                    //     0 = slave not ready.
                    AXI4_DMEM_awready,
                    // Response ID.
                    // The identification tag of the write response. The BID value 
                    // must match the AWID value of the write transaction to which
                    // the slave is responding.
                    AXI4_DMEM_bid,
                    // Write response.
                    // This signal indicates the status of the write transaction.
                    // The allowable responses are OKAY, EXOKAY, SLVERR, and DECERR.
                    AXI4_DMEM_bresp,
                    // Write response valid.
                    // This signal indicates that a valid write response is available:
                    //     1 = write response available
                    //     0 = write response not available.
                    AXI4_DMEM_bvalid,
                    // Read data.
                    // The read data bus can be 8, 16, 32, 64, 128, 256, 512, or 1024 bits wide.
                    AXI4_DMEM_rdata,
                    // Read ID tag.
                    // This signal is the ID tag of the read data group of signals.
                    // The RID value is generated by the slave and must match the
                    // ARID value of the read transaction to which it is responding.
                    AXI4_DMEM_rid,
                    // Read last.
                    // This signal indicates the last transfer in a read burst.
                    AXI4_DMEM_rlast,
                    // Read response.
                    // This signal indicates the status of the read transfer.
                    // The allowable responses are OKAY, EXOKAY, SLVERR, and DECERR.
                    AXI4_DMEM_rresp,
                    // Read valid.
                    // This signal indicates that the required read data is available 
                    // and the read transfer can complete:
                    //     1 = read data available
                    //     0 = read data not available.
                    AXI4_DMEM_rvalid,
                    // Write ready.
                    // This signal indicates that the slave can accept the write data:
                    //     1 = slave ready
                    //     0 = slave not ready.
                    AXI4_DMEM_wready,
                    // Ports for Interface AXI4_IMEM
                    // Read address.
                    // The read address bus gives the initial address of a read burst 
                    // transaction. Only the start address of the burst is provided 
                    // and the control signals that are issued alongside the address
                    // detail how the address is calculated for the remaining transfers
                    // in the burst.
                    AXI4_IMEM_araddr,
                    // Burst type.
                    // The burst type, coupled with the size information, details how 
                    // the address for each transfer within the burst is calculated.
                    AXI4_IMEM_arburst,
                    // Cache type.
                    // This signal provides additional information about the cacheable
                    // characteristics of the transfer.
                    AXI4_IMEM_arcache,
                    // Read address ID.
                    // This signal is the identification tag for the read address group of
                    // signals.
                    AXI4_IMEM_arid,
                    // Burst length.
                    // The burst length gives the exact number of transfers in a burst.
                    // This information determines the number of data transfers
                    // associated with the address.
                    AXI4_IMEM_arlen,
                    // Lock type.
                    // This signal provides additional information about the atomic
                    // characteristics of the transfer.
                    AXI4_IMEM_arlock,
                    // Protection type.
                    // This signal provides protection unit information for the transaction.
                    AXI4_IMEM_arprot,
                    // Burst size.
                    // This signal indicates the size of each transfer in the burst.
                    AXI4_IMEM_arsize,
                    // Read address valid.
                    // This signal indicates, when HIGH, that the read address and control
                    // information is valid and will remain stable until the address 
                    // acknowledge signal, ARREADY, is high.
                    //     1 = address and control information valid
                    //     0 = address and control information not valid.
                    AXI4_IMEM_arvalid,
                    // Write address. 
                    // The write address bus gives the address of the first transfer in a 
                    // write burst transaction. The associated control signals are used to 
                    // determine the addresses of the remaining transfers in the burst.
                    AXI4_IMEM_awaddr,
                    // Burst type. 
                    // The burst type, coupled with the size information, details how
                    // the address for each transfer within the burst is calculated.
                    AXI4_IMEM_awburst,
                    // Cache type. 
                    // This signal indicates the bufferable, cacheable, write-through,
                    // write-back, and allocate attributes of the transaction.
                    AXI4_IMEM_awcache,
                    // Write address ID. 
                    // This signal is the identification tag for the write address group of signals.
                    AXI4_IMEM_awid,
                    // Burst length. 
                    // The burst length gives the exact number of transfers in a burst.
                    // This information determines the number of data transfers associated
                    // with the address.
                    AXI4_IMEM_awlen,
                    // Lock type. 
                    // This signal provides additional information about the atomic
                    // characteristics of the transfer.
                    AXI4_IMEM_awlock,
                    // Protection type. 
                    // This signal indicates the normal, privileged, or secure
                    // protection level of the transaction and whether the
                    // transaction is a data access or an instruction access.
                    AXI4_IMEM_awprot,
                    // Burst size. 
                    // This signal indicates the size of each transfer in the burst.
                    // Byte lane strobes indicate exactly which byte lanes to update.
                    AXI4_IMEM_awsize,
                    // Write address valid. 
                    // This signal indicates that valid write address and control
                    // information are available:
                    //     1 = address and control information available
                    //     0 = address and control information not available.
                    // The address and control information remain stable until
                    // the address acknowledge signal, AWREADY, goes HIGH.
                    AXI4_IMEM_awvalid,
                    // Response ready.
                    // This signal indicates that the master can accept the response information.
                    //     1 = master ready
                    //     0 = master not ready.
                    AXI4_IMEM_bready,
                    // Read ready.
                    // This signal indicates that the master can accept the
                    // read data and response information:
                    //     1 = master ready
                    //     0 = master not ready.
                    AXI4_IMEM_rready,
                    // Write data.
                    // The write data bus can be 8, 16, 32, 64, 128, 256, 512, or 1024 bits wide.
                    AXI4_IMEM_wdata,
                    // Write last.
                    // This signal indicates the last transfer in a write burst.
                    AXI4_IMEM_wlast,
                    // Write strobes.
                    // This signal indicates which byte lanes to update in memory.
                    // There is one write strobe for each eight bits of the write data bus.
                    // Therefore, WSTRB[n] corresponds to WDATA[(8 × n) + 7:(8 × n)].
                    AXI4_IMEM_wstrb,
                    // Write valid.
                    // This signal indicates that valid write data and strobes are available:
                    //     1 = write data and strobes available
                    //     0 = write data and strobes not available.
                    AXI4_IMEM_wvalid,
                    // Read address ready.
                    // This signal indicates that the slave is ready to accept an
                    // address and associated control signals:
                    //     1 = slave ready
                    //     0 = slave not ready.
                    AXI4_IMEM_arready,
                    // Write address ready. 
                    // This signal indicates that the slave is ready to accept an address
                    // and associated control signals:
                    //     1 = slave ready
                    //     0 = slave not ready.
                    AXI4_IMEM_awready,
                    // Response ID.
                    // The identification tag of the write response. The BID value 
                    // must match the AWID value of the write transaction to which
                    // the slave is responding.
                    AXI4_IMEM_bid,
                    // Write response.
                    // This signal indicates the status of the write transaction.
                    // The allowable responses are OKAY, EXOKAY, SLVERR, and DECERR.
                    AXI4_IMEM_bresp,
                    // Write response valid.
                    // This signal indicates that a valid write response is available:
                    //     1 = write response available
                    //     0 = write response not available.
                    AXI4_IMEM_bvalid,
                    // Read data.
                    // The read data bus can be 8, 16, 32, 64, 128, 256, 512, or 1024 bits wide.
                    AXI4_IMEM_rdata,
                    // Read ID tag.
                    // This signal is the ID tag of the read data group of signals.
                    // The RID value is generated by the slave and must match the
                    // ARID value of the read transaction to which it is responding.
                    AXI4_IMEM_rid,
                    // Read last.
                    // This signal indicates the last transfer in a read burst.
                    AXI4_IMEM_rlast,
                    // Read response.
                    // This signal indicates the status of the read transfer.
                    // The allowable responses are OKAY, EXOKAY, SLVERR, and DECERR.
                    AXI4_IMEM_rresp,
                    // Read valid.
                    // This signal indicates that the required read data is available 
                    // and the read transfer can complete:
                    //     1 = read data available
                    //     0 = read data not available.
                    AXI4_IMEM_rvalid,
                    // Write ready.
                    // This signal indicates that the slave can accept the write data:
                    //     1 = slave ready
                    //     0 = slave not ready.
                    AXI4_IMEM_wready,
                    // Ports for Interface AXI4_S1_SRAM
                    // Read address ready.
                    // This signal indicates that the slave is ready to accept an
                    // address and associated control signals:
                    //     1 = slave ready
                    //     0 = slave not ready.
                    AXI4_S1_SRAM_arready,
                    // Write address ready. 
                    // This signal indicates that the slave is ready to accept an address
                    // and associated control signals:
                    //     1 = slave ready
                    //     0 = slave not ready.
                    AXI4_S1_SRAM_awready,
                    // Response ID.
                    // The identification tag of the write response. The BID value 
                    // must match the AWID value of the write transaction to which
                    // the slave is responding.
                    AXI4_S1_SRAM_bid,
                    // Write response.
                    // This signal indicates the status of the write transaction.
                    // The allowable responses are OKAY, EXOKAY, SLVERR, and DECERR.
                    AXI4_S1_SRAM_bresp,
                    // Write response valid.
                    // This signal indicates that a valid write response is available:
                    //     1 = write response available
                    //     0 = write response not available.
                    AXI4_S1_SRAM_bvalid,
                    // Read data.
                    // The read data bus can be 8, 16, 32, 64, 128, 256, 512, or 1024 bits wide.
                    AXI4_S1_SRAM_rdata,
                    // Read ID tag.
                    // This signal is the ID tag of the read data group of signals.
                    // The RID value is generated by the slave and must match the
                    // ARID value of the read transaction to which it is responding.
                    AXI4_S1_SRAM_rid,
                    // Read last.
                    // This signal indicates the last transfer in a read burst.
                    AXI4_S1_SRAM_rlast,
                    // Read response.
                    // This signal indicates the status of the read transfer.
                    // The allowable responses are OKAY, EXOKAY, SLVERR, and DECERR.
                    AXI4_S1_SRAM_rresp,
                    // Read valid.
                    // This signal indicates that the required read data is available 
                    // and the read transfer can complete:
                    //     1 = read data available
                    //     0 = read data not available.
                    AXI4_S1_SRAM_rvalid,
                    // Write ready.
                    // This signal indicates that the slave can accept the write data:
                    //     1 = slave ready
                    //     0 = slave not ready.
                    AXI4_S1_SRAM_wready,
                    // Read address.
                    // The read address bus gives the initial address of a read burst 
                    // transaction. Only the start address of the burst is provided 
                    // and the control signals that are issued alongside the address
                    // detail how the address is calculated for the remaining transfers
                    // in the burst.
                    AXI4_S1_SRAM_araddr,
                    // Burst type.
                    // The burst type, coupled with the size information, details how 
                    // the address for each transfer within the burst is calculated.
                    AXI4_S1_SRAM_arburst,
                    // Cache type.
                    // This signal provides additional information about the cacheable
                    // characteristics of the transfer.
                    AXI4_S1_SRAM_arcache,
                    // Read address ID.
                    // This signal is the identification tag for the read address group of
                    // signals.
                    AXI4_S1_SRAM_arid,
                    // Burst length.
                    // The burst length gives the exact number of transfers in a burst.
                    // This information determines the number of data transfers
                    // associated with the address.
                    AXI4_S1_SRAM_arlen,
                    // Lock type.
                    // This signal provides additional information about the atomic
                    // characteristics of the transfer.
                    AXI4_S1_SRAM_arlock,
                    // Protection type.
                    // This signal provides protection unit information for the transaction.
                    AXI4_S1_SRAM_arprot,
                    // Burst size.
                    // This signal indicates the size of each transfer in the burst.
                    AXI4_S1_SRAM_arsize,
                    // Read address valid.
                    // This signal indicates, when HIGH, that the read address and control
                    // information is valid and will remain stable until the address 
                    // acknowledge signal, ARREADY, is high.
                    //     1 = address and control information valid
                    //     0 = address and control information not valid.
                    AXI4_S1_SRAM_arvalid,
                    // Write address. 
                    // The write address bus gives the address of the first transfer in a 
                    // write burst transaction. The associated control signals are used to 
                    // determine the addresses of the remaining transfers in the burst.
                    AXI4_S1_SRAM_awaddr,
                    // Burst type. 
                    // The burst type, coupled with the size information, details how
                    // the address for each transfer within the burst is calculated.
                    AXI4_S1_SRAM_awburst,
                    // Cache type. 
                    // This signal indicates the bufferable, cacheable, write-through,
                    // write-back, and allocate attributes of the transaction.
                    AXI4_S1_SRAM_awcache,
                    // Write address ID. 
                    // This signal is the identification tag for the write address group of signals.
                    AXI4_S1_SRAM_awid,
                    // Burst length. 
                    // The burst length gives the exact number of transfers in a burst.
                    // This information determines the number of data transfers associated
                    // with the address.
                    AXI4_S1_SRAM_awlen,
                    // Lock type. 
                    // This signal provides additional information about the atomic
                    // characteristics of the transfer.
                    AXI4_S1_SRAM_awlock,
                    // Protection type. 
                    // This signal indicates the normal, privileged, or secure
                    // protection level of the transaction and whether the
                    // transaction is a data access or an instruction access.
                    AXI4_S1_SRAM_awprot,
                    // Burst size. 
                    // This signal indicates the size of each transfer in the burst.
                    // Byte lane strobes indicate exactly which byte lanes to update.
                    AXI4_S1_SRAM_awsize,
                    // Write address valid. 
                    // This signal indicates that valid write address and control
                    // information are available:
                    //     1 = address and control information available
                    //     0 = address and control information not available.
                    // The address and control information remain stable until
                    // the address acknowledge signal, AWREADY, goes HIGH.
                    AXI4_S1_SRAM_awvalid,
                    // Response ready.
                    // This signal indicates that the master can accept the response information.
                    //     1 = master ready
                    //     0 = master not ready.
                    AXI4_S1_SRAM_bready,
                    // Read ready.
                    // This signal indicates that the master can accept the
                    // read data and response information:
                    //     1 = master ready
                    //     0 = master not ready.
                    AXI4_S1_SRAM_rready,
                    // Write data.
                    // The write data bus can be 8, 16, 32, 64, 128, 256, 512, or 1024 bits wide.
                    AXI4_S1_SRAM_wdata,
                    // Write last.
                    // This signal indicates the last transfer in a write burst.
                    AXI4_S1_SRAM_wlast,
                    // Write strobes.
                    // This signal indicates which byte lanes to update in memory.
                    // There is one write strobe for each eight bits of the write data bus.
                    // Therefore, WSTRB[n] corresponds to WDATA[(8 × n) + 7:(8 × n)].
                    AXI4_S1_SRAM_wstrb,
                    // Write valid.
                    // This signal indicates that valid write data and strobes are available:
                    //     1 = write data and strobes available
                    //     0 = write data and strobes not available.
                    AXI4_S1_SRAM_wvalid,
                    // Ports for Interface AXI4_S2_X2P
                    // Read address ready.
                    // This signal indicates that the slave is ready to accept an
                    // address and associated control signals:
                    //     1 = slave ready
                    //     0 = slave not ready.
                    AXI4_S2_X2P_arready,
                    // Write address ready. 
                    // This signal indicates that the slave is ready to accept an address
                    // and associated control signals:
                    //     1 = slave ready
                    //     0 = slave not ready.
                    AXI4_S2_X2P_awready,
                    // Response ID.
                    // The identification tag of the write response. The BID value 
                    // must match the AWID value of the write transaction to which
                    // the slave is responding.
                    AXI4_S2_X2P_bid,
                    // Write response.
                    // This signal indicates the status of the write transaction.
                    // The allowable responses are OKAY, EXOKAY, SLVERR, and DECERR.
                    AXI4_S2_X2P_bresp,
                    // Write response valid.
                    // This signal indicates that a valid write response is available:
                    //     1 = write response available
                    //     0 = write response not available.
                    AXI4_S2_X2P_bvalid,
                    // Read data.
                    // The read data bus can be 8, 16, 32, 64, 128, 256, 512, or 1024 bits wide.
                    AXI4_S2_X2P_rdata,
                    // Read ID tag.
                    // This signal is the ID tag of the read data group of signals.
                    // The RID value is generated by the slave and must match the
                    // ARID value of the read transaction to which it is responding.
                    AXI4_S2_X2P_rid,
                    // Read last.
                    // This signal indicates the last transfer in a read burst.
                    AXI4_S2_X2P_rlast,
                    // Read response.
                    // This signal indicates the status of the read transfer.
                    // The allowable responses are OKAY, EXOKAY, SLVERR, and DECERR.
                    AXI4_S2_X2P_rresp,
                    // Read valid.
                    // This signal indicates that the required read data is available 
                    // and the read transfer can complete:
                    //     1 = read data available
                    //     0 = read data not available.
                    AXI4_S2_X2P_rvalid,
                    // Write ready.
                    // This signal indicates that the slave can accept the write data:
                    //     1 = slave ready
                    //     0 = slave not ready.
                    AXI4_S2_X2P_wready,
                    // Read address.
                    // The read address bus gives the initial address of a read burst 
                    // transaction. Only the start address of the burst is provided 
                    // and the control signals that are issued alongside the address
                    // detail how the address is calculated for the remaining transfers
                    // in the burst.
                    AXI4_S2_X2P_araddr,
                    // Burst type.
                    // The burst type, coupled with the size information, details how 
                    // the address for each transfer within the burst is calculated.
                    AXI4_S2_X2P_arburst,
                    // Cache type.
                    // This signal provides additional information about the cacheable
                    // characteristics of the transfer.
                    AXI4_S2_X2P_arcache,
                    // Read address ID.
                    // This signal is the identification tag for the read address group of
                    // signals.
                    AXI4_S2_X2P_arid,
                    // Burst length.
                    // The burst length gives the exact number of transfers in a burst.
                    // This information determines the number of data transfers
                    // associated with the address.
                    AXI4_S2_X2P_arlen,
                    // Lock type.
                    // This signal provides additional information about the atomic
                    // characteristics of the transfer.
                    AXI4_S2_X2P_arlock,
                    // Protection type.
                    // This signal provides protection unit information for the transaction.
                    AXI4_S2_X2P_arprot,
                    // Burst size.
                    // This signal indicates the size of each transfer in the burst.
                    AXI4_S2_X2P_arsize,
                    // Read address valid.
                    // This signal indicates, when HIGH, that the read address and control
                    // information is valid and will remain stable until the address 
                    // acknowledge signal, ARREADY, is high.
                    //     1 = address and control information valid
                    //     0 = address and control information not valid.
                    AXI4_S2_X2P_arvalid,
                    // Write address. 
                    // The write address bus gives the address of the first transfer in a 
                    // write burst transaction. The associated control signals are used to 
                    // determine the addresses of the remaining transfers in the burst.
                    AXI4_S2_X2P_awaddr,
                    // Burst type. 
                    // The burst type, coupled with the size information, details how
                    // the address for each transfer within the burst is calculated.
                    AXI4_S2_X2P_awburst,
                    // Cache type. 
                    // This signal indicates the bufferable, cacheable, write-through,
                    // write-back, and allocate attributes of the transaction.
                    AXI4_S2_X2P_awcache,
                    // Write address ID. 
                    // This signal is the identification tag for the write address group of signals.
                    AXI4_S2_X2P_awid,
                    // Burst length. 
                    // The burst length gives the exact number of transfers in a burst.
                    // This information determines the number of data transfers associated
                    // with the address.
                    AXI4_S2_X2P_awlen,
                    // Lock type. 
                    // This signal provides additional information about the atomic
                    // characteristics of the transfer.
                    AXI4_S2_X2P_awlock,
                    // Protection type. 
                    // This signal indicates the normal, privileged, or secure
                    // protection level of the transaction and whether the
                    // transaction is a data access or an instruction access.
                    AXI4_S2_X2P_awprot,
                    // Burst size. 
                    // This signal indicates the size of each transfer in the burst.
                    // Byte lane strobes indicate exactly which byte lanes to update.
                    AXI4_S2_X2P_awsize,
                    // Write address valid. 
                    // This signal indicates that valid write address and control
                    // information are available:
                    //     1 = address and control information available
                    //     0 = address and control information not available.
                    // The address and control information remain stable until
                    // the address acknowledge signal, AWREADY, goes HIGH.
                    AXI4_S2_X2P_awvalid,
                    // Response ready.
                    // This signal indicates that the master can accept the response information.
                    //     1 = master ready
                    //     0 = master not ready.
                    AXI4_S2_X2P_bready,
                    // Read ready.
                    // This signal indicates that the master can accept the
                    // read data and response information:
                    //     1 = master ready
                    //     0 = master not ready.
                    AXI4_S2_X2P_rready,
                    // Write data.
                    // The write data bus can be 8, 16, 32, 64, 128, 256, 512, or 1024 bits wide.
                    AXI4_S2_X2P_wdata,
                    // Write last.
                    // This signal indicates the last transfer in a write burst.
                    AXI4_S2_X2P_wlast,
                    // Write strobes.
                    // This signal indicates which byte lanes to update in memory.
                    // There is one write strobe for each eight bits of the write data bus.
                    // Therefore, WSTRB[n] corresponds to WDATA[(8 × n) + 7:(8 × n)].
                    AXI4_S2_X2P_wstrb,
                    // Write valid.
                    // This signal indicates that valid write data and strobes are available:
                    //     1 = write data and strobes available
                    //     0 = write data and strobes not available.
                    AXI4_S2_X2P_wvalid,
                    // Ports for Manually exported pins
                    miet_dw_axi_ic_dbg_araddr_s0,
                    miet_dw_axi_ic_dbg_arburst_s0,
                    miet_dw_axi_ic_dbg_arcache_s0,
                    miet_dw_axi_ic_dbg_arid_s0,
                    miet_dw_axi_ic_dbg_arlen_s0,
                    miet_dw_axi_ic_dbg_arlock_s0,
                    miet_dw_axi_ic_dbg_arprot_s0,
                    miet_dw_axi_ic_dbg_arready_s0,
                    miet_dw_axi_ic_dbg_arsize_s0,
                    miet_dw_axi_ic_dbg_arvalid_s0,
                    miet_dw_axi_ic_dbg_awaddr_s0,
                    miet_dw_axi_ic_dbg_awburst_s0,
                    miet_dw_axi_ic_dbg_awcache_s0,
                    miet_dw_axi_ic_dbg_awid_s0,
                    miet_dw_axi_ic_dbg_awlen_s0,
                    miet_dw_axi_ic_dbg_awlock_s0,
                    miet_dw_axi_ic_dbg_awprot_s0,
                    miet_dw_axi_ic_dbg_awready_s0,
                    miet_dw_axi_ic_dbg_awsize_s0,
                    miet_dw_axi_ic_dbg_awvalid_s0,
                    miet_dw_axi_ic_dbg_bid_s0,
                    miet_dw_axi_ic_dbg_bready_s0,
                    miet_dw_axi_ic_dbg_bresp_s0,
                    miet_dw_axi_ic_dbg_bvalid_s0,
                    miet_dw_axi_ic_dbg_rdata_s0,
                    miet_dw_axi_ic_dbg_rid_s0,
                    miet_dw_axi_ic_dbg_rlast_s0,
                    miet_dw_axi_ic_dbg_rready_s0,
                    miet_dw_axi_ic_dbg_rresp_s0,
                    miet_dw_axi_ic_dbg_rvalid_s0,
                    miet_dw_axi_ic_dbg_wdata_s0,
                    miet_dw_axi_ic_dbg_wid_s0,
                    miet_dw_axi_ic_dbg_wlast_s0,
                    miet_dw_axi_ic_dbg_wready_s0,
                    miet_dw_axi_ic_dbg_wstrb_s0,
                    miet_dw_axi_ic_dbg_wvalid_s0
                    );

   // Ports for Interface AXI4_ACLK
   input          AXI4_ACLK_aclk;
   // Ports for Interface AXI4_ARESETn
   input          AXI4_ARESETn_aresetn;
   // Ports for Interface AXI4_DMEM
   input  [31:0]  AXI4_DMEM_araddr;
   input  [1:0]   AXI4_DMEM_arburst;
   input  [3:0]   AXI4_DMEM_arcache;
   input  [3:0]   AXI4_DMEM_arid;
   input  [7:0]   AXI4_DMEM_arlen;
   input          AXI4_DMEM_arlock;
   input  [2:0]   AXI4_DMEM_arprot;
   input  [2:0]   AXI4_DMEM_arsize;
   input          AXI4_DMEM_arvalid;
   input  [31:0]  AXI4_DMEM_awaddr;
   input  [1:0]   AXI4_DMEM_awburst;
   input  [3:0]   AXI4_DMEM_awcache;
   input  [3:0]   AXI4_DMEM_awid;
   input  [7:0]   AXI4_DMEM_awlen;
   input          AXI4_DMEM_awlock;
   input  [2:0]   AXI4_DMEM_awprot;
   input  [2:0]   AXI4_DMEM_awsize;
   input          AXI4_DMEM_awvalid;
   input          AXI4_DMEM_bready;
   input          AXI4_DMEM_rready;
   input  [31:0]  AXI4_DMEM_wdata;
   input          AXI4_DMEM_wlast;
   input  [3:0]   AXI4_DMEM_wstrb;
   input          AXI4_DMEM_wvalid;
   output         AXI4_DMEM_arready;
   output         AXI4_DMEM_awready;
   output [3:0]   AXI4_DMEM_bid;
   output [1:0]   AXI4_DMEM_bresp;
   output         AXI4_DMEM_bvalid;
   output [31:0]  AXI4_DMEM_rdata;
   output [3:0]   AXI4_DMEM_rid;
   output         AXI4_DMEM_rlast;
   output [1:0]   AXI4_DMEM_rresp;
   output         AXI4_DMEM_rvalid;
   output         AXI4_DMEM_wready;
   // Ports for Interface AXI4_IMEM
   input  [31:0]  AXI4_IMEM_araddr;
   input  [1:0]   AXI4_IMEM_arburst;
   input  [3:0]   AXI4_IMEM_arcache;
   input  [3:0]   AXI4_IMEM_arid;
   input  [7:0]   AXI4_IMEM_arlen;
   input          AXI4_IMEM_arlock;
   input  [2:0]   AXI4_IMEM_arprot;
   input  [2:0]   AXI4_IMEM_arsize;
   input          AXI4_IMEM_arvalid;
   input  [31:0]  AXI4_IMEM_awaddr;
   input  [1:0]   AXI4_IMEM_awburst;
   input  [3:0]   AXI4_IMEM_awcache;
   input  [3:0]   AXI4_IMEM_awid;
   input  [7:0]   AXI4_IMEM_awlen;
   input          AXI4_IMEM_awlock;
   input  [2:0]   AXI4_IMEM_awprot;
   input  [2:0]   AXI4_IMEM_awsize;
   input          AXI4_IMEM_awvalid;
   input          AXI4_IMEM_bready;
   input          AXI4_IMEM_rready;
   input  [31:0]  AXI4_IMEM_wdata;
   input          AXI4_IMEM_wlast;
   input  [3:0]   AXI4_IMEM_wstrb;
   input          AXI4_IMEM_wvalid;
   output         AXI4_IMEM_arready;
   output         AXI4_IMEM_awready;
   output [3:0]   AXI4_IMEM_bid;
   output [1:0]   AXI4_IMEM_bresp;
   output         AXI4_IMEM_bvalid;
   output [31:0]  AXI4_IMEM_rdata;
   output [3:0]   AXI4_IMEM_rid;
   output         AXI4_IMEM_rlast;
   output [1:0]   AXI4_IMEM_rresp;
   output         AXI4_IMEM_rvalid;
   output         AXI4_IMEM_wready;
   // Ports for Interface AXI4_S1_SRAM
   input          AXI4_S1_SRAM_arready;
   input          AXI4_S1_SRAM_awready;
   input  [4:0]   AXI4_S1_SRAM_bid;
   input  [1:0]   AXI4_S1_SRAM_bresp;
   input          AXI4_S1_SRAM_bvalid;
   input  [31:0]  AXI4_S1_SRAM_rdata;
   input  [4:0]   AXI4_S1_SRAM_rid;
   input          AXI4_S1_SRAM_rlast;
   input  [1:0]   AXI4_S1_SRAM_rresp;
   input          AXI4_S1_SRAM_rvalid;
   input          AXI4_S1_SRAM_wready;
   output [31:0]  AXI4_S1_SRAM_araddr;
   output [1:0]   AXI4_S1_SRAM_arburst;
   output [3:0]   AXI4_S1_SRAM_arcache;
   output [4:0]   AXI4_S1_SRAM_arid;
   output [7:0]   AXI4_S1_SRAM_arlen;
   output         AXI4_S1_SRAM_arlock;
   output [2:0]   AXI4_S1_SRAM_arprot;
   output [2:0]   AXI4_S1_SRAM_arsize;
   output         AXI4_S1_SRAM_arvalid;
   output [31:0]  AXI4_S1_SRAM_awaddr;
   output [1:0]   AXI4_S1_SRAM_awburst;
   output [3:0]   AXI4_S1_SRAM_awcache;
   output [4:0]   AXI4_S1_SRAM_awid;
   output [7:0]   AXI4_S1_SRAM_awlen;
   output         AXI4_S1_SRAM_awlock;
   output [2:0]   AXI4_S1_SRAM_awprot;
   output [2:0]   AXI4_S1_SRAM_awsize;
   output         AXI4_S1_SRAM_awvalid;
   output         AXI4_S1_SRAM_bready;
   output         AXI4_S1_SRAM_rready;
   output [31:0]  AXI4_S1_SRAM_wdata;
   output         AXI4_S1_SRAM_wlast;
   output [3:0]   AXI4_S1_SRAM_wstrb;
   output         AXI4_S1_SRAM_wvalid;
   // Ports for Interface AXI4_S2_X2P
   input          AXI4_S2_X2P_arready;
   input          AXI4_S2_X2P_awready;
   input  [4:0]   AXI4_S2_X2P_bid;
   input  [1:0]   AXI4_S2_X2P_bresp;
   input          AXI4_S2_X2P_bvalid;
   input  [31:0]  AXI4_S2_X2P_rdata;
   input  [4:0]   AXI4_S2_X2P_rid;
   input          AXI4_S2_X2P_rlast;
   input  [1:0]   AXI4_S2_X2P_rresp;
   input          AXI4_S2_X2P_rvalid;
   input          AXI4_S2_X2P_wready;
   output [31:0]  AXI4_S2_X2P_araddr;
   output [1:0]   AXI4_S2_X2P_arburst;
   output [3:0]   AXI4_S2_X2P_arcache;
   output [4:0]   AXI4_S2_X2P_arid;
   output [7:0]   AXI4_S2_X2P_arlen;
   output         AXI4_S2_X2P_arlock;
   output [2:0]   AXI4_S2_X2P_arprot;
   output [2:0]   AXI4_S2_X2P_arsize;
   output         AXI4_S2_X2P_arvalid;
   output [31:0]  AXI4_S2_X2P_awaddr;
   output [1:0]   AXI4_S2_X2P_awburst;
   output [3:0]   AXI4_S2_X2P_awcache;
   output [4:0]   AXI4_S2_X2P_awid;
   output [7:0]   AXI4_S2_X2P_awlen;
   output         AXI4_S2_X2P_awlock;
   output [2:0]   AXI4_S2_X2P_awprot;
   output [2:0]   AXI4_S2_X2P_awsize;
   output         AXI4_S2_X2P_awvalid;
   output         AXI4_S2_X2P_bready;
   output         AXI4_S2_X2P_rready;
   output [31:0]  AXI4_S2_X2P_wdata;
   output         AXI4_S2_X2P_wlast;
   output [3:0]   AXI4_S2_X2P_wstrb;
   output         AXI4_S2_X2P_wvalid;
   // Ports for Manually exported pins
   output [31:0]  miet_dw_axi_ic_dbg_araddr_s0;
   output [1:0]   miet_dw_axi_ic_dbg_arburst_s0;
   output [3:0]   miet_dw_axi_ic_dbg_arcache_s0;
   output [4:0]   miet_dw_axi_ic_dbg_arid_s0;
   output [7:0]   miet_dw_axi_ic_dbg_arlen_s0;
   output         miet_dw_axi_ic_dbg_arlock_s0;
   output [2:0]   miet_dw_axi_ic_dbg_arprot_s0;
   output         miet_dw_axi_ic_dbg_arready_s0;
   output [2:0]   miet_dw_axi_ic_dbg_arsize_s0;
   output         miet_dw_axi_ic_dbg_arvalid_s0;
   output [31:0]  miet_dw_axi_ic_dbg_awaddr_s0;
   output [1:0]   miet_dw_axi_ic_dbg_awburst_s0;
   output [3:0]   miet_dw_axi_ic_dbg_awcache_s0;
   output [4:0]   miet_dw_axi_ic_dbg_awid_s0;
   output [7:0]   miet_dw_axi_ic_dbg_awlen_s0;
   output         miet_dw_axi_ic_dbg_awlock_s0;
   output [2:0]   miet_dw_axi_ic_dbg_awprot_s0;
   output         miet_dw_axi_ic_dbg_awready_s0;
   output [2:0]   miet_dw_axi_ic_dbg_awsize_s0;
   output         miet_dw_axi_ic_dbg_awvalid_s0;
   output [4:0]   miet_dw_axi_ic_dbg_bid_s0;
   output         miet_dw_axi_ic_dbg_bready_s0;
   output [1:0]   miet_dw_axi_ic_dbg_bresp_s0;
   output         miet_dw_axi_ic_dbg_bvalid_s0;
   output [31:0]  miet_dw_axi_ic_dbg_rdata_s0;
   output [4:0]   miet_dw_axi_ic_dbg_rid_s0;
   output         miet_dw_axi_ic_dbg_rlast_s0;
   output         miet_dw_axi_ic_dbg_rready_s0;
   output [1:0]   miet_dw_axi_ic_dbg_rresp_s0;
   output         miet_dw_axi_ic_dbg_rvalid_s0;
   output [31:0]  miet_dw_axi_ic_dbg_wdata_s0;
   output [4:0]   miet_dw_axi_ic_dbg_wid_s0;
   output         miet_dw_axi_ic_dbg_wlast_s0;
   output         miet_dw_axi_ic_dbg_wready_s0;
   output [3:0]   miet_dw_axi_ic_dbg_wstrb_s0;
   output         miet_dw_axi_ic_dbg_wvalid_s0;


   miet_dw_axi_ic_DW_axi miet_dw_axi_ic
      (.aclk           (AXI4_ACLK_aclk),
       .aresetn        (AXI4_ARESETn_aresetn),
       .awvalid_m1     (AXI4_DMEM_awvalid),
       .awaddr_m1      (AXI4_DMEM_awaddr),
       .awid_m1        (AXI4_DMEM_awid),
       .awlen_m1       (AXI4_DMEM_awlen),
       .awsize_m1      (AXI4_DMEM_awsize),
       .awburst_m1     (AXI4_DMEM_awburst),
       .awlock_m1      (AXI4_DMEM_awlock),
       .awcache_m1     (AXI4_DMEM_awcache),
       .awprot_m1      (AXI4_DMEM_awprot),
       .awready_m1     (AXI4_DMEM_awready),
       .wvalid_m1      (AXI4_DMEM_wvalid),
       .wdata_m1       (AXI4_DMEM_wdata),
       .wstrb_m1       (AXI4_DMEM_wstrb),
       .wlast_m1       (AXI4_DMEM_wlast),
       .wready_m1      (AXI4_DMEM_wready),
       .bvalid_m1      (AXI4_DMEM_bvalid),
       .bid_m1         (AXI4_DMEM_bid),
       .bresp_m1       (AXI4_DMEM_bresp),
       .bready_m1      (AXI4_DMEM_bready),
       .arvalid_m1     (AXI4_DMEM_arvalid),
       .arid_m1        (AXI4_DMEM_arid),
       .araddr_m1      (AXI4_DMEM_araddr),
       .arlen_m1       (AXI4_DMEM_arlen),
       .arsize_m1      (AXI4_DMEM_arsize),
       .arburst_m1     (AXI4_DMEM_arburst),
       .arlock_m1      (AXI4_DMEM_arlock),
       .arcache_m1     (AXI4_DMEM_arcache),
       .arprot_m1      (AXI4_DMEM_arprot),
       .arready_m1     (AXI4_DMEM_arready),
       .rvalid_m1      (AXI4_DMEM_rvalid),
       .rid_m1         (AXI4_DMEM_rid),
       .rdata_m1       (AXI4_DMEM_rdata),
       .rresp_m1       (AXI4_DMEM_rresp),
       .rlast_m1       (AXI4_DMEM_rlast),
       .rready_m1      (AXI4_DMEM_rready),
       .awvalid_m2     (AXI4_IMEM_awvalid),
       .awaddr_m2      (AXI4_IMEM_awaddr),
       .awid_m2        (AXI4_IMEM_awid),
       .awlen_m2       (AXI4_IMEM_awlen),
       .awsize_m2      (AXI4_IMEM_awsize),
       .awburst_m2     (AXI4_IMEM_awburst),
       .awlock_m2      (AXI4_IMEM_awlock),
       .awcache_m2     (AXI4_IMEM_awcache),
       .awprot_m2      (AXI4_IMEM_awprot),
       .awready_m2     (AXI4_IMEM_awready),
       .wvalid_m2      (AXI4_IMEM_wvalid),
       .wdata_m2       (AXI4_IMEM_wdata),
       .wstrb_m2       (AXI4_IMEM_wstrb),
       .wlast_m2       (AXI4_IMEM_wlast),
       .wready_m2      (AXI4_IMEM_wready),
       .bvalid_m2      (AXI4_IMEM_bvalid),
       .bid_m2         (AXI4_IMEM_bid),
       .bresp_m2       (AXI4_IMEM_bresp),
       .bready_m2      (AXI4_IMEM_bready),
       .arvalid_m2     (AXI4_IMEM_arvalid),
       .arid_m2        (AXI4_IMEM_arid),
       .araddr_m2      (AXI4_IMEM_araddr),
       .arlen_m2       (AXI4_IMEM_arlen),
       .arsize_m2      (AXI4_IMEM_arsize),
       .arburst_m2     (AXI4_IMEM_arburst),
       .arlock_m2      (AXI4_IMEM_arlock),
       .arcache_m2     (AXI4_IMEM_arcache),
       .arprot_m2      (AXI4_IMEM_arprot),
       .arready_m2     (AXI4_IMEM_arready),
       .rvalid_m2      (AXI4_IMEM_rvalid),
       .rid_m2         (AXI4_IMEM_rid),
       .rdata_m2       (AXI4_IMEM_rdata),
       .rresp_m2       (AXI4_IMEM_rresp),
       .rlast_m2       (AXI4_IMEM_rlast),
       .rready_m2      (AXI4_IMEM_rready),
       .awvalid_s1     (AXI4_S1_SRAM_awvalid),
       .awaddr_s1      (AXI4_S1_SRAM_awaddr),
       .awid_s1        (AXI4_S1_SRAM_awid),
       .awlen_s1       (AXI4_S1_SRAM_awlen),
       .awsize_s1      (AXI4_S1_SRAM_awsize),
       .awburst_s1     (AXI4_S1_SRAM_awburst),
       .awlock_s1      (AXI4_S1_SRAM_awlock),
       .awcache_s1     (AXI4_S1_SRAM_awcache),
       .awprot_s1      (AXI4_S1_SRAM_awprot),
       .awready_s1     (AXI4_S1_SRAM_awready),
       .wvalid_s1      (AXI4_S1_SRAM_wvalid),
       .wdata_s1       (AXI4_S1_SRAM_wdata),
       .wstrb_s1       (AXI4_S1_SRAM_wstrb),
       .wlast_s1       (AXI4_S1_SRAM_wlast),
       .wready_s1      (AXI4_S1_SRAM_wready),
       .bvalid_s1      (AXI4_S1_SRAM_bvalid),
       .bid_s1         (AXI4_S1_SRAM_bid),
       .bresp_s1       (AXI4_S1_SRAM_bresp),
       .bready_s1      (AXI4_S1_SRAM_bready),
       .arvalid_s1     (AXI4_S1_SRAM_arvalid),
       .arid_s1        (AXI4_S1_SRAM_arid),
       .araddr_s1      (AXI4_S1_SRAM_araddr),
       .arlen_s1       (AXI4_S1_SRAM_arlen),
       .arsize_s1      (AXI4_S1_SRAM_arsize),
       .arburst_s1     (AXI4_S1_SRAM_arburst),
       .arlock_s1      (AXI4_S1_SRAM_arlock),
       .arcache_s1     (AXI4_S1_SRAM_arcache),
       .arprot_s1      (AXI4_S1_SRAM_arprot),
       .arready_s1     (AXI4_S1_SRAM_arready),
       .rvalid_s1      (AXI4_S1_SRAM_rvalid),
       .rid_s1         (AXI4_S1_SRAM_rid),
       .rdata_s1       (AXI4_S1_SRAM_rdata),
       .rresp_s1       (AXI4_S1_SRAM_rresp),
       .rlast_s1       (AXI4_S1_SRAM_rlast),
       .rready_s1      (AXI4_S1_SRAM_rready),
       .awvalid_s2     (AXI4_S2_X2P_awvalid),
       .awaddr_s2      (AXI4_S2_X2P_awaddr),
       .awid_s2        (AXI4_S2_X2P_awid),
       .awlen_s2       (AXI4_S2_X2P_awlen),
       .awsize_s2      (AXI4_S2_X2P_awsize),
       .awburst_s2     (AXI4_S2_X2P_awburst),
       .awlock_s2      (AXI4_S2_X2P_awlock),
       .awcache_s2     (AXI4_S2_X2P_awcache),
       .awprot_s2      (AXI4_S2_X2P_awprot),
       .awready_s2     (AXI4_S2_X2P_awready),
       .wvalid_s2      (AXI4_S2_X2P_wvalid),
       .wdata_s2       (AXI4_S2_X2P_wdata),
       .wstrb_s2       (AXI4_S2_X2P_wstrb),
       .wlast_s2       (AXI4_S2_X2P_wlast),
       .wready_s2      (AXI4_S2_X2P_wready),
       .bvalid_s2      (AXI4_S2_X2P_bvalid),
       .bid_s2         (AXI4_S2_X2P_bid),
       .bresp_s2       (AXI4_S2_X2P_bresp),
       .bready_s2      (AXI4_S2_X2P_bready),
       .arvalid_s2     (AXI4_S2_X2P_arvalid),
       .arid_s2        (AXI4_S2_X2P_arid),
       .araddr_s2      (AXI4_S2_X2P_araddr),
       .arlen_s2       (AXI4_S2_X2P_arlen),
       .arsize_s2      (AXI4_S2_X2P_arsize),
       .arburst_s2     (AXI4_S2_X2P_arburst),
       .arlock_s2      (AXI4_S2_X2P_arlock),
       .arcache_s2     (AXI4_S2_X2P_arcache),
       .arprot_s2      (AXI4_S2_X2P_arprot),
       .arready_s2     (AXI4_S2_X2P_arready),
       .rvalid_s2      (AXI4_S2_X2P_rvalid),
       .rid_s2         (AXI4_S2_X2P_rid),
       .rdata_s2       (AXI4_S2_X2P_rdata),
       .rresp_s2       (AXI4_S2_X2P_rresp),
       .rlast_s2       (AXI4_S2_X2P_rlast),
       .rready_s2      (AXI4_S2_X2P_rready),
       .dbg_awid_s0    (miet_dw_axi_ic_dbg_awid_s0),
       .dbg_awaddr_s0  (miet_dw_axi_ic_dbg_awaddr_s0),
       .dbg_awlen_s0   (miet_dw_axi_ic_dbg_awlen_s0),
       .dbg_awsize_s0  (miet_dw_axi_ic_dbg_awsize_s0),
       .dbg_awburst_s0 (miet_dw_axi_ic_dbg_awburst_s0),
       .dbg_awlock_s0  (miet_dw_axi_ic_dbg_awlock_s0),
       .dbg_awcache_s0 (miet_dw_axi_ic_dbg_awcache_s0),
       .dbg_awprot_s0  (miet_dw_axi_ic_dbg_awprot_s0),
       .dbg_awvalid_s0 (miet_dw_axi_ic_dbg_awvalid_s0),
       .dbg_awready_s0 (miet_dw_axi_ic_dbg_awready_s0),
       .dbg_wid_s0     (miet_dw_axi_ic_dbg_wid_s0),
       .dbg_wdata_s0   (miet_dw_axi_ic_dbg_wdata_s0),
       .dbg_wstrb_s0   (miet_dw_axi_ic_dbg_wstrb_s0),
       .dbg_wlast_s0   (miet_dw_axi_ic_dbg_wlast_s0),
       .dbg_wvalid_s0  (miet_dw_axi_ic_dbg_wvalid_s0),
       .dbg_wready_s0  (miet_dw_axi_ic_dbg_wready_s0),
       .dbg_bid_s0     (miet_dw_axi_ic_dbg_bid_s0),
       .dbg_bresp_s0   (miet_dw_axi_ic_dbg_bresp_s0),
       .dbg_bvalid_s0  (miet_dw_axi_ic_dbg_bvalid_s0),
       .dbg_bready_s0  (miet_dw_axi_ic_dbg_bready_s0),
       .dbg_arid_s0    (miet_dw_axi_ic_dbg_arid_s0),
       .dbg_araddr_s0  (miet_dw_axi_ic_dbg_araddr_s0),
       .dbg_arlen_s0   (miet_dw_axi_ic_dbg_arlen_s0),
       .dbg_arsize_s0  (miet_dw_axi_ic_dbg_arsize_s0),
       .dbg_arburst_s0 (miet_dw_axi_ic_dbg_arburst_s0),
       .dbg_arlock_s0  (miet_dw_axi_ic_dbg_arlock_s0),
       .dbg_arcache_s0 (miet_dw_axi_ic_dbg_arcache_s0),
       .dbg_arprot_s0  (miet_dw_axi_ic_dbg_arprot_s0),
       .dbg_arvalid_s0 (miet_dw_axi_ic_dbg_arvalid_s0),
       .dbg_arready_s0 (miet_dw_axi_ic_dbg_arready_s0),
       .dbg_rid_s0     (miet_dw_axi_ic_dbg_rid_s0),
       .dbg_rdata_s0   (miet_dw_axi_ic_dbg_rdata_s0),
       .dbg_rresp_s0   (miet_dw_axi_ic_dbg_rresp_s0),
       .dbg_rvalid_s0  (miet_dw_axi_ic_dbg_rvalid_s0),
       .dbg_rlast_s0   (miet_dw_axi_ic_dbg_rlast_s0),
       .dbg_rready_s0  (miet_dw_axi_ic_dbg_rready_s0));



endmodule
