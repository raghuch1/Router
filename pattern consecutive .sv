//consecutive numbers in array
class test;
rand bit[6:0] array[];
 constraint size{array.size==17;}
 constraint value{foreach(array[i]){
                    if(i>0)
                    array[i]==array[i-1]+1;}}
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
