// Generated a array of fibonocci numbers using constraints in SystemVerilog
// output
//  array is '{0,1,1,2,3,5,8,13,21,34}
class test;
rand int array[];
constraint size{array.size==10;}
constraint value{foreach(array[i]){
                 array[i]==fibonocci(i);}}
                 
function int fibonocci(int i);
   if(i<=1)
      begin
         return i;
       end 
   else
      return fibonocci(i-1)+fibonocci(i-2);
 endfunction
 
endclass

module test;
test v;
initial  
begin
 v=new();
 v.randomize();
 $display("array is %p",v.array);
 end
endmodule
