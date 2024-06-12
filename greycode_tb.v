`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.06.2024 18:58:06
// Design Name: 
// Module Name: greycode_tb
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


module greycode_tb();
reg clk,reset;
wire [2:0]data_out;

greycode dut(clk,reset,data_out);

initial
begin
clk=0;
forever #5  clk= ~clk;
end

initial 
begin
#10;
reset =1'b1;
#10;
reset = 1'b0;
end
endmodule
