
module dff(clk, D, Q);
  input clk;
  input D;
  output reg Q;

  always @(posedge clk) begin
    Q <= D;
  end
endmodule

module TopModule(clk, d, q);
  input clk;
  input [7:0] d;
  output [7:0] q;

  wire [7:0] d_ff_q;

  
  dff dff_inst_0(clk, d[0], d_ff_q[0]);
  dff dff_inst_1(clk, d_ff_q[0], d_ff_q[1]);
  dff dff_inst_2(clk, d_ff_q[1], d_ff_q[2]);
  dff dff_inst_3(clk, d_ff_q[2], d_ff_q[3]);
  dff dff_inst_4(clk, d_ff_q[3], d_ff_q[4]);
  dff dff_inst_5(clk, d_ff_q[4], d_ff_q[5]);
  dff dff_inst_6(clk, d_ff_q[5], d_ff_q[6]);
  dff dff_inst_7(clk, d_ff_q[6], d_ff_q[7]);

  
  assign q = d_ff_q[7];
endmodule
