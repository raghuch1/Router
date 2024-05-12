`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Raghucheepurupalli
// 
// Create Date: 27.03.2024 19:21:18
// Design Name: fifo_tb
// Module Name: FIFO_tb
// Project Name: Router
// Target Devices: fpga
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


module FIFO_tb();
reg clock,resetn,write_enb,read_enb,soft_reset,lfd_state;
reg [7:0]data_in;

wire empty,full;
wire[7:0]data_out;
integer k;
FIFO DUT(clock,resetn,write_enb,read_enb,soft_reset,data_in,lfd_state,data_out,empty,full);

initial 
   begin
      clock=0;
      forever  
          #5 clock=~clock;
   end
   
task reset;
     begin 
        @(negedge clock)
             resetn=1'b0;
        @(negedge clock)
             resetn=1'b1;
     end  
 endtask
 
task write;
     reg [7:0]payloaddata,parity,header;
     reg [5:0] payloadlen;
     reg [1:0]addr;
     begin
        @(negedge clock)  
         payloadlen=6'd19;
         addr=2;
         header={payloadlen,addr};
         data_in=header;
         lfd_state=1;
         write_enb=1;
     for(k=0;k<payloadlen;k=k+1)
         begin
            @(negedge clock)
              lfd_state=0;
              payloaddata={$random}%256;
              data_in=payloaddata;
         end
      @(negedge clock)
      parity={$random}%256;
      data_in=parity;
      end   
 endtask       

task read;
    begin
       read_enb=1;
    end
endtask

task soft_rese( input i);
     begin
        soft_reset=i;
     end
endtask

initial
    begin 
       reset;
      
       write;
        read;
           
       
#200;  
$finish;  
end
endmodule
