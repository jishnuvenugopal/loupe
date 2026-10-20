
module A(x, y, z);
  input x, y;
  output z;
  assign z = (x ^ y) & x;
endmodule

module B(x, y, z);
  input x, y;
  output z;
  assign z = (x == y);
endmodule

module top(x, y, z);
  input x, y;
  output z;

  wire a1, b1, a2, b2;

  A a1_inst(.x(x), .y(y), .z(a1));
  B b1_inst(.x(x), .y(y), .z(b1));
  A a2_inst(.x(x), .y(y), .z(a2));
  B b2_inst(.x(x), .y(y), .z(b2));

  wire or_out, and_out;

  or or_inst(.a(a1), .b(b1), .y(or_out));
  and and_inst(.a(a2), .b(b2), .y(and_out));

  xor xor_inst(.a(or_out), .b(and_out), .y(z));

endmodule
