`ifndef INF
`define INF

interface axi_inf(input logic aclk, arst);
  //write channels
  
  logic [3:0] awid;
  logic [31:0] awaddr;
  logic [3:0] awlen;
  logic [2:0] awsize;
  logic [1:0] awburst;
  logic [1:0] awlock;
  logic [3:0] awcache;
  logic [2:0] awprot;
  logic awqos;
  logic awregion;
  logic awvalid;
  logic awready;
  logic [3:0] wid;
  logic [31:0] wdata;
  logic [3:0] wstrb;
  logic wlast;
  logic wvalid;
  logic wready;
  logic [3:0] bid;
  logic [1:0] bresp;
  logic bvalid;
  logic bready;
  
  // read channels
  logic [3:0] arid;
  logic [31:0] araddr;
  logic [3:0] arlen;
  logic [2:0] arsize;
  logic [1:0] arburst;
  logic [1:0] arlock;
  logic [3:0] arcache;
  logic [2:0] arprot;
  logic arqos;
  logic arregion;
  logic arvalid;
  logic arready;
  logic [3:0] rid;
  logic [31:0] rdata;
  logic rlast;
  logic rvalid;
  logic rready;
  logic [1:0] rresp;
  
  clocking master_cb@(negedge aclk);
    default input #1 output #0;
    input arst;    
  output awid,
         awaddr,
         awlen,
         awsize,
         awburst,
         awlock,
         awcache,
         awprot,
         awqos,
         awregion,
         awvalid,
         wid,
         wdata,
         wstrb,
         wlast,
         wvalid,
         bready, 
         arid,
         araddr,
         arlen,
         arsize,
         arburst,
         arlock,
         arcache,
         arprot,
         arqos,
         arregion,
         arvalid,
         rready;

  input  wready,
         awready,
         bid,
         bresp,
         bvalid,
         arready,
         rid,
         rdata,
         rlast,
         rvalid,
         rresp;
  endclocking
  
  clocking monitor_cb @(negedge aclk);
    default input #1;
    
   input  arst,
         awid,
         awaddr,
         awlen,
         awsize,
         awburst,
         awlock,
         awcache,
         awprot,
         awqos,
         awregion,
         awvalid,
         awready,
         wid,
         wdata,
         wstrb,
         wlast,
         wvalid,
         bready, 
         arid,
         araddr,
         arlen,
         arsize,
         arburst,
         arlock,
         arcache,
         arprot,
         arqos,
         arregion,
         arvalid,
         rready,
         wready,
         bid,
         bresp,
         bvalid,
         arready,
         rid,
         rdata,
         rlast,
         rvalid,
         rresp;
    
  endclocking
  
  modport master_mp(input aclk, clocking master_cb);
    modport monitor_mp(input aclk, clocking monitor_cb);
  
endinterface

`endif
