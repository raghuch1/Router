`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.06.2024 15:09:12
// Design Name: MOD 12 COUNTER
// Module Name: Loadableupdownmod12
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

module loadableupdownmod12(reset,clock,mode,load,data_in,data_out);
input reset,clock,mode,load;
input [3:0]data_in;
output reg[3:0]data_out;


always @(posedge clock)
       if(reset)
           begin
              data_out<=0;
           end
       else if(load)    //load ==1 load the value
           data_out<=data_in;
          
       else if(mode ==0) 
       begin   // mode ==0 up counter 
	      if(data_out>4'b1011)
		      data_out<=0;
	      else
	                 data_out<=data_out+1;
	 end
       else    
       begin     //mode == 0 down counter
	      if((data_out<0))
		      data_out<=4'b1011;
	      else
                      data_out<=data_out-1; 
      end
endmodule