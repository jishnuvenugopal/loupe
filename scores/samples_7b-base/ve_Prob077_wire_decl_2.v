
module TopModule (a, b, c, d, out, out_n);
  input a, b, c, d;
  output out, out_n;
  
  wire and_output1, and_output2, or_output;
  
  assign and_output1 = a & b;
  assign and_output2 = c & d;
  assign or_output = and_output1 | and_output2;
  
  assign out = or_output;
  assign out_n = ~out_n;
endmodule
