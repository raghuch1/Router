// New code for verification of parallel read and write RAM

// IN UVM 

import uvm_pkg::*;
`include "uvm_macros.svh"

class ram_xtn extends uvm_sequence_item;
  `uvm_object_utils(ram_xtn)
  
  function new(string name="ram_xtn");
    super.new(name);
  endfunction
  
  //write signals
  rand bit rst;
  rand bit[11:0]waddr;
  rand bit[31:0]wdata;
  rand bit write;
  
  //read signals
  rand bit[11:0]raddr;
  rand bit read;
  logic [31:0]rdata;
  
  bit[11:0]address;
  
  constraint val0{raddr ==address;}
  
  function void post_randomize();
    address = waddr;
  endfunction
  
  constraint val{read dist {1:=80 ,0:=20};}
  
  constraint val1{write dist {1:=80 ,0:=20};}
  
  constraint val2{rst dist {1:=20 ,0:=80};}
endclass

class ram_seq extends uvm_sequence#(ram_xtn);
  `uvm_object_utils(ram_seq)
  
  ram_xtn  xtn;
  
  function new(string name="ram_seq");
    super.new(name);
  endfunction 
  
  virtual task body();
    xtn = ram_xtn::type_id::create("xtn");
    repeat(10)
      begin
        start_item(xtn);
        xtn.randomize();
        finish_item(xtn);
      end
  endtask
endclass

class driver extends uvm_driver#(ram_xtn);
  `uvm_component_utils(driver)
  
  virtual intf vif;
  
  ram_xtn xtn;
  
  function new(string name="driver",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual intf)::get(this,"*","vif",vif))
      `uvm_fatal("you have not set",get_type_name);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever 
      begin
        seq_item_port.get_next_item(xtn);
        @(negedge vif.clk);
        vif.rst<=xtn.rst;
        vif.waddr<=xtn.waddr;
        vif.wdata<=xtn.wdata;
        vif.write<=xtn.write;
        //@(negedge vif.clk);
        vif.read<=xtn.read;
        vif.raddr<=xtn.raddr;      
        $display(" driver %d %d %d %d %d %d %d %d",xtn.rst,xtn.waddr,xtn.wdata,xtn.write,xtn.read,xtn.raddr,xtn.rdata,$time);
        repeat(2)
          @(vif.drvcb); 
        seq_item_port.item_done();
        end
  endtask
  
endclass

class sequencer extends uvm_sequencer#(ram_xtn);
  `uvm_component_utils(sequencer)
  
  function new(string name="sequencer",uvm_component parent);
    super.new(name,parent);
  endfunction
endclass

