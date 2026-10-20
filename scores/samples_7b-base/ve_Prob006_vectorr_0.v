
module TopModule (in, out);
  input [7:0] in;
  output [7:0] out;

  initial begin
    for (int i = 0;
 i < 8;
 i = i + 1) begin
      out[i] = in[7 - i];
    end
  end

endmodule
