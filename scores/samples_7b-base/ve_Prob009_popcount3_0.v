
module full_adder(a, b, cin, sum, cout);
  input a, b, cin;
  output reg sum, cout;

  assign {cout, sum} = a + b + cin;
endmodule

module TopModule(in, out);
  input [2:0] in;
  output [1:0] out;

  wire [1:0] sum1;
  wire cout1;

  wire [1:0] sum2;
  wire cout2;

  full_adder fa1(in[0], in[1], 1'b0, sum1, cout1);
  full_adder fa2(cout1, in[2], 1'b0, sum2, cout2);

  assign out = sum2;
endmodule
