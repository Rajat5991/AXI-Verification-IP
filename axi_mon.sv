`ifndef MON
`define MON

class axi_mon;
  virtual axi_inf.monitor_mp vif;
  axi_tx tx, tx_t;
  task run();
    vif  = axi_common :: vif;
    $display("axi_mon :: run");
    forever begin
      @(posedge vif.aclk);
      if(vif.monitor_cb.awvalid && vif.monitor_cb.awready) // after handshake completed
        begin
          tx = new();
          tx.wr_rd = WRITE;
          tx.addr = vif.monitor_cb.awaddr;
          tx.len = vif.monitor_cb.awlen;
          tx.burst_size = burst_size_t'(vif.monitor_cb.awsize);
          tx.id = vif.monitor_cb.awid;
          tx.burst_type = burst_type_t'(vif.monitor_cb.awburst);
          tx.lock = lock_t'(vif.monitor_cb.awlock);
          tx.prot = vif.monitor_cb.awprot;
          tx.cache = vif.monitor_cb.awcache;
        end
      if(vif.monitor_cb.wvalid && vif.monitor_cb.wready) // after handshake completed
        begin
          tx.data_q.push_back(vif.monitor_cb.wdata);
        end
          
      if(vif.monitor_cb.bvalid && vif.monitor_cb.bready) // after handshake completed
        begin
          tx.resp = resp_t'(vif.monitor_cb.bresp);
          tx.print("AXI_TX :: WRITE_MONITOR");
          axi_common :: mon2cov.put(tx);
          axi_common :: mon2ref.put(tx);
        end
      
      if(vif.monitor_cb.arvalid && vif.monitor_cb.arready) // after handshake completed
        begin
          tx = new();
          tx.wr_rd = READ;
          tx.addr = vif.monitor_cb.araddr;
          tx.len = vif.monitor_cb.arlen;
          tx.burst_size = burst_size_t'(vif.monitor_cb.arsize);
          tx.id = vif.monitor_cb.arid;
          tx.burst_type = burst_type_t'(vif.monitor_cb.arburst);
          tx.lock = lock_t'(vif.monitor_cb.arlock);
          tx.prot = vif.monitor_cb.arprot;
          tx.cache = vif.monitor_cb.arcache;
        end
      if(vif.monitor_cb.rvalid && vif.monitor_cb.rready) // after handshake completed
        begin
          tx.data_q.push_back(vif.monitor_cb.rdata);
          tx.resp = resp_t'(vif.monitor_cb.rresp);
            if(vif.monitor_cb.rlast == 1) begin tx.print("AXI_TX :: READ_MONITOR");
             tx_t = new tx;
             axi_common :: mon2cov.put(tx_t);
             axi_common :: mon2ref.put(tx_t);
             tx = new(); // Once tx is written in to the mailbox, we should allocate tx again
          end
        end
    end    
  endtask
  
  
endclass

`endif
