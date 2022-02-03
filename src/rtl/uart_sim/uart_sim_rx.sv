//|-----------------------------------------------------------------------------------
//| Author:      Kirill Lyubavin (kenezoer@gmail.com)
//| 
//| Module:      uart_sim_rx.sv
//| 
//| Purpose:     UART Simulation Receiver
//| 
//| Functionality:   
//|      im so cba to describe how it works... :l
//| 
//|-----------------------------------------------------------------------------------


module uart_sim_rx#(
    parameter           INST_NUM = 0,
    parameter           UART_CLK_HPER = 1.03ns
)(
    input               i_rst_n,
    input               i_uart_rx
);
    //|------------------------
    //| Parameters
    //|------------------------

    localparam PLUSARG_LOG = "UART_LOG_PATH";
    localparam DEFAULT_LOG_PATH = "uart";

    //|------------------------
    //| Local Variables
    //|------------------------

    bit             clk;
    logic   [7:0]   rdata;
    logic           rdy;
    bit             rdy_clr;

    string          log_path;
    string          test_str;
    int             fd;
    int             fd_tmp;

    string          msg;
    logic   [7:0]   chr;

    //|------------------------
    //| Main Process
    //|------------------------
    always #UART_CLK_HPER clk = ~clk;

    always @(posedge clk)
        if(rdy_clr == 1'b0) begin
            if(rdy == 1'b1) rdy_clr <= 1'b1;
        end else
            rdy_clr <= 1'b0;

    initial
    begin: main_proc
        test_str = {PLUSARG_LOG, "=%s"};
        assert($value$plusargs(test_str, log_path))
            else
            begin
                $display("UART log path is not set!\nUsing default log file:");
                log_path = $sformatf({DEFAULT_LOG_PATH, "_%1d.log"}, INST_NUM);
                $display("%s", log_path);
                $stop;
            end

        log_path = $sformatf({log_path, "_%1d.log"}, INST_NUM);
        fd       = $fopen(log_path, "w");
        fd_tmp   = $fopen({log_path, ".tmp"}, "w");

        assert(fd)
            else
            begin
                $display("Can't open UART log file!");
                $stop;
            end

        assert(fd_tmp)
            else
            begin
                $display("Can't open UART tmp log file!");
                $stop;
            end

        forever begin: main_loop
            @(posedge clk iff rdy === 1'b1);

            chr = rdata;
            msg = string'({msg, chr});

            if(chr != 8'h0A) begin
                $fwrite(fd_tmp, "%s", string'({8'h0D, msg}));
            end else begin
                $fwrite(fd_tmp, "%s\n", string'({8'h0D, msg}));
                $fwrite(fd, "%s\n", msg);
                msg = "";
            end

            $fflush(fd_tmp);
            $fflush(fd);

            @(posedge clk iff rdy === 1'b0);
            
        end: main_loop

    end: main_proc

    //|------------------------
    //| UART RECEIVER
    //|------------------------

    uart_sim_receiver
    UART_RX (
        .rx         ( i_uart_rx ),
        .rdy        ( rdy       ),
        .rdy_clr    ( rdy_clr   ),
        .clk_50m    ( clk       ),
        .clken      ( i_rst_n   ),
        .data       ( rdata     ));




endmodule : uart_sim_rx