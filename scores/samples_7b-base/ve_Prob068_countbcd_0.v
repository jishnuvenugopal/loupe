
module TopModule(clk, reset, ena, q);
  input clk;
  input reset;
  output reg [3:0] ena;
  output reg [15:0] q;

  reg [3:0] ones;
  reg [3:0] tens;
  reg [3:0] hundreds;
  reg [3:0] thousands;

  always @(posedge clk) begin
    if (reset) begin
      ones <= 4'b0000;
      tens <= 4'b0000;
      hundreds <= 4'b0000;
      thousands <= 4'b0000;
    end else begin
      if (ones == 4'b0111) begin
        ones <= 4'b0000;
        if (tens == 4'b0111) begin
          tens <= 4'b0000;
          if (hundreds == 4'b0111) begin
            hundreds <= 4'b0000;
            thousands <= thousands + 1;
          end else begin
            hundreds <= hundreds + 1;
          end
        end else begin
          tens <= tens + 1;
        end
      end else begin
        ones <= ones + 1;
      end
    end
  end

  assign {ena[3], ena[2], ena[1], ena[0]} = {ones > 9, tens > 9, hundreds > 9, thousands > 9};
  assign q[15:12] = thousands;
  assign q[11:8] = hundreds;
  assign q[7:4] = tens;
  assign q[3:0] = ones;
endmodule
