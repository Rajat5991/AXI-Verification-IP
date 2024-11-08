// Code your testbench here
// or browse Examples
`ifndef TOP
`define TOP
`include "axi_common.sv"
`include "axi_env.sv"
`include "axi_inf.sv"
`include "axi_assertion.sv"
`include "axi_slave.sv"

module top();
  
  reg clk, rst;
  
  axi_inf aif(clk, rst);
  axi_env env;
  
  
  initial
    begin
      clk = 0;
      forever #5 clk = ~clk;
    end
  
  initial
    begin
      $value$plusargs("testname = %s", axi_common::testname);
      axi_common :: vif = aif; // assigning physical interface handle to the virtual interface
      rst = 1;
      reset_design_inputs();
      @(posedge clk);
      rst = 0;
      env = new();
      env.run();
    end
  
  task reset_design_inputs();
  aif.awid = 0;
  aif.awaddr = 0;
  aif.awlen = 0;
  aif.awsize = 0;
  aif.awburst = 0;
  aif.awlock = 0;
  aif.awcache = 0;
  aif.awprot = 0;
  aif.awqos = 0;
  aif.awregion = 0;
  aif.awvalid = 0;
  aif.wid = 0;
  aif.wdata = 0;
  aif.wstrb = 0;
  aif.wlast = 0;
  aif.wvalid = 0;
  aif.bready = 0;
  aif.arid = 0;
  aif.araddr = 0;
  aif.arlen = 0;
  aif.arsize = 0;
  aif.arburst = 0;
  aif.arlock = 0;
  aif.arcache = 0;
  aif.arprot = 0;
  aif.arqos = 0;
  aif.arregion = 0;
  aif.arvalid = 0;
  aif.rready = 0; 
  endtask
  
  axi_assertion axi_assertion_i();
  // format .awid(aif.awid) 
  axi_slave dut(
   .aclk(aif.aclk),
   .arst(aif.arst),
   .awid(aif.awid),
   .awaddr(aif.awaddr),
   .awlen(aif.awlen),
   .awsize(aif.awsize),
   .awburst(aif.awburst),
   .awlock(aif.awlock),
   .awcache(aif.awcache),
   .awprot(aif.awprot),
   .awqos(aif.awqos),
   .awregion(aif.awregion),
   .awvalid(aif.awvalid),
   .awready(aif.awready),
   .wid(aif.wid),
   .wdata(aif.wdata),
   .wstrb(aif.wstrb),
   .wlast(aif.wlast),
   .wvalid(aif.wvalid),
   .wready(aif.wready),
   .bid(aif.bid),
   .bresp(aif.bresp),
   .bvalid(aif.bvalid),
   .bready(aif.bready),
 
   .arid(aif.arid),
   .araddr(aif.araddr),
   .arlen(aif.arlen),
   .arsize(aif.arsize),
   .arburst(aif.arburst),
   .arlock(aif.arlock),
   .arcache(aif.arcache),
   .arprot(aif.arprot),
   .arqos(aif.arqos),
   .arregion(aif.arregion),
   .arvalid(aif.arvalid),
   .arready(aif.arready),
   .rid(aif.rid),
   .rdata(aif.rdata),
   .rlast(aif.rlast),
   .rvalid(aif.rvalid),
   .rready(aif.rready),
   .rresp(aif.rresp)
  );
  
//   initial
//     begin
//       if(axi_common :: mismatch_count > 0)
//        begin
//         $display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
//         $display("$$$$$$$$$$$ ERROR $$$$$$$$$$$$$$");
//         $display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
//       end
//     end
  
  initial begin
      $dumpfile("dump.vcd");
      $dumpvars;
      #1000;
      $finish;
     end 
  
  
endmodule

`endif
