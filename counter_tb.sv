`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.06.2024 15:43:24
// Design Name: 
// Module Name: counter_trans
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

class counter_trans;
   //rand property to the signals of dut
      rand logic reset;
      rand bit mode;
      rand bit load;
      rand bit[3:0] data_in;
    
    //output is we are getting from dut until it is xxxxxx  
      logic [3:0] data_out; /// 4 state variable
      
      constraint valid_data{data_in inside {[1:10]};}
      constraint valid_reset{reset dist {0:=90,1:=35};}
      constraint valid_load{load dist {0:=70,1:=30};}
      constraint valid_mode{mode dist{0:=50,1:=50};}      
      //keep an track of number of load and mode 
      static int trans_id;
      static int no_of_load0;
      static int no_of_load1;
      static int no_of_up;
      static int no_of_down;
      
      
      function void post_randomize();
             if(this.load==0)
                 no_of_load0++;
             if(this.load==1)
                 no_of_load1++;
             if(this.mode==1)
                 no_of_up++;
             if(this.mode==0)
                 no_of_down++;
             this.display("\tRANDOMIZED DATA");
              
      endfunction:post_randomize  
      
    

     virtual function void display(input string message);
      $display("=============================================================");
      $display("%s",message);
      if(message=="\tRANDOMIZED DATA")
         begin
            $display("\t_______________________________");
            $display("\tTransaction No. %d",trans_id);
            $display("\tload 0 No. %d", no_of_load0);
            $display("\tload 1No. %d", no_of_load1);
            $display("\tmode 0 No. %d", no_of_up);
            $display("\tmode 1 No. %d", no_of_down);
            $display("\t_______________________________");
         end
      $display("\tload=%d, mode=%d, reset=%d",load,mode,reset);
      $display("\tData=%d",data_in);
      $display("\tData_out= %d",data_out);
      $display("=============================================================");
   endfunction: display       
endclass:counter_trans

class counter_gen;
      counter_trans gen_trans;
      counter_trans data2send;
      
      mailbox #(counter_trans)gen2wr;
      function new( mailbox #(counter_trans)gen2wr);
             this.gen2wr = gen2wr;
             this.gen_trans = new;
      endfunction:new
      
      virtual task start();
            fork
                begin
                   for(int i=0;i<number_of_transactions; i++)
                       begin
                          gen_trans.trans_id++;
                          assert(gen_trans.randomize());
                          data2send =new gen_trans;
                          gen2wr.put(data2send);
                      end       
               end    
            join_none
      endtask:start        
endclass:counter_gen


class counter_write_drv;
       virtual counter_if.WR_DRV_MP wr_drv_if;
       
       counter_trans data2duv;
        
       mailbox #(counter_trans) gen2wr;
       
       function new(virtual counter_if.WR_DRV_MP wr_drv_if,mailbox #(counter_trans)gen2wr);
             this.wr_drv_if = wr_drv_if;
             this.gen2wr = gen2wr;
       endfunction:new
       
       virtual task drive();
              @(wr_drv_if.wr_drv_cb);
              wr_drv_if.wr_drv_cb.load<= data2duv.load;
              wr_drv_if.wr_drv_cb.data_in<= data2duv.data_in;
              wr_drv_if.wr_drv_cb.mode<= data2duv.mode;
              wr_drv_if.wr_drv_cb.reset<=data2duv.reset;
             
             
       endtask:drive  
          
       virtual task start();
           fork
              forever
                 begin  
                    gen2wr.get(data2duv);
                    drive();
                 end
           join_none
       endtask:start
                
endclass:counter_write_drv

class counter_write_mon;
    virtual counter_if.WR_MON_MP wr_mon_if;
    
    counter_trans data2rm;
    counter_trans wrdata;
    
    mailbox #(counter_trans) mon2rm;
    
    function new(virtual counter_if.WR_MON_MP wr_mon_if,
                mailbox #(counter_trans) mon2rm);
      this.wr_mon_if = wr_mon_if;
      this.mon2rm    = mon2rm;
      this.wrdata    = new;
   endfunction: new


   virtual task monitor();
      @(wr_mon_if.wr_mon_cb);
         wrdata.mode= wr_mon_if.wr_mon_cb.mode;
         wrdata.load =  wr_mon_if.wr_mon_cb.load;
         wrdata.data_in = wr_mon_if.wr_mon_cb.data_in; 
        wrdata.reset = wr_mon_if.wr_mon_cb.reset;  
       
   endtask: monitor  
         
   virtual task start();
      fork
       begin
         forever
            begin               
               monitor(); 
               data2rm = new wrdata;
               mon2rm.put(data2rm);
            end
        end
      join_none
   endtask: start
  
endclass:counter_write_mon


class counter_read_mon;

  
   virtual counter_if.RD_MON_MP rd_mon_if;

   counter_trans rddata, data2sb;

   //Declare two mailboxes 'mon2rm' and 'mon2sb' parameterized by type ram_trans
   mailbox #(counter_trans) mon2sb;
   
   //In constructor
   //Pass the following as the input arguments  
   //virtual interface 
   //mailbox handles 'mon2rm' and 'mon2sb' parameterized by ram_trans   
   //make the connections and allocate memory for 'rddata'

   function new(virtual counter_if.RD_MON_MP rd_mon_if,
                mailbox #(counter_trans) mon2sb);
      this.rd_mon_if = rd_mon_if;
      this.mon2sb    = mon2sb;
      this.rddata    = new;
   endfunction: new


   virtual task monitor();
      @(rd_mon_if.rd_mon_cb);
         rddata.data_out = rd_mon_if.rd_mon_cb.data_out;
         $display("DATA FROM READ MONITOR",rddata.data_out);    
      
   endtask: monitor
         
   virtual task start();
      fork
         forever
            begin
               
               monitor(); 
               
               data2sb = new rddata;
               //Put the transaction item into two mailboxes mon2rm and mon2sb
               mon2sb.put(data2sb);
            end
      join_none
   endtask: start

endclass: counter_read_mon

class counter_model;
  
   counter_trans w_data;
  
   static logic [3:0]ref_count=0;
 
   mailbox #(counter_trans) wr2rm;
   mailbox #(counter_trans) rm2sb;
 
   function new(mailbox #(counter_trans) wr2rm,
                mailbox #(counter_trans) rm2sb);
      this.wr2rm = wr2rm;
      this.rm2sb = rm2sb;
   endfunction:new


   virtual task mod12count(counter_trans model_counter);
       begin
          if(model_counter.reset)
             ref_count<=0;
          else if(model_counter.load)
             ref_count<= model_counter.data_in;
         
          else   
             begin
                    case(model_counter.mode)
                            1'b0:begin
                                if(ref_count>11)
                                   ref_count<=4'b0;
                                else
                                   ref_count<=ref_count+1'b1;
                                 end
                           1'b1:begin
                            if(ref_count<0)
                               ref_count<=4'd11;
                            else
                             ref_count<=ref_count-1'b1;
                          end
                    endcase
              // $display("the values are ",ref_count);       
              end
        end
   endtask:mod12count
   
   //In virtual task start
   virtual task start();
      //in fork join_none
      fork
         begin
            fork
               begin
                  forever 
                     begin
                        wr2rm.get(w_data);
                        mod12count(w_data);
                       w_data.data_out = ref_count; 
                        rm2sb.put(w_data);
                    end
               end
            join
         end
      join_none
   endtask: start

endclass: counter_model

class counter_sb;
   //Declare an event DONE
   event DONE; 

   int data_verified = 0;
   int ref_data = 0;
   int rm_data = 0;

  static int count_match;
  static int count_unmatch;

   counter_trans r_data;  
   counter_trans sb_data;
   counter_trans cov_data;
 
   mailbox #(counter_trans) rm2sb;      
   mailbox #(counter_trans) rdmon2sb; 
  
   covergroup mem_coverage;
            option.per_instance =1;
            data_in: coverpoint cov_data.data_in{
                              bins LOW ={[0:3]};
                              bins MID ={[4:6]};
                              bins HIGH = {[7:11]};}
            reset :coverpoint cov_data.reset;
            load : coverpoint cov_data.load;
            mode : coverpoint cov_data.mode;
            resetXloadXdata_in:cross reset,load,data_in,mode;
            
                                                                
   endgroup:mem_coverage    
   function new(mailbox #(counter_trans) rm2sb,
                mailbox #(counter_trans) rdmon2sb);
      this.rm2sb    = rm2sb;
      this.rdmon2sb = rdmon2sb;
      mem_coverage  = new;    
   endfunction: new
 
virtual task check( counter_trans rc_data);
     
         if(r_data.data_out ==rc_data.data_out)
            begin
             count_match++;
             $display("count matched",count_match);
            end
         else
            begin
             count_unmatch++;
             $display("count not matched",count_unmatch);
            end
      
       cov_data = new r_data;
       mem_coverage.sample();
       data_verified++;
       if(data_verified >= (number_of_transactions))
         begin
           ->DONE;
         end
     endtask:check

   virtual task start();
      fork
         while(1)
            begin
               rm2sb.get(r_data);
               ref_data++;              
               rdmon2sb.get(sb_data);   
               rm_data++;           
               check(sb_data);
            end
      join_none
   endtask: start

  
   //In virtual function report 
   //display rm_data_count, mon_data_count, data_verified 
   virtual function void report();
      $display(" ------------------------ SCOREBOARD REPORT ----------------------- \n ");
      $display(" %0d Read Data Generated, %0d Read Data Recevied, %0d Read Data Verified \n",
                                             ref_data,rm_data,data_verified);
      $display(" ------------------------------------------------------------------ \n ");
   endfunction: report
    
endclass: counter_sb
