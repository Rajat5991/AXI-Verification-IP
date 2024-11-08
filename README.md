# AXI-Verification-IP
AXI Development
Concepts:

AXI VIP Development
Template environment coding
Adding new tests
Steps:

1. Setup AXI VIP Template environment

   a. Top(module) -> axi_tb -> axi_env -> axi_bfm, mon, gen, cov
   b. Each class has ‘run’ task
   c. Axi_slave.sv
      i. Coded as SV model (using module)
         Instantiate axi_bfm_slave in axi_env
         Connect using vif.axi_slave_modport
         This is called slave VIP (axi_module_slave + axi_monitor)
      ii. Coded as a module (using axi_slave module to model slave behavior)
          Instantiate axi_slave in top module
          Connect using ports
      
2. Top module

   a. Program block
   b. Rst, clk
   c. Generate clk, rst
   d. Axi_intf instantiation
   e. Pass vif handle to sub components (Try both in 2 different implementations)
       i. Using function new argument
       ii. Using static declaration
       iii. Same for testname, mailbox
            1. Pass testname, mailbox as task/function argument
            2. Using static declaration

3. Develop tests targeting AXI features

      a. Burst_len (test_burst_len)
      b. Burst_type (test_burst_type)
      c. Out of order (test_out_of_order)
      d. Multiple writes (test_multiple_writes)
      e. Multiple reads (test_multiple_reads)
      f. Write-reads (test_write_reads)
      g. Write to fixed addr (test_write_fixed_addr)
      h. Read to a fixed addr
      i. Write-to-fixed-addr, read, compare
      j. Locked types
      k. Protection types
   
4. Code axi_gen.sv (Try below 2 cases to implement tests)

    a. Case statement in run method to create different tests
        i. Implement scenario in case statement
    b. Write another example to implement tests in a separate SV file, instantiate test class in generator and call test_case.run method to run scenario
        i. Implement scenario in separate SV files, run method

5. BFM coding

    a. BFM should support both master and slave
       i. Master_slave_f = 1 => master mode
       ii. = 0 => slave mode
    b. If used in Master mode should drive transaction
       i. Get transaction
       ii. Call drive_tx(tx)
             1. Write_addr, write_data, write_resp
             2. Read_addr, read_data
    c. If used in slave mode should respond to master request Monitor coding

6. Monitor Coding
    a. Run method to monitor each channel handshaking signals
    b. Collect tx in various phases (addr phase, data phase, resp phase)
    c. Once tx collection is complete, put tx in mailbox connecting mon2cov
   
7. Coverage coding

   a. Get tx from mon2cov mailbox, sample axi_cg
   b. Write axi_cg with coverage on various fields
       i. Lock_type
       ii. Burst_type
       iii. Burst_len
       iv. Burst_size
       v. Prot_type
