
#define APB3_DEVICE_BASE_ADDRESS        0x400

// Offsets
#define APB3_INPUT_DATA_REG_ADDR_OFFSET 0x0
#define APB3_RESULT_REG_ADDR_OFFSET     0x4
#define APB3_FLAGS_REG_ADDR_OFFSET      0x8
#define APB3_STATUS_REG_ADDR_OFFSET     0xC

// Real Addresses
#define APB3_INPUT_DATA_REG_ADDR (APB3_DEVICE_BASE_ADDRESS + APB3_INPUT_DATA_REG_ADDR_OFFSET)
#define APB3_RESULT_REG_ADDR     (APB3_DEVICE_BASE_ADDRESS + APB3_RESULT_REG_ADDR_OFFSET)
#define APB3_FLAGS_REG_ADDR      (APB3_DEVICE_BASE_ADDRESS + APB3_FLAGS_REG_ADDR_OFFSET)
#define APB3_STATUS_REG_ADDR     (APB3_DEVICE_BASE_ADDRESS + APB3_STATUS_REG_ADDR_OFFSET)


typedef struct {
    uint32_t    data        : 32;
}  INPUT_DATA_t;

typedef struct {
    uint32_t    value       : 16;
    uint32_t    rsrvd       : 16;
}  RESULT_t;

typedef struct {

    uint32_t  calc_start    : 1;    //| 0
    uint32_t  rsrvd1        : 15;   //| 15:1
    uint32_t  calc_finish   : 1;    //| 16
    uint32_t  rsrvd2        : 15;   //| 31:17

}  FLAGS_t;

typedef struct {
    uint32_t  value         : 32;
}  STATUS_t;

typedef struct {
    INPUT_DATA_t    input_data;
    RESULT_t        result;
    FLAGS_t         flags;
    STATUS_t        status;
} my_device_t;