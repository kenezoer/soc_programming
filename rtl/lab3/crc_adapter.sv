module crc(
    input                   clk,
    input                   nrst,
    input                   init,
    input                   start,
    input           [31:0]  data,
    output  logic           done,
    output  logic           busy,
    output  logic   [31:0]  result
);

    // CRC32
    localparam logic [31:0] POLY = 32'h814141AB;

    logic   [31:0]  shift_reg_done;
    logic   [31:0]  crc_value;
    logic   [31:0]  crc_reg;
    logic   [4:0]   counter;
    logic           data_in;

    always_ff@(posedge clk or negedge nrst)
    if(!nrst)
        shift_reg_done  <= '0;
    else
        shift_reg_done  <= {shift_reg_done[30:0], start};

    always_comb done = shift_reg_done[31];

    always_ff@(posedge clk or negedge nrst)
    if(!nrst)
        busy    <= '0;
    else if(done)
        busy    <= '0;
    else if(start)
        busy    <= '1;

    always_ff@(posedge clk or negedge nrst)
    if(!nrst)
        result  <= '0;
    else if(done)
        result  <= crc_value;

    always_ff@(posedge clk or negedge nrst)
    if(!nrst)
        crc_reg <= '0;
    else if(start)
        crc_reg <= data;

    always_ff@(posedge clk or negedge nrst)
    if(!nrst)
        counter <= '0;
    else if(counter != '0)
        counter <= counter + 1'b1;
    else if(start)
        counter <= counter + 1'b1;


    always_comb data_in = crc_reg[counter];

    // 10000001010000010100000110101011

    always_ff@(posedge clk or negedge nrst)
    if(!nrst)
        crc_value       <= '0;
    else if(init)
        crc_value       <= '0;
    else if(busy) begin
        crc_value[0]    <= data_in ^ crc_value[31];
        crc_value[1]    <= crc_value[1] ^ data_in ^ crc_value[31];
        crc_value[2]    <= crc_value[1];
        crc_value[3]    <= crc_value[3] ^ data_in ^ crc_value[31];
        crc_value[4]    <= crc_value[3];
        crc_value[5]    <= crc_value[5] ^ data_in ^ crc_value[31];
        crc_value[6]    <= crc_value[5];
        crc_value[7]    <= crc_value[7] ^ data_in ^ crc_value[31];
        crc_value[8]    <= crc_value[8] ^ data_in ^ crc_value[31];
        crc_value[9]    <= crc_value[8];
        crc_value[10]   <= crc_value[9];
        crc_value[11]   <= crc_value[10];
        crc_value[12]   <= crc_value[11];
        crc_value[13]   <= crc_value[12];
        crc_value[14]   <= crc_value[14] ^ data_in ^ crc_value[31];
        crc_value[15]   <= crc_value[15];
        crc_value[16]   <= crc_value[16] ^ data_in ^ crc_value[31];
        crc_value[17]   <= crc_value[16];
        crc_value[18]   <= crc_value[17];
        crc_value[19]   <= crc_value[18];
        crc_value[20]   <= crc_value[19];
        crc_value[21]   <= crc_value[20];
        crc_value[22]   <= crc_value[22] ^ data_in ^ crc_value[31];
        crc_value[23]   <= crc_value[22];
        crc_value[24]   <= crc_value[24] ^ data_in ^ crc_value[31];
        crc_value[25]   <= crc_value[24];
        crc_value[26]   <= crc_value[25];
        crc_value[27]   <= crc_value[26];
        crc_value[28]   <= crc_value[27];
        crc_value[29]   <= crc_value[28];
        crc_value[30]   <= crc_value[29];
        crc_value[31]   <= crc_value[31] ^ data_in ^ crc_value[31];
    end
    


endmodule : crc