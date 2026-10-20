
module TopModule(input [2:0] a, output [15:0] q);
  assign q = {12'h2a, a};
endmodule
