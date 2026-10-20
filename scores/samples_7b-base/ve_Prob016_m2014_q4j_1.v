
module FullAdder(input a, input b, input cin, output reg sum, output reg cout);
  assign sum = a ^ b ^ cin;
  assign cout = (a & b) | (b & cin) | (cin & a);
endmodule

module TopModule(input [3:0] x, input [3:0] y, output [4:0] sum);
  wire [3:0] internal_sum;
  wire [3:0] carry_out;

  FullAdder Fa0(x[0], y[0], 0, internal_sum[0], carry_out[0]);
  FullAdder Fa1(x[1], y[1], carry_out[0], internal_sum[1], carry_out[1]);
  FullAdder Fa2(x[2], y[2], carry_out[1], internal_sum[2], carry_out[2]);
  FullAdder Fa3(x[3], y[3], carry_out[2], internal_sum[3], carry_out[3]);

  assign sum[4] = carry_out[3];
  assign sum[3:0] = internal_sum[3:0];
endmodule
