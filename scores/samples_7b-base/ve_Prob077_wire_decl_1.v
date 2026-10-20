
module TopModule(in a, in b, in c, in d, out, out_n);
  wire and1, and2, or;

  
  and1 = a & b;
  and2 = c & d;

  
  or = and1 | and2;

  
  out = or;
  out_n = ~out;
endmodule
