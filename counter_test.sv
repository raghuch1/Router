class test;

   //Instantiate virtual interface with Write Driver modport, Read Driver modport, 
   //Write monitor modport, Read monitor modport
   virtual counter_if.WR_DRV_MP wr_drv_if; 
   virtual counter_if.RD_MON_MP rd_mon_if; 
   virtual counter_if.WR_MON_MP wr_mon_if;
   
   //Declare a handle for ram_env 
   counter_env env_h;
     
   //In constructor
   //pass the Driver interface and monitor interface as arguments
   //create an object for env_h and pass the virtual interfaces 
   //as arguments in new() function
   function new(virtual counter_if.WR_DRV_MP wr_drv_if, 
                virtual counter_if.WR_MON_MP wr_mon_if,
                virtual counter_if.RD_MON_MP rd_mon_if);
      this.wr_drv_if = wr_drv_if;
      this.wr_mon_if = wr_mon_if;
      this.rd_mon_if = rd_mon_if;
      
      env_h = new(wr_drv_if,wr_mon_if,rd_mon_if);
   endfunction: new

   // Understand and include the virtual task build 
   // which builds the TB environment
   virtual task build();
      env_h.build();
   endtask: build
   
   // Understand and include the virtual task run 
   // which runs the simulation for different testcases
   virtual task run();              
      env_h.run();
   endtask: run
   
endclass: test


