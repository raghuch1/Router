interface counter_if(input bit clock);
   
   logic [3:0] data_in;
   logic [3:0] data_out;
   logic load;
   logic mode;
   logic reset;
  

   //Write Driver clocking block
   clocking wr_drv_cb@(posedge clock);
      default input #1 output #1;
      output data_in;
      output load;
      output mode;
      output reset;
   endclocking: wr_drv_cb
 

   //Write monitor clocking block
   clocking wr_mon_cb@(posedge clock);
      default input #1 output #1;
      input load;
      input mode;
      input reset;
      input data_in;
   endclocking: wr_mon_cb
   
   //Read monitor clocking block
   clocking rd_mon_cb@(posedge clock);
      default input #1 output #1;
      input data_out;
   endclocking: rd_mon_cb

   //Write Driver modport
   modport WR_DRV_MP (clocking wr_drv_cb);

   //Write Monitor modport
   modport WR_MON_MP (clocking wr_mon_cb);

   //Read Monitor modport
   modport RD_MON_MP (clocking rd_mon_cb);
    

endinterface: counter_if
