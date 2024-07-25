package counter_pkg;

   int number_of_transactions=1;

   //include the files
   //"ram_trans.sv","ram_gen.sv","ram_write_drv.sv"
   //"ram_read_drv.sv","ram_write_mon.sv","ram_read_mon.sv"
   //"ram_model.sv","ram_sb.sv","ram_env.sv","test.sv"
    
     `include "counter_trans.sv"
     `include "counter_env.sv"
     `include "counter_test.sv"


endpackage
