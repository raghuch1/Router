// sum of 10 elements is 300 without sum method.

class test;
    rand bit[5:0] array[];
    int sum;
    constraint size{array.size==10;array[0]==21;} 
    constraint value{foreach(array[i]){
                     if(i>0)
                     array[i]==array[i-1]+2;}}
     function void post_randomize();
            foreach(array[i])
               sum=sum+array[i];                     
     endfunction
                
endclass
module test;
test v;
initial 
begin
 v=new();
 v.randomize();
 $display("the value is %p",v.array);
 $display("the value is %p",v.sum);
 
  
end 
endmodule
