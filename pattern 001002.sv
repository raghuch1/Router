// Generate a pattern 001002003004005.....
class test;
    rand bit[7:0] array[];
    constraint size{array.size==20;}
    constraint value{foreach(array[i]){
                      array[i]==0;}}
    
    function void post_randomize();
       for(int i=2;i<array.size();i=i+3)
             begin
                array[i]=(i+1)/2;
             end
    endfunction
                      
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
