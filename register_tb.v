`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2024 12:27:53
// Design Name: 
// Module Name: REGISTER_TB
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


module REGISTER_TB();
reg clock,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state;
reg [7:0]data_in;
wire parity_done,err;
wire low_pkt_valid;
wire [7:0]data_out;
  
  
router_REGISTER dut(clock,resetn,pkt_valid,data_in,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,parity_done,low_pkt_valid,err,data_out);

integer i;
initial  
    begin 
      clock=1'b0;
    forever 
    #10 clock= ~clock;
    end
   
task packetgeneration;
     reg [7:0]payload_data,parity,header;
     reg [5:0]payload_len;
     reg [1:0]addr;
         begin
            @(negedge clock)
                 payload_len=6'd18;
                 addr=2'b10;
                 pkt_valid=1;
                 detect_add=1;
                 header={payload_len,addr};
                 parity=8'h00^header;
                 data_in=header;
                 @(negedge clock)
                  detect_add=0;
                  lfd_state=1;
                  full_state=0;
                  fifo_full=0;
                  laf_state=0;
                  for(i=0;i<payload_len;i=i+1)
                       begin 
                         @(negedge clock)
                            lfd_state=0;
                            ld_state=1;
                            payload_data={$random}%256;
                            data_in=payload_data;
                            parity=parity^data_in;
                       end  
                  @(negedge clock)
                  pkt_valid=0;
                  data_in=parity;
                  @(negedge clock)
                  ld_state=0;
           end
endtask

initial 
    begin
       resetn=0;
       #20;
       resetn=1;
       #10;
       packetgeneration;
       
      #100;
     $finish; 
       
    end          
endmodule
