module apb3_slave(
    APB3_Interface.Slave        APB3
);

    import apb3_regmap_pkg::*;

    regmap_t    regmap;

    logic   [9:0]   word_addr;
    logic           miss_address;
    logic           wr_en;
    logic           rd_en;
    logic           calc_finish;
    logic   [31:0]  calc_result;
    logic           calc_busy;
    
    control_reg_t   control_reg_write;

    always_comb control_reg_write = control_reg_t'(APB3.PWDATA);

    always_comb word_addr       = APB3.PADDR >> 2;
    always_comb miss_address    = (word_addr > 3);
    always_comb APB3.PSLVERR    = APB3.PREADY && miss_address;

    always_comb wr_en           =   APB3.PSEL       &&
                                    APB3.PENABLE    &&
                                    APB3.PWRITE     &&
                                   !APB3.PREADY;

    always_comb rd_en           =   APB3.PSEL       &&
                                    APB3.PENABLE    &&
                                   !APB3.PWRITE     &&
                                   !APB3.PREADY;

    always_ff@(posedge APB3.PCLK or negedge APB3.PRESETn)
    if(!APB3.PRESETn)
        APB3.PREADY <= '0;
    else
        APB3.PREADY <= (wr_en || rd_en);


    always_ff@(posedge APB3.PCLK or negedge APB3.PRESETn)
    if(!APB3.PRESETn)
        regmap  <= '0;
    else begin 
        if(wr_en && !miss_address) begin
            case(word_addr)

            // 0: /* do nothing for Read Only*/
            1: regmap.data_in           <= APB3.PWDATA;
            // 2: /* do nothing for Read Only*/
            3: begin
                regmap.control.init     <= control_reg_write.init;  // APB3.PWDATA[8];
                regmap.control.start    <= control_reg_write.start; // APB3.PWDATA[0];

                if(control_reg_write.finish_status) // if(APB3.PWDATA[16])
                    regmap.control.finish_status    <= '0;
            end

            // default: /* do nothing */

            endcase
        end

        if(regmap.control.start)
            regmap.control.start    <= '0;

        if(regmap.control.init)
            regmap.control.init     <= '0;

        if(calc_finish) begin
            regmap.control.finish_status    <= '1;
            regmap.data_out                 <= calc_result;
        end

        regmap.control.busy         <= calc_busy;
        
    end


    always_ff@(posedge APB3.PCLK or negedge APB3.PRESETn)
    if(!APB3.PRESETn)
        APB3.PRDATA     <= '0;
    else if(rd_en && !miss_address) begin

        case(word_addr)

        0: APB3.PRDATA <= regmap.poly;
        1: APB3.PRDATA <= regmap.data_in;
        2: APB3.PRDATA <= regmap.data_out;
        3: APB3.PRDATA <= regmap.control;
        // default: /* */

        endcase

    end
    
    
    crc crc(
        .clk        ( APB3.PCLK             ),
        .nrst       ( APB3.PRESETn          ),
        .init       ( regmap.control.init   ),
        .start      ( regmap.control.start  ),
        .data       ( regmap.data_in        ),
        .done       ( calc_finish           ),
        .busy       ( calc_busy             ),
        .result     ( calc_result           ));


endmodule : apb3_slave