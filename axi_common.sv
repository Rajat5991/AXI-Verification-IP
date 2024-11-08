`ifndef AXI_COM
`define AXI_COM

`define WDATA_SIZE 4

typedef enum bit {
         READ,
         WRITE
}wr_rd_t;



typedef enum bit [2:0] {
  BURST_SIZE_1_BYTE,
  BURST_SIZE_2_BYTE,
  BURST_SIZE_4_BYTE,
  BURST_SIZE_8_BYTE,
  BURST_SIZE_16_BYTE,
  BURST_SIZE_32_BYTE,
  BURST_SIZE_64_BYTE,
  BURST_SIZE_128_BYTE
}burst_size_t; //number of bytes transferred in each transfer [2**burst_size]

typedef enum bit [1:0] {
  FIXED = 2'b00,
  INCR,
  WRAP,
  RSVD_BURST
}burst_type_t;

typedef enum bit [1:0] {
  NORMAL = 2'b00,
  EXCLUSIVE,
  LOCKED,
  RSVD_LOCKT
}lock_t;

typedef enum bit [1:0] {
  OKAY = 2'b00,
  EXOKAY,
  SLVERR,
  DECERR
}resp_t;

typedef enum bit [1:0] {
  LOW = 2'b00,
  MEDIUM,
  HIGH,
  DEBUG
}verb_t;

class axi_common;
  
  static mailbox gen2bfm = new();
  static mailbox mon2cov = new();
  static mailbox mon2ref = new();
  static virtual axi_inf vif;
  static integer tx_count = 1;
  static string testname = "test_1_wr_1_rd";
  static verb_t verbosity = MEDIUM;
  static int mismatch_count = 0;
endclass

`endif
