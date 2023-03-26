package apb3_regmap_pkg;

    // source data
    // polynomous
    // output data
    // control & status

    typedef struct packed {
        logic   [6:0]       reserved4;          // RO
        logic               busy;               // RO
        logic   [6:0]       reserved3;          // RO
        logic               finish_status;      // RW - W1C
        logic   [6:0]       reserved2;          // RO
        logic               init;               // RW
        logic   [6:0]       reserved;           // RO
        logic               start;              // RW
    } control_reg_t;


    typedef struct packed {
        control_reg_t       control;            // Mixed
        logic   [31:0]      data_out;           // RO
        logic   [31:0]      data_in;            // RW
        logic   [31:0]      poly;               // RO
    } regmap_t;


endpackage : apb3_regmap_pkg