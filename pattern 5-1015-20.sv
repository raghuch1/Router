// Generated a Pattern 5 -10 15 -20 25 -30

class test;
rand byte array[]; 

 constraint size {array.size==14;}
 constraint value{array[0]==5;}
 
 constraint value1 {foreach(array[i]){
                   
                    if(i>0 &&i%2==0)
                         array[i]==array[0]*(i+1);
                    else if(i>0)
                         array[i]==array[0]*(i+1)*-1;}}
                       
                    
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
