`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.12.2024 19:08:34
// Design Name: 
// Module Name: processor_tb
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


module processor_tb();
reg [15:0] data_in;
reg clk,start;
wire done;
mul_datapath dp (eqz,lda,ldb,ldp,clrp,decb,data_in,clk);
controller con (lda,ldb,ldp,clrp,decb,done,clk,eqz,start);

initial begin 
 clk=1'b0;
 #3 start=1'b1;
 #500 $finish;
 end

always #5 clk=~clk;

initial begin 
#17 data_in=10;
#10 data_in=5;
end
initial begin
$monitor ($time," %d %b",dp.y,done);
$dumpfile("mul.vcd");

end
endmodule 

