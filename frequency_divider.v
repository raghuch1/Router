`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Raghucheepurupalli
// 
// Create Date: 12.05.2024 21:26:34
// Design Name: frequency divider
// Module Name: freq_divi
// Project Name:  frequency divider
// Target Devices: 
// Tool Versions: 
// Description: designed a frequency divider based upon input selection lines input (100MHZ) divide into small fractional frequencies..
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// module for selecting different frequencies based on selection lines. 
module freq_divi(input clock,input rst,input [1:0]sel,output reg [12:0]out);

wire [6:0]w1,w2,w3,w4;

freq100 f1(clock,rst,w1);
freq100 f2(w1[6],rst,w2);
freq100 f3(w2[6],rst,w3);
freq100 f4(w3[6],rst,w4); 

    always @(posedge clock) 
          begin
                case(sel)
                    2'b00 :out =w4[6];
                    2'b01 :out =w3[6];
                    2'b10 :out =w2[6];
                    2'b11 :out =w1[6];
                    default:out<=0;
                endcase       
             end 
             
      always @(posedge clock)
            begin
               if(rst)
                  out<=0;
               else
                 out<=out;
            end         
endmodule


////  module for frequency divider circuit (f/100)circuit..

module freq100(input clock,input rst,output reg[6:0]out);

always@(posedge clock)
    begin
      if(rst)
          out<=0;
      else if(out>100)
          out<=0;
      else 
          out<=out+1;
    end
endmodule
