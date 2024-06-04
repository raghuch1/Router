`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: self
// Engineer: Raghuch
// 
// Create Date: 22.05.2024 11:22:05
// Design Name: Constraint pattern
// Module Name: test
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

class patte;
   rand int da3[];
   int k;
   rand int m;
   constraint value2{m==0;}// make to zero so that addr_calc will not take random value
   constraint value{foreach(da3[i])
      m==i+1;}   // it will increase the m count to 1 2 3 4 .....         
   constraint size{da3.size==20;}   // size fixed to 20   
   constraint patt{foreach(da3[i])
      da3[i]== addr_calc(i);}    // constraint calling function         
                               
   function int addr_calc(int a);
            if(k>0)
                begin              
                 addr_calc=0;
                 k--;
                end
            else if(k<=0)
               begin                         
                        m=m+1;           
                        addr_calc=m;                
                        k=m;                                
                    end
                               
   endfunction:addr_calc
endclass:patte

module packet;

patte pa;
initial 
    begin
   pa = new;
   pa.randomize();  
   $display("%p",pa);  
    end
endmodule:packet




   /// constraint to generate a pattern 1 0 2 0 0 3 0 0 0 4 ..... upto last index in the dynamic array.
