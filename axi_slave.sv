module axi_slave #( parameter WIDTH = 32)(
  input logic aclk, arst,
  input [3:0] awid,
  input [WIDTH-1:0] awaddr,
  input [3:0] awlen,
  input [2:0] awsize,
  input [1:0] awburst,
  input [1:0] awlock,
  input [3:0] awcache,
  input [2:0] awprot,
  input awqos,
  input awregion,
  input awvalid,
  output reg awready,
  input [3:0] wid,
  input [WIDTH-1:0] wdata,
  input [3:0] wstrb,
  input wlast,
  input wvalid,
  output reg wready,
  output reg [3:0] bid,
  output reg [1:0] bresp,
  output reg bvalid,
  input bready,
  
  // read channels
 input  [3:0] arid,
 input  [WIDTH-1:0] araddr,
 input  [3:0] arlen,
 input  [2:0] arsize,
 input  [1:0] arburst,
 input  [1:0] arlock,
 input  [3:0] arcache,
 input  [2:0] arprot,
 input arqos,
 input arregion,
 input arvalid,
 output reg arready,
 output reg [3:0] rid,
 output reg [WIDTH-1:0] rdata,
 output reg rlast,
 output reg rvalid,
 input reg rready,
 output reg [1:0] rresp);
  
  // slave memory
  
  reg [WIDTH-1:0] mem[int];
  reg [WIDTH-1 : 0] awaddr_t;
  reg [3:0] awlen_t;
  reg [2:0] awsize_t;
  reg [1:0] awburst_t;
  reg [3:0] awid_t ;
  reg [1:0] awlock_t;
  reg [2:0] awprot_t;
  reg [3:0] awcache_t;
  int write_count = 0;
  reg [WIDTH-1 : 0] araddr_t;
  reg [3:0] arlen_t;
  reg [2:0] arsize_t;
  reg [1:0] arburst_t;
  reg [3:0] arid_t ;
  reg [1:0] arlock_t;
  reg [2:0] arprot_t;
  reg [3:0] arcache_t;
  int read_count = 0;
  
  bit ignore_1st_beat_f;
  
  
  always @(posedge aclk)
    begin
      
      if (arst == 1) begin
         arready = 0;
         wready = 0;
         awready = 0;
         rid = 0;
         rdata = 0;
         rlast = 0;
         rvalid = 0;
         bid =0 ;
         bresp = 2'bxx;
         bvalid =0; 
      end
      
     // WA channel handshake
      if(awvalid == 1) begin
          awready = 1;
        //SLAVE is collecting the write address information in to temp variables
          awaddr_t = awaddr;
          awlen_t = awlen;
          awsize_t = awsize;
          awburst_t = awburst;
          awid_t = awid;
          awlock_t = awlock;
          awprot_t = awprot;
          awcache_t = awcache;
          ignore_1st_beat_f = 1;
      end
       else begin
          awready = 0;
       end
      
      // WDATA Channel handshake
      if(wvalid == 1) begin
          wready = 1;
          // collect write data
        
        if(ignore_1st_beat_f == 0) begin
          store_write_data();
        end
          ignore_1st_beat_f = 0;
          write_count++; //check if write_count == awlen_t +1;
          if(wlast == 1) begin
            if(write_count != awlen_t +1) begin
              $error("Write bursts are not matching write_count = %d & awlen=%d",write_count,awlen_t);
            end
            write_resp_phase(wid);
          end     
      end
       else begin
          wready = 0;
       end
      
      // RA Channel handshake
      if (arvalid == 1) begin
            arready = 1;
            araddr_t = araddr;
            arlen_t = arlen;
            arsize_t = arsize;
            arburst_t = arburst;
            arid_t = arid;
            arlock_t = arlock;
            arprot_t = arprot;
            arcache_t = arcache;
            drive_read_data();
      end
      else
         begin
            arready = 0;
         end
    end    
 
  task write_resp_phase(input [3:0] id);
    @(posedge aclk);
    bvalid = 1;
    bid = id;
    bresp = 2'b00; //OKAY
    wait (bready == 1);
    @(posedge aclk);
    bvalid = 1;
    bid = 0;
    bresp = 2'bxx;
    @(posedge aclk);
    bvalid = 0;
  endtask
  
  task store_write_data();
    
    if(awsize_t == 0) begin
      mem[awaddr_t] = wdata[7:0];
    end
    
    if(awsize_t == 2) begin
      mem[awaddr_t] = wdata[7:0];
      mem[awaddr_t+1] = wdata[15:8];
    end
    
    if(awsize_t == 2) begin
      mem[awaddr_t] = wdata[7:0];
      mem[awaddr_t+1] = wdata[15:8];
      mem[awaddr_t+2] = wdata[23:16];
      mem[awaddr_t+3] = wdata[31:24];
    end
    // slave should internally update its address, because whatever next data comes it should srore to next address as per burst type [we have selected 4 bust size of 4 bytes]
    awaddr_t += 2**awsize_t;
    // we need to do wrap under boundary check, if it crosses, then do wrap to lower update : TODO
  endtask
  
task drive_read_data();
  for(int i = 0; i <= arlen_t +1; i++) begin
      @(posedge aclk)
    if(arsize_t == 0) begin
      rdata[7:0] = mem[araddr_t] ;
    end
    
    if(arsize_t == 2) begin
      rdata[7:0] = mem[araddr_t];
      rdata[15:8] =  mem[araddr_t+1];
    end
    
    if(arsize_t == 2) begin
      rdata[7:0] = mem[araddr_t];
      rdata[15:8] = mem[araddr_t+1];
      rdata[23:16] = mem[araddr_t+2];
      rdata[31:24] = mem[araddr_t+3];
    end
    
    rvalid = 1;
    rid = arid_t;
    rresp = 2'b00;//OKAY
    if(i == arlen_t) rlast = 1; // transfer the last data
    wait(rready == 1);
     // slave should internally update its address, because whatever next data comes it should srore to next address as per burst type [we have selected 4 bust size of 4 bytes]
    araddr_t += 2**arsize_t;
    // we need to do wrap under boundary check, if it crosses, then do wrap to lower update : TODO
 end
 // @(posedge aclk)
   rvalid = 0;
   rid = 0;
   rdata = 0;
   rresp = 2'bxx;
   rlast = 0;
    
endtask
    
      
  
endmodule
