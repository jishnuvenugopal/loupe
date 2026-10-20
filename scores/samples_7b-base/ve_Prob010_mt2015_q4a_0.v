
module TopModule (x, y, z);
  input x, y;
  output reg z;

  always @(*) begin
    z = (x ^ y) & x;
  end
endmodule
