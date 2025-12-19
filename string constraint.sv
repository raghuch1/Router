class pattern;
  rand longint a[8];
  
  string c[8];
  
  constraint value{foreach(a[i])
    if(i==0)
      a[i]==97;
    else
      a[i]==((a[i-1])<<8)+(a[0]+i);}
  
  function void post_randomize();
      foreach(a[i])
        c[i] = $sformatf("%s",a[i]);
      $display("%p",c);
  endfunction

endclass

module test;

  pattern p;

  initial begin
    p = new();
    p.randomize();
    $display("%p",p.a);
  end
endmodule

// '{"a", "ab", "abc", "abcd", "abcde", "abcdef", "abcdefg", "abcdefgh"}
