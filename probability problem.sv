//observations:
/* 1.enum datatype can also be randomized
   2.randc behaviour using rand
   3.should'nt repeat same color within 3 draws*/


class pattern;
  typedef enum{red,blue,yellow,green,orange,pink,indigo,violet,brown,white}colors;
  
  rand colors color;
  
  colors q[$];
  
  static int i;
  
  constraint val{!(color inside {q});}
  
  function void post_randomize();
    q.push_front(color);
    i=i+1;
    if(i==4)
      q.pop_back();
   // $display("the value is %p",q[$]);
  endfunction
    
endclass
 
module test;
  pattern p;
  
  initial begin
    p = new();
    repeat(10)
      begin
       p.randomize();
       $display("the value is %p",p.color);
      end
  end
endmodule
