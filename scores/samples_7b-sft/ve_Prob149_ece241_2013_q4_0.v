
module TopModule (
  input clk,
  input reset,
  input [2:0] s,
  output reg fr2,
  output reg fr1,
  output reg fr0,
  output reg dfr
);

  reg [2:0] prev_s;

  always @(posedge clk) begin
    if (reset) begin
      prev_s <= 3'b000;
      {fr2, fr1, fr0} <= 3'b111;
      dfr <= 1'b1;
    end else begin
      prev_s <= s;
      dfr <= (s > prev_s) ? 1'b1 : 1'b0;

      if (s[2]) begin
        {fr2, fr1, fr0} <= 3'b000;
      end else if (s[1]) begin
        {fr2, fr1, fr0} <= 3'b001;
      end else if (s[0]) begin
        {fr2, fr1, fr0} <= 3'b011;
      end else begin
        {fr2, fr1, fr0} <= 3'b111;
      end
    end
  end

endmodule
