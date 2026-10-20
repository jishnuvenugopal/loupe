
module top_module(clk, in, out);
  input clk;
  input in;
  output out;

  reg out_reg;
  

  
  xor xor_gate (xor_out, in, out_reg);

  
  d_ff d_flip_flop (.d(xor_out), .clk(clk), .q(out_reg));

  
  assign out = out_reg;

endmodule


module xor (out, a, b);
  input a, b;
  output reg out;

  always @(*) begin
    out = a ^ b;
  end

endmodule


module d_ff (d, clk, q);
  input d, clk;
  output reg q;

  always @(posedge clk) begin
    q <= d;
  end

endmodule
