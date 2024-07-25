class counter_env;
   //Instantiate virtual interface with Write Driver modport,
   //Read Driver modport,Write monitor modport,Read monitor modport
    virtual counter_if.WR_DRV_MP wr_drv_if;
    virtual counter_if.WR_MON_MP wr_mon_if;
    virtual counter_if.RD_MON_MP rd_mon_if;

   //Declare 6 mailboxes parameterized by ram_trans and construct it
    mailbox #(counter_trans) gen2wr =new();
    mailbox #(counter_trans) wr2rm = new();
    mailbox #(counter_trans) rd2sb = new();
    mailbox #(counter_trans) rm2sb = new();

   //Create handle for ram_gen,ram_write_drv,ram_read_drv,ram_write_mon,
   //ram_read_mon,ram_model,ram_sb
     counter_gen gen_h;
     counter_write_drv wr_drv_h;
     counter_write_mon wr_mon_h;
     counter_read_mon rd_mon_h;
     counter_model ref_mod_h;
     counter_sb sb_h;

   //In constructor
   //pass the Driver and monitor interfaces as the argument
   //connect them with the virtual interfaces of ram_env
       function new (virtual counter_if.WR_DRV_MP wr_drv_if,
                     virtual counter_if.WR_MON_MP wr_mon_if,
                     virtual counter_if.RD_MON_MP rd_mon_if);  
          this.wr_drv_if = wr_drv_if;
          this.wr_mon_if = wr_mon_if;
          this.rd_mon_if = rd_mon_if;
       endfunction:new                 
   //In virtual task build
   //create instances for generator,Write Driver,Read Driver,
   //Write monitor,Read monitor,Reference model,Scoreboard
    virtual task build;
            gen_h = new(gen2wr);
            wr_drv_h = new(wr_drv_if,gen2wr);
            wr_mon_h = new(wr_mon_if,wr2rm);
            rd_mon_h = new(rd_mon_if,rd2sb);
            ref_mod_h = new(wr2rm,rm2sb);
            sb_h = new(rm2sb,rd2sb);
    endtask:build
   //Understand and include the virtual task reset_dut
    virtual task reset_dut();
            @(wr_drv_if.wr_drv_cb);
            wr_drv_if.wr_drv_cb.reset<=1;
           
    endtask:reset_dut
   //In virtual task start
   //call the start methods of generator,Write Driver,Read Driver,
   //Write monitor,Read Monitor,reference model,scoreboard
     virtual task start;
          gen_h.start();
          wr_drv_h.start();
          wr_mon_h.start();
          rd_mon_h.start();
          ref_mod_h.start();
          sb_h.start();
      endtask:start

   virtual task stop();
      wait(sb_h.DONE.triggered);
   endtask : stop 

   //In virtual task run, call reset_dut, start, stop methods & report function from scoreboard
     virtual task run();
         reset_dut();
         start();
         stop(); 
        sb_h.report();
     endtask:run
endclass:counter_env


