
module TopModule(
  input x1, x2, x3, x4,
  output f
);
  assign f = (~x3 & x4 & x1 & x2) | (x3 & x4 & ~x1) | (x3 & ~x4 & ~x1);
endmodule
