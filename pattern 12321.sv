class test;
   rand bit[3:0] array[];
   constraint size{array.size==14;}
   constraint value{foreach(array[i]){
                    if(i>=((array.size+1)/2))
                        array[i]==array[i-1]-1;
                    else 
                        array[i]==i+1;}}
                      
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
