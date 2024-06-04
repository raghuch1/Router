`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2024 11:22:05
// Design Name: 
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

/*module test;
   int da[];
   initial begin
        da = new[20]; 
        for(int i=0;i<21;i++)
             begin
                 if(i<=9)
                     begin
                      da[i]=$urandom_range(1,10);                   
                     end
                 else if(10<=i<=19)
                      begin
                         da[i]=$urandom_range(10,20);
                         if(i==10)
                            begin
                                $display("the contents are %p",da[0:9]);
                            end    
                      end
             end
          
                 $display("the contents are %p",da[0:9]);
                 $display("the cintents are %p",da);
     
        end
endmodule





/*module test1;
    int da[];
       initial begin
          da = new[10];
          foreach(da[i])
                begin
                      da[i]=$urandom_range(1,10);                   
                end
          $display("the cintents are %p",da);
          
          da = new[20] (da);
           for(int i=10;i<20;i++)
                begin
                      da[i]=$urandom_range(10,20);                   
                end
           $display("the contents are %p",da);
               
       end 
endmodule



/*module test;
  int ass[string];
  string s;
    initial begin
       s = "abcdefghijkl";
       foreach(s[i])
       begin 
           ass[s[i]]={$random}%100; 
       end  
       $display("the contents are %p",ass);      
    end
    
    endmodule
    
    
class random;
rand byte a;
rand bit b;

function void pre_randomize;
  a=10;
  b=0;
      $display("the contents are pre %h",a); 
      $display("the contents are pre %h",b); 
endfunction:pre_randomize

function void post_randomize;
      $display("the contents are %h",a); 
      $display("the contents are %h",b); 
endfunction:post_randomize
endclass:random

module test;
  initial begin
     random r =new;
     r.randomize;
  end 
endmodule:test



class pattern ;
    rand byte da[5][5];
    rand int i,j;
    
   constraint size_set{i>0;i<5; j>0;j<5;}
   constraint diagonal1{foreach(da[i,j]){
                               if(i==j)
                                   da[i][j]==0;
                               else if(i<j)
                                   da[i][j]%2==0;
                               }} 
                             
                                
     function void print;
           $display("the contents are %p",da);      
     endfunction:print                    
       
endclass:pattern

module test;
pattern p;
initial 
    begin
     p=new;
     p.randomize();
     p.print;
          
    end   
endmodule:test*/



class p;
rand int n,k;
rand int d[];
constraint bound1{ n>0;n<100;}
constraint bound2{ k>0;k<100;}
constraint value {n==k*k;}
constraint bound4 {d.size>0;d.size<10;}
constraint bound5{ foreach(d[i]){
                      d[i]==(i)**(i)};}

endclass:p

class test;
rand int da[10];
rand byte k;
function void pre_randomize;
     k=1;
endfunction:pre_randomize

constraint value{foreach(da[i]){
                         if(i%2==0){
                             da[i]==k;
                             k==k+1;
                             }}}
endclass:test




class packet;
rand bit [3:0]start_addr;
bit [3:0]end_addr;


constraint valid_addr{end_addr == addr_calc(start_addr);}

function bit [3:0]addr_calc(bit [3:0] s_addr);
      if(s_addr>4)
           addr_calc=0;
      else
           addr_calc=s_addr*2; 
endfunction:addr_calc
endclass:packet


class patte;
   rand int da3[];
   int k;
   rand int m;
   constraint value2{m==0;}
   constraint value{foreach(da3[i])
                         m==i+1;}
   constraint size{da3.size==20;}  
   constraint patt{foreach(da3[i])
                             da3[i]== addr_calc(i);}          
                               
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

