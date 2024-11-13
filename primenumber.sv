class test;
 randc int array[];
 constraint size{array.size==15;}
 constraint value{foreach(array[i]){
                   array[i]==prime(i);}}
               
  function int prime( int i);
       if(i<2)
         return 0;
       else
          for(int k=2;k<i;k++)
             if(i%k==0)
                 return 0;
       return i;                         
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

  //    the value is '{0,0,2,3,0,5,0,7,0,0,0,11,0,13,0}
