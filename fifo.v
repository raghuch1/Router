`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Raghucheepurupalli
// 
// Create Date: 27.03.2024 16:28:52
// Design Name: fifo.v
// Module Name: FIFO
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
// 
//lfd_state is used to find the header bite it is used to distingusih header block and payload 
//without header bite.

module fifo(clock,resetn,data_in,read_enb,write_enb,data_out,full,empty,lfd_state,soft_reset);
                          
parameter width=9,depth=16;
input lfd_state;
input [width-2:0] data_in;
input clock,resetn,read_enb,write_enb,soft_reset;
reg [4:0]rd_pointer,wr_pointer;
output reg [width-2:0] data_out;
reg [6:0]count;

output full,empty;
integer i;

reg [width-1:0] mem[depth-1:0];
reg temp;
reg [7:0]data_out1;

assign full=((wr_pointer[4] != rd_pointer[4]) && (wr_pointer[3:0]==rd_pointer[3:0]));
assign empty= wr_pointer==rd_pointer;

always@(posedge clock)
begin
  if(~resetn)
  begin
    temp=0;
    wr_pointer<=0;
    rd_pointer<=0;
    end
  else 
    temp=lfd_state;
end

//write
always@(posedge clock)
begin 
  if(~resetn)
    begin 
      //data_out<=0;
      for(i=0;i<=15;i=i+1)
         mem[i]<=0;
    end
  else if(soft_reset)
    begin
      // data_out=0;
       for(i=0;i<=15;i=i+1)
        mem[i]<=0;
    end
  else if(write_enb && !full)
    begin
      if(lfd_state)
        {mem[wr_pointer[3:0]][8],mem[wr_pointer[3:0]][7:0]}<={temp,data_in};
    else
        begin
        {mem[wr_pointer[3:0]][8],mem[wr_pointer[3:0]][7:0]}<={temp,data_in};
        //Swr_pointer<=wr_pointer+1;
        end
     end
end

//read
always@(posedge clock)
begin 
     if(~resetn)
       begin 
         data_out <= 0;
        /* for(i=0;i<=15;i=i+1)
            mem[i]<=0;*/
       end
else if(soft_reset)
      begin
	      data_out <= 'bz;
      end
else if(read_enb && !empty)
      begin
         data_out <= mem[rd_pointer[3:0]][7:0];
        data_out1<=data_out;
        // count<=count-1;
         //rd_pointer<=rd_pointer+1;
      end
      else if(count==0 && data_out != 0)
      data_out <= 8'bzzzzzzzz;
end
         
//counter
always@(posedge clock)
begin
//if(~resetn)
//count<=0;
//else if(soft_reset)
//count<=0;
 if(read_enb && !empty)
     begin
      if(mem[rd_pointer[3:0]][8])
         begin
          count <= mem[rd_pointer[3:0]][7:2]+1;
          end
     else
       if(count!=0)
         begin
         count <= count-1;
         end
    end  
end
     
always@(posedge clock)
begin
  if(~resetn || soft_reset)
	begin
      rd_pointer <= 0;
      wr_pointer <= 0;
	end
	else
	begin
      if(write_enb && !full)
          wr_pointer <= wr_pointer+1;
      if(read_enb && !empty)
          rd_pointer <= rd_pointer+1;
	end
end                
endmodule
