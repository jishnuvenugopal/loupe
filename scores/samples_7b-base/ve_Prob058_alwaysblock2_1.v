
module TopModule (clk, a, b, out_assign, out_always_comb, out_always_ff);
  input clk;
  input a;
  input b;
  output out_assign;
  output out_always_comb;
  output out_always_ff;

  
  assign out_assign = a ^ b;

  
  wire comb_result;
  always @(*) begin
    comb_result = a ^ b;
  end
  assign out_always_comb = comb_result;

  
  reg ff_result;
  always @(posedge clk) begin
    ff_result <= a ^ b;
  end
  assign out_always_ff = ff_result;
endmodule
