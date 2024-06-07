`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: RAGHU CH
// 
// Create Date: 12.05.2024 21:51:26
// Design Name: 
// Module Name: freq100
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


module freq100_tb();
reg clock,rst;
reg [1:0]sel;
wire out;

freq_divi dut(clock,rst,sel,out);
//clock for 100 MHZ frequency....
initial
      begin 
          clock=1'b0;
       forever
           #5 clock=~clock;
      end
initial 
begin
sel=3;
rst=1;
#10;
rst=0;

end
endmodule
