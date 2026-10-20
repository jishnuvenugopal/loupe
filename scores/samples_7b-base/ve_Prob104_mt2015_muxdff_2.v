
module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output Q
);

  reg Q_reg;
  wire Q_out;

  
  full_module mod1 (.clk(clk), .L(L), .r(r_in), .q(Q_reg));
  full_module mod2 (.clk(clk), .L(L), .r(Q_reg), .q(Q_out));

  
  assign Q = Q_out;

endmodule
