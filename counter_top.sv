 module top();

   //Import ram_pkg
   import counter_pkg::*;  
  
   parameter cycle = 10;
 
   reg clock;

   //Instantiate the interface
   counter_if DUV_IF(clock);

   //Declare an handle for the test as test_h
   test test_h;
  
   //Instantiate the DUV

   loadableupdownmod12 counter ( .clock (clock),
                  .data_in    (DUV_IF.data_in),
                  .data_out   (DUV_IF.data_out),
                  .load (DUV_IF.load),
                  .mode (DUV_IF.mode),
                  .reset (DUV_IF.reset)
                ); 
   
   //Generate the clock
   initial
      begin
         clock = 1'b0;
         forever #(cycle/2) clock=~clock;
      end

   initial
      begin
	 
	`ifdef VCS
         $fsdbDumpvars(0, top);
        `endif

	//Create the object for test and pass the interface instances as arguments
         test_h = new(DUV_IF, DUV_IF, DUV_IF);
         number_of_transactions = 200;
         //Call the virtual task build and virtual task run
         test_h.build();
         test_h.run();
         $finish;
      end
   
endmodule

