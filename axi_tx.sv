`ifndef AXI_TX
`define AXI_TX

`include "axi_common.sv"

class axi_tx;
  rand bit [31:0] addr;
  rand bit [31:0] data_q[$];
  rand bit [3:0] len;
  rand bit wr_rd; //based on this below fields will be understood as either write related fields and read related fields
  rand burst_size_t burst_size; //number of size per beat
  rand bit [3:0] id; //aid = wid = bid, no need to declare all the id's 
  //wstrb is not required because it will be taken care by BFM
  rand burst_type_t burst_type;
  rand lock_t lock;
  rand bit [2:0] prot; // all three bits have different meaning
  rand bit [3:0] cache;
  rand resp_t resp;
  
  constraint data_q_c{
    data_q.size() == len + 1;
    addr % 4 == 0;
    //wr_rd == 1;
  }
  
  constraint rsvd_c{
    burst_type != RSVD_BURST;
    lock != RSVD_LOCKT;
  }
  
  constraint soft_c{
     soft resp == OKAY;
     soft burst_size == 2;
    soft burst_type == INCR;
    soft prot == 3'b0;
    soft cache == 4'b0;
    soft lock == NORMAL;
  }
  
  task print(input string name ="");
    $display("#######################");
    $display("### axi_tx :: print form %s ###", name);
    $display("#######################");
    $display("addr = %h",addr);
    $display("len = %d", len);
    foreach(data_q[i]) $display("data_q [%0d] = %0h",i,data_q[i]);
    $display("wr_rd = %s",wr_rd ? "WRITE" : "READ"); 
    $display("burst_size = %s",burst_size.name());
    $display("id = %h",id);
    $display("burst_type = %s",burst_type.name);
    $display("lock = %s",lock.name);
    $display("prot = %b",prot);
    $display("cache = %b",cache);
    $display("resp = %h",resp.name);
  endtask
endclass

`endif
