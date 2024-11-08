`ifndef COV
`define COV

class axi_cov;
  
  event axi_cg_e;
  axi_tx tx;
  covergroup axi_cg;
    ADDR_CP : coverpoint tx.addr {
              option.auto_bin_max = 8; // divide automatically the addresses into 8 differnt bolcks of address bins
    }
    WR_RD_CP : coverpoint tx.wr_rd {
      bins WR = {WRITE};
      bins RD = {READ};
    }
    
    ADDR_X_WR_RD_CP : cross ADDR_CP, WR_RD_CP;
    
  endgroup
  
  function new();
    axi_cg = new();
  endfunction
  
  
  
  task run();
    $display("axi_cov :: run");
    forever
       begin
         axi_common::mon2cov.get(tx);
         axi_cg.sample();
       end
  endtask
  
  
endclass

`endif
