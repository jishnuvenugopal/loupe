
module TopModule (input a, input b, input c, input d, output q);
  assign q = (d == 1) ? 1 : ((a == 0 && b == 0) ? 0 : ((a == 1) ? 0 : ((a == 0 && b == 1) ? ((c == 1) ? 1 : 0) : ((a == 1 && b == 1) ? ((c == 1 && d == 1) ? 1 : 0) : 0)))));
endmodule
