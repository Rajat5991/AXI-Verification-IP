`ifndef AXI_REF
`define AXI_REF

class axi_ref;
  
  axi_tx tx;
  bit [7:0] mem[int]; //associative array
  bit [31:0] exp_data;
 // bit [1:0] ignore_comparision;
  
  task run();
    forever 
      begin
        axi_common :: mon2ref.get(tx);
        if(tx.wr_rd == WRITE)
           begin
             //$display("****************************************");
             //$display("************ Store WRITE Data **********");
             //$display("****************************************");
             for( int i = 0; i <= tx.len; i++) begin
               if(tx.burst_size == 0)
                 begin
                   if(tx.addr % `WDATA_SIZE == 0) mem[tx.addr] = tx.data_q[i][7:0];
                   if(tx.addr % `WDATA_SIZE == 1) mem[tx.addr] = tx.data_q[i][15:8];
                   if(tx.addr % `WDATA_SIZE == 2) mem[tx.addr] = tx.data_q[i][23:16];
                   if(tx.addr % `WDATA_SIZE == 3) mem[tx.addr] = tx.data_q[i][31:24];
                 end   
               if(tx.burst_size == 1)
                 begin
                   if(tx.addr % `WDATA_SIZE == 0) begin
                     mem[tx.addr] = tx.data_q[i][7:0];
                     mem[tx.addr+1] = tx.data_q[i][15:8];
                   end
                   if(tx.addr % `WDATA_SIZE == 2) begin
                     mem[tx.addr] = tx.data_q[i][23:16];
                     mem[tx.addr+1] = tx.data_q[i][31:24];
                   end
                 end
               if(tx.burst_size == 2)
                 begin
                   if(tx.addr % `WDATA_SIZE == 0) begin
                       begin
                        mem[tx.addr] = tx.data_q[i][7:0];
                        mem[tx.addr+1] = tx.data_q[i][15:8];
                        mem[tx.addr+2] = tx.data_q[i][23:16];
                        mem[tx.addr+3] = tx.data_q[i][31:24];
                      end
                      //ignore_comparision ++; //ignore_comparision + 1;
                    // $display("****************************************");
                    // $display("************ Store WRITE Data **********");
                    // $display("****************************************");
                   end
                 end  
               tx.addr = tx.addr + 2**tx.burst_size;
             end
           end
        
        if(tx.wr_rd == READ)
           begin
            // data_q.delete();
            for( int i = 0; i <= tx.len; i++) begin
             if(tx.burst_size == 2)
                 begin
                   if(tx.addr % `WDATA_SIZE == 0) begin
                     exp_data[7:0] = mem[tx.addr];
                     exp_data[15:8] = mem[tx.addr+1];
                     exp_data[23:16] = mem[tx.addr+2];
                     exp_data[31:24] = mem[tx.addr+3];
                     tx.addr = tx.addr + 2**tx.burst_size;
                   end
                   if(exp_data == tx.data_q[i]) begin
                     $display("#### Write data match with read data ####");
                   end
                   else 
                     begin
                      // $error("#### Write data mismatch with read data, ref_model data = %h and dut_data =%h ####", exp_data,tx.data_q[i]); 
                       //axi_common :: mismatch_count ++;
                     end
                 end  
             end
           end
         
       end
    endtask
        
endclass

`endif
        
        
  
  
