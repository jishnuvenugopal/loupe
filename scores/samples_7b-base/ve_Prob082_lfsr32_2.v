
module TopModule(clk, reset, q);
  input  clk;
  input  reset;
  output [31:0] q;

  reg [31:0] lfsr;

  initial begin
    lfsr = 32'hFFFFFFFF;
 
  end

  always @(posedge clk or posedge reset) begin
    if (reset)
      lfsr <= 32'h1;
 
    else begin
      reg [31:0] next_lfsr;
      next_lfsr = {lfsr[30:0], lfsr[31] ^ lfsr[22] ^ lfsr[2] ^ lfsr[1]};
      lfsr <= next_lfsr;
    end
  end

assign q = lfsr;
endmodule
