// Generate a pattern 9 19 29 39 49 59 .....
class test;
 rand bit[10:0] array[];
 
 constraint size{array.size==10;array[0]==9;}
 constraint value{foreach(array[i]){
                     if(i>0)
                         array[i]==array[i-1]+10;}}
endclass

module test;
test v;
initial 
begin
 v=new();
 v.randomize();
 $display("the value is %p",v.array);
  
end 
endmodule
