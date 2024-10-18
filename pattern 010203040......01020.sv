// it wil generate 01 02 03 04 05 06 07 08 09 01 02 03 04 05
 class test;
     rand int array[];
     constraint size {array.size==30;}
     constraint value{foreach(array[i]){
                     if(i<=17){                        
                          if(i%2==0)
                              array[i]==0;
                          else
                              array[i]==(i+1)/2;}
                      else{
                          
                          if((16-i)%2==0)
                              array[i]==0;
                          else
                              array[i]==((i-17+1)/2);}}}
                           
                         
                            
 endclass

module test;
test v;
initial 
begin
 v=new();
 v.randomize();
 $display("the array is %p",v.array); 
end 
