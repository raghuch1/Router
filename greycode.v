`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.06.2024 18:49:06
// Design Name: 
// Module Name: greycode
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


module greycode(clk,reset,data_out);
input reset;
input clk;
output [2:0]data_out;
reg [2:0]data_in;


   always@(posedge clk)
         if(reset)
             data_in<=0;
         else
             data_in<=data_in+1;
             
 assign data_out[2] = data_in[2];
 assign data_out[1] = data_in[2]^data_in[1];
 assign data_out[0] = data_in[1]^data_in[0];
endmodule