class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  uvm_analysis_port#(ram_xtn) ap;
  
  ram_xtn xtn;
  
  virtual intf vif;
  
  function new(string name="monitor",uvm_component parent);
    super.new(name,parent);
    ap = new("ap",this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual intf)::get(this,"*","vif",vif))
      `uvm_fatal("have youset it",get_type_name);
    
    xtn = ram_xtn::type_id::create("xtn");
  endfunction
  
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    repeat(10)
      begin
        @(negedge vif.clk);
        //@(negedge vif.clk);
        @(vif.moncb);
        xtn.rst=vif.rst;
        xtn.waddr=vif.waddr;
        xtn.wdata=vif.wdata;
        xtn.write=vif.write;
        xtn.read=vif.read;
        xtn.raddr=vif.raddr;
        @(vif.moncb);
        xtn.rdata=vif.rdata;
        //@(vif.moncb);
        $display(" monitor %d %d %d %d %d %d  %d  %d",xtn.rst,xtn.waddr,xtn.wdata,xtn.write,xtn.read,xtn.raddr,xtn.rdata,$time);
        ap.write(xtn);
      end
  endtask
endclass

class agent extends uvm_agent;
  `uvm_component_utils(agent)
   
  driver drvh;
  sequencer sqrh;
  monitor monh;
  
  function new(string name="agent",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drvh = driver::type_id::create("drvh",this);
    sqrh = sequencer::type_id::create("sqrh",this);
    monh = monitor::type_id::create("monh",this);
    
    uvm_top.print_topology();
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drvh.seq_item_port.connect(sqrh.seq_item_export);
  endfunction
endclass

class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  
  bit[31:0] mem[0:4096];
  
  bit[11:0] address[$];
  
  uvm_analysis_imp#(ram_xtn,scoreboard) ap_imp;
  
  function new(string name="scoreboard",uvm_component parent);
    super.new(name,parent);
    
    ap_imp = new("ap_imp",this);
  endfunction
  
  virtual function void write(ram_xtn xtn);
    $display("scoreboard");
    if(xtn.rst)
      begin
        if(xtn.rdata==0)
          $display("reset working fine");
        else
          $display("reset not working");
      end
    else
      begin
        if(xtn.write)
          begin
            mem[xtn.waddr]<=xtn.wdata;
            address.push_back(xtn.waddr);
            $display("writing");
          end
        if(xtn.read)
          begin
            for(int i=0;i<$size(address);i++)
              begin
                if(address[i]==xtn.raddr)
                  begin
                    if(mem[xtn.raddr]==xtn.rdata)
                      $display("dut working");
                    else
                      $display("not working");
                    break;
                  end                
                else
                  begin
                    if(i==$size(address)-1)
                      $display("first enter the data ");
                    else
                      continue;
                  end
              end
          end                         
      end
  endfunction
endclass

class environment extends uvm_env;
  `uvm_component_utils(environment)
  
  agent agnth;
  scoreboard scbd;
  
  function new(string name="environment",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agnth = agent::type_id::create("agnth",this);
    scbd = scoreboard::type_id::create("scbd",this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agnth.monh.ap.connect(scbd.ap_imp);
  endfunction
endclass

class test extends uvm_test;
  `uvm_component_utils(test)
  
  environment envh;
  
  ram_seq seq;
  
  function new(string name="test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    envh = environment::type_id::create("env",this);
    seq = ram_seq::type_id::create("seq");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    seq.start(envh.agnth.sqrh);
    phase.drop_objection(this);
  endtask
endclass


module top;
  
  test t1;
  
  bit clk;
  
  intf vif(clk);
  
  initial begin
    clk = 1;
    forever #5 clk=!clk;
  end
  
  ram dut(.clk(clk),.rst(vif.rst),.waddr(vif.waddr),.raddr(vif.raddr),.wdata(vif.wdata),.write(vif.write),.read(vif.read),.rdata(vif.rdata));
  
  initial begin
    uvm_config_db#(virtual intf)::set(null,"*","vif",vif);
    t1 = test::type_id::create("t1",null);
    run_test();
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #400 $finish;
  end
endmodule

interface intf(input bit clk);
  logic rst;
  logic [11:0]waddr;
  logic [31:0]wdata;
  logic write;
  
  //read signals
  logic [11:0]raddr;
  logic [31:0]rdata;
  logic read;
  
  clocking drvcb@(posedge clk);
    default input #1 output #1;  
    
    output rst,waddr,wdata,write,raddr,read;
  endclocking
  
  clocking moncb@(posedge clk);
    default input #1 output #1;
    
    input rst,waddr,wdata,write,raddr,read,rdata;
  endclocking
  
  modport drv(clocking drvcb);
  modport mon(clocking moncb);
  
endinterface


//IN verilog basic testbench
/*module test;
  
  reg clk,rst,write,read;
  reg [11:0]waddr,raddr;
  reg [31:0]wdata;
  wire [31:0]rdata;
  
  
  initial
    begin
      clk=0;
      forever #5 clk = ~clk;
    end
  
  ram dut(clk,rst,waddr,raddr,wdata,write,read,rdata);
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    rst = 1;
    #10;
    rst =0;
    #10;
    write =1;
    read =1;
    begin
      fork
          for(int i=0;i<13;i++)
            begin
              @(negedge clk)
              waddr =i;
              wdata =i**2;
            end
          for(int i=0;i<13;i++)
            begin
              #2;
              @(negedge clk);
              raddr =i;
              
            end
      join
    end
    
    
    #300 $finish;
  end
  
  
endmodule*/
