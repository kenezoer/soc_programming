//|-----------------------------------------------------------------------------------
//| Author:      Kirill Lyubavin (kenezoer@gmail.com)
//| 
//| Module:      generic_memory.sv
//| 
//| Purpose:     Generic SRAM Analogue for SCR1 Instructions
//| 
//| Functionality:   
//|      SRAM... what to say else?
//| 
//|-----------------------------------------------------------------------------------


module generic_memory #(
    parameter                                       SRAM_BANK_ADDR_WIDTH        = 32,
    parameter                                       SRAM_BANK_DATA_WIDTH        = 32,
    parameter   string                              INIT_FILE                   = 0
)(
    input                                           i_clk,

    input           [SRAM_BANK_ADDR_WIDTH-1:0]      mem_addr,
    input           [SRAM_BANK_DATA_WIDTH-1:0]      mem_wdata,
    input                                           mem_we,
    input                                           mem_ce,

    output  logic   [SRAM_BANK_DATA_WIDTH-1:0]      mem_rdata
);

    logic    [SRAM_BANK_DATA_WIDTH-1:0] memory_array_init [2**SRAM_BANK_ADDR_WIDTH-1:0];    // if we put 2 ** 32 array will be size -1, too big value
    logic    [SRAM_BANK_DATA_WIDTH-1:0] memory_array      [2**SRAM_BANK_ADDR_WIDTH-1:0];    // if we put 2 ** 32 array will be size -1, too big value
    int                                 fd, status;

    initial begin

        fd = $fopen (INIT_FILE, "rb");

        if (!fd)
            $error("Could not open \" ***.hex for SRAM SCR1!\"");

        $readmemh(INIT_FILE, memory_array_init);
        $fclose(fd);

        foreach(memory_array[i]) begin
            memory_array[i][31:24] = memory_array_init[i][7 : 0];
            memory_array[i][23:16] = memory_array_init[i][15: 8];
            memory_array[i][15: 8] = memory_array_init[i][23:16];
            memory_array[i][7 : 0] = memory_array_init[i][31:24];
        end
    end

    always@(posedge i_clk)
    if(mem_ce) begin
        if(mem_we)
            memory_array[mem_addr]  <= mem_wdata;
        else
            mem_rdata               <= memory_array[mem_addr];
    end


endmodule : generic_memory