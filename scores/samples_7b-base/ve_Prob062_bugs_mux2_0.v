
module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output reg [7:0] out
);

  reg [7:0] temp_out;

  always @(sel or a or b) begin
    temp_out = (~sel & a) | (sel & b);
  end

  assign out = temp_out;

endmodule
