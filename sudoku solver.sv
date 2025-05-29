// constraint to solve a sudoku puzzle 

class sudoku;
  rand int puzzle[][];
  
  constraint size{puzzle.size==9;}
  
  constraint size1{foreach(puzzle[i])
    puzzle[i].size==9;}
  
  constraint value2{foreach(puzzle[i]){
    foreach(puzzle[j]){
      unique{puzzle[i]};}}}
  
  
  constraint value1{foreach(puzzle[i]){
    foreach(puzzle[j]){
      puzzle[i].sum==45;}}}
  
  constraint value{foreach(puzzle[i]){
    foreach(puzzle[j]){
      puzzle[i][j]<10;puzzle[i][j]>0;}}}
    
  
  constraint value3{foreach(puzzle[i])
    foreach(puzzle[j])
      foreach(puzzle[k])
        if({k,j}!={i,j})
          puzzle[k][j]!=puzzle[i][j];}
  
  
  function void post_randomize();
    foreach(puzzle[i])
      $display("the value is %p",puzzle[i]);
    $display("");
  endfunction
      
endclass

module test;
  sudoku s;
  initial 
    begin
      s = new();
      s.randomize();
      //$display("the value is %p",s.puzzle);
    end
endmodule

/* output the value is '{5, 2, 8, 3, 7, 6, 1, 4, 9}
# KERNEL: the value is '{9, 4, 6, 5, 8, 1, 2, 7, 3}
# KERNEL: the value is '{4, 7, 3, 6, 2, 9, 8, 1, 5}
# KERNEL: the value is '{6, 9, 7, 4, 1, 5, 3, 2, 8}
# KERNEL: the value is '{3, 5, 2, 1, 6, 8, 4, 9, 7}
# KERNEL: the value is '{1, 6, 9, 8, 3, 4, 7, 5, 2}
# KERNEL: the value is '{8, 1, 5, 2, 9, 7, 6, 3, 4}
# KERNEL: the value is '{7, 3, 1, 9, 4, 2, 5, 8, 6}
# KERNEL: the value is '{2, 8, 4, 7, 5, 3, 9, 6, 1}  */
    
    
    
