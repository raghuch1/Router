//sum of 10 elements is 100 without .sum method

class test;
    rand bit[5:0] array[];
    int sum;
    constraint size{array.size==10;array[0]==8;} 
    constraint value{foreach(array[i]){
                      if(i%2==0)
                         array[i]==array[i-1]+1;
                      else
                         array[i]==array[i-1];}}
    function void post_randomize();
            foreach(array[i])
               sum=sum+array[i];                               
    endfunction 
                
endclass

module test;
test v;
int sum;
bit[5:0] array1[];


initial 
begin
 v=new();
 v.randomize();
 $display("the value is %d",v.array);
 
end 
endmodule
