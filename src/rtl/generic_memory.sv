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


module generic_memory#(
    parameter   SRAM_BANK_ADDR_WIDTH        = 32,
    parameter   SRAM_BANK_DATA_WIDTH        = 32
)(
    input                                           i_clk,

    input           [SRAM_BANK_ADDR_WIDTH-1:0]      mem_addr,
    input           [SRAM_BANK_DATA_WIDTH-1:0]      mem_wdata,
    input                                           mem_we,
    input                                           mem_ce,

    output  logic   [SRAM_BANK_DATA_WIDTH-1:0]      mem_rdata
);

    logic   [2**SRAM_BANK_ADDR_WIDTH-1:0] [SRAM_BANK_DATA_WIDTH-1:0] memory_array; // if we put 2 ** 32 array will be size -1, too big value
    string                              hex_data;
    int                                 fd, status;

    initial begin
        hex_data = "../compile/user_programm/build/user_programm.hex";

        fd = $fopen (hex_data, "rb");

        if (!fd)
            $error("Could not open \" ***.hex for SRAM SCR1!\"");

        status = $fread (memory_array,fd);
        $fclose(fd);
    end

    always@(posedge i_clk)
    if(mem_ce) begin
        if(mem_we)
            memory_array[mem_addr]  <= mem_wdata;
        else
            mem_rdata               <= memory_array[mem_addr];
    end


endmodule : generic_memory