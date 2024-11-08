`ifndef BFM
`define BFM

`include "axi_tx.sv"
//`include "axi_common.sv"

class axi_bfm;
  
  virtual axi_inf.master_mp vif; //virtual interface
  wr_rd_t wr_rd; 
  axi_tx tx;
  
  task run();
    $display("axi_bfm :: run");
    vif = axi_common :: vif;
    forever
      begin
        axi_common :: gen2bfm.get(tx);
        if(axi_common :: verbosity == MEDIUM) tx.print("AXI_TX :: BFM");
        drive_tx(tx);
      end
  endtask
  
  task drive_tx(axi_tx tx);
    case (tx.wr_rd)
              WRITE: begin
                     write_addr_phase(tx);
                     write_data_phase(tx);
                     write_resp_phase(tx);
                     end
              READ: begin
                     read_addr_phase(tx);
                     read_data_phase(tx);
                    end
    endcase
  endtask
  
  task write_addr_phase(axi_tx tx);
    $display("write address phase");
    @(negedge vif.aclk);
    //$display("write 2 address phase");
    vif.master_cb.awaddr <= tx.addr;
    vif.master_cb.awid <= tx.id;
    vif.master_cb.awlen <= tx.len;
    vif.master_cb.awsize <= tx.burst_size;
    vif.master_cb.awburst <= tx.burst_type;
    vif.master_cb.awlock <= tx.lock;
    vif.master_cb.awcache <= tx.cache;
    vif.master_cb.awprot <= tx.prot;
    vif.master_cb.awqos <= 1'b0;
    vif.master_cb.awregion <= 1'b0;
    vif.master_cb.awvalid <= 1;
    wait (vif.master_cb.awready == 1); // waiting for the handshake to complete
    @(negedge vif.aclk);
    vif.master_cb.awaddr <= 0;
    vif.master_cb.awid <= 0;
    vif.master_cb.awlen <= 0;
    vif.master_cb.awsize <= 0;
    vif.master_cb.awburst <= 0;
    vif.master_cb.awlock <= 0;
    vif.master_cb.awcache <= 0;
    vif.master_cb.awprot <= 0;
    vif.master_cb.awvalid <= 0; 
  endtask
  
  task write_data_phase(axi_tx tx);
    $display("write data phase");
    for(int i =0; i< tx.len+1; i++)
      begin
        @(negedge vif.aclk)
        vif.master_cb.wdata <= tx.data_q.pop_front();
        vif.master_cb.wid <= tx.id;
        vif.master_cb.wstrb <= 4'hf;
        vif.master_cb.wlast <= (i == tx.len) ? 1 : 0;
        vif.master_cb.wvalid <= 1;
        wait(vif.master_cb.wready == 1);
         @(negedge vif.aclk);
         //if(i == tx.len) begin
         vif.master_cb.wdata <= 0;
         vif.master_cb.wid <= 0;
         vif.master_cb.wstrb <= 0;
         vif.master_cb.wlast <= 0;
         vif.master_cb.wvalid <= 0; 
        // end
      end
        
  endtask
  
  task write_resp_phase(axi_tx tx);
    $display("write response phase");
    @(negedge vif.aclk);
    wait(vif.master_cb.bvalid == 1);
   // while(vif.master_cb.bvalid == 0) begin
    //  @(negedge vif.aclk);
   // end
    vif.master_cb.bready <= 1;
    @(negedge vif.aclk);
    vif.master_cb.bready <= 0;
  endtask
  
  task read_addr_phase(axi_tx tx);
    $display("read address phase");
    @(negedge vif.aclk);
    vif.master_cb.araddr <= tx.addr;
    vif.master_cb.arid <= tx.id;
    vif.master_cb.arlen <= tx.len;
    vif.master_cb.arsize <= tx.burst_size;
    vif.master_cb.arburst <= tx.burst_type;
    vif.master_cb.arlock <= tx.lock;
    vif.master_cb.arcache <= tx.cache;
    vif.master_cb.arprot <= tx.prot;
    vif.master_cb.arqos <= 1'b0;
    vif.master_cb.arregion <= 1'b0;
    vif.master_cb.arvalid <= 1;
    wait (vif.master_cb.arready == 1); // waiting for the handshake to complete
    @(negedge vif.aclk);
    vif.master_cb.araddr <= 0;
    vif.master_cb.arid <= 0;
    vif.master_cb.arlen <= 0;
    vif.master_cb.arsize <= 0;
    vif.master_cb.arburst <= 0;
    vif.master_cb.arlock <= 0;
    vif.master_cb.arcache <= 0;
    vif.master_cb.arprot <= 0;
    vif.master_cb.arvalid <= 0;
  endtask
  
  task read_data_phase(axi_tx tx);
    tx.data_q.delete(); // Since Master is expecting to receive new data from the slave
    $display("read data phase");
    for(int i = 0; i<= tx.len + 1; i++) begin
      while (vif.master_cb.rvalid == 0) begin
        @(negedge vif.aclk); // waiting for rvalid to be 0 at each posedge of the clk
      end
      tx.data_q.push_back(vif.master_cb.rdata);
      vif.master_cb.rready <= 1;
      @(negedge vif.aclk)
      vif.master_cb.rready <=0;
    end
  endtask   
  
  
endclass


`endif
