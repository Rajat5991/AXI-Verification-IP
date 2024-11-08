`ifndef GEN
`define GEN
`include "axi_tx.sv"
//`include "axi_common.sv"

class axi_gen;
  
  axi_tx tx;
  axi_tx txq[$];
  task run();
    $display("axi_gen :: run");
    case (axi_common :: testname)
      "test_5_wr": begin
                   repeat(5)
                     begin
                      tx = new();
                       assert(tx.randomize() with {tx.wr_rd == WRITE;});
                      axi_common :: gen2bfm.put(tx);
                     end
                   end
 "test_1_wr_1_rd": begin
   for (int i = 0; i < axi_common :: tx_count; i++) begin
                         tx = new();
                         assert(tx.randomize() with {wr_rd == WRITE;});
                         axi_common :: gen2bfm.put(tx);
                         txq[i] = new tx; // doing shallow copy because when tx = new is done again, it should not impact the tx's in the queue. If txq[i] = tx is done txq[i] will actually point to the tx pointer share same memory space which can corrupt in future iterations.
                       end
   for(int i = 0; i <  axi_common :: tx_count; i++)
                       begin
                         tx = new();
                        // tx.randomize() with {tx.wr_rd == READ;}; // read happen to random location 
                         assert(tx.randomize() with {wr_rd == READ;
                                              addr == txq[i].addr;
                                              len == txq[i].len; 
                                              burst_size == txq[i].burst_size;}); // making sure that, read also happen same a write
                         axi_common :: gen2bfm.put(tx);
                       end
                   end
    endcase
        
  endtask
  
  
endclass


`endif
