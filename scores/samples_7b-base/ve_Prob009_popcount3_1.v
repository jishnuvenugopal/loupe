
module TopModule (in, out);
  input [2:0] in;
  output [1:0] out;

  wire and1, and2, and3;
  wire or_result;

  
  assign and1 = in[0] & 1'b1;
  assign and2 = in[1] & 1'b1;
  assign and3 = in[2] & 1'b1;

  assign or_result = and1 | and2 | and3;

  
  assign out[1] = (or_result & and1) | (or_result & and2) | (or_result & and3);
  assign out[0] = (out[1] & and1) | (out[1] & and2) & (out[1] & and3);

endmodule
