
module TopModule (
  input a,
  input b,
  input c,
  output reg out
);

always @(*) begin
  out = b | (a & c);
end

endmodule
