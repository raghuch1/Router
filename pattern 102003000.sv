// Code your testbench here
// or browse Examples
//pattern 10200300040000......
class pattern;
  rand int arr[];
  
  static int k;
  
  static int l;
  
  constraint size{arr.size==30;}
 
  constraint val{foreach(arr[i])
    arr[i]== fun(i);}
  
  function int fun(int i);
    if(i==0)
      begin
        k =1;
        l =1;
        return 1;
      end
    else if(k==0)
      begin
        k =l+1;
        l =l+1;
        return l;
      end
    else
      begin
        k =k-1;
        return 0;
      end
    
  endfunction
                
        
endclass
 
module test;
  pattern p;
  
  initial begin
    p = new();
    p.randomize();
    $display("the value is %p",p.arr);
  end
endmodule



KERNEL: Warning: You are using the Riviera-PRO EDU Edition. The performance of simulation is reduced.
# KERNEL: Warning: Contact Aldec for available upgrade options - sales@aldec.com.
# KERNEL: Kernel process initialization done.
# Allocation: Simulator allocated 4767 kB (elbread=459 elab2=4162 kernel=145 sdf=0)
# KERNEL: ASDB file was created in location /home/runner/dataset.asdb
# KERNEL: the value is '{1, 0, 2, 0, 0, 3, 0, 0, 0, 4, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 7, 0, 0}
# KERNEL: Simulation has finished. There are no more test vectors to simulate.
# VSIM: Simulation has finished.
