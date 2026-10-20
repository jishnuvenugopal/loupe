
module TopModule(in, out, a, b, c, d);
  input [7:0] a, b, c, d;
  output reg [7:0] out;

  wire [7:0] temp1, temp2, min;

  
  assign temp1 = a < b ? a : b;

  
  assign temp2 = c < d ? c : d;

  
  assign min = temp1 < temp2 ? temp1 : temp2;

  
  assign out = min;
endmodule
