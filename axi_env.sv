`ifndef ENV
`define ENV

`include "axi_bfm.sv"
`include "axi_mon.sv"
`include "axi_gen.sv"
`include "axi_cov.sv"
`include "axi_ref.sv"

class axi_env;
  
  axi_bfm bfm;
  axi_gen gen;
  axi_mon mon;
  axi_cov cov;
  axi_ref refn;
  
  function new();
    bfm = new();
    gen = new();
    mon = new();
    cov = new();
    refn = new();  
  endfunction
  
  task run();
    fork
      bfm.run();
      gen.run();
      mon.run();
      cov.run();
      refn.run();
    join
  endtask
  
endclass

`endif
    
