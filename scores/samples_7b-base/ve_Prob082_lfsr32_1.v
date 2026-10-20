
module top_module(clk, reset, q);
  input clk, reset;
  output reg [31:0] q;

  reg [31:0] lfsr;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      q <= 32'h1;
      lfsr <= 32'h1;
    end else begin
      reg tap1, tap2, tap22, tap32;
      tap1 = lfsr[0];
      tap2 = lfsr[1];
      tap22 = lfsr[22];
      tap32 = lfsr[31];
      
      lfsr <= {tap32 ^ tap22 ^ tap2 ^ tap1, lfsr[30:1]};
      q <= {31'b0, tap32};
 
    end
  end
endmodule
