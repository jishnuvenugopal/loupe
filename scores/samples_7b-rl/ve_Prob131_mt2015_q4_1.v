
module A_sub(input x, input y, output z);
  assign z = (x ^ y) & x;
endmodule

module B_sub(input x, input y, output z);
  assign z = ~(x ^ y);
 
endmodule

module top_module(input x, input y, output z);
  wire a1, a2, b1, b2;
  
  A_sub inst1(.x(x), .y(y), .z(a1));
  A_sub inst2(.x(x), .y(y), .z(a2));
  B_sub inst3(.x(x), .y(y), .z(b1));
  B_sub inst4(.x(x), .y(y), .z(b2));
  
  wire or_result = a1 | b1;
  wire and_result = a2 & b2;
  
  assign z = or_result ^ and_result;
endmodule
