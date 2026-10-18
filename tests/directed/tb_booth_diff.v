`timescale 1ns/1ps
// Differential check: operands held stable through reset and computation; compare p when rdy first rises.
module tb;
  reg clk = 0, reset; reg [7:0] a, b; wire [15:0] p_g, p_t; wire rdy_g, rdy_t;
  gold g(.clk(clk), .reset(reset), .a(a), .b(b), .p(p_g), .rdy(rdy_g));
  gate t(.clk(clk), .reset(reset), .a(a), .b(b), .p(p_t), .rdy(rdy_t));
  always #5 clk = ~clk;
  integer k, cyc, tg, tt, bad = 0; reg [15:0] pg, pt;
  initial begin
    for (k = 0; k < 200; k = k + 1) begin
      a = $random; b = $random; reset = 1; @(posedge clk); @(posedge clk); #1 reset = 0;
      tg = -1; tt = -1;
      for (cyc = 0; cyc < 40; cyc = cyc + 1) begin
        @(posedge clk); #1;
        if (rdy_g && tg < 0) begin tg = cyc; pg = p_g; end
        if (rdy_t && tt < 0) begin tt = cyc; pt = p_t; end
      end
      if (pg !== pt || tg != tt) begin
        bad = bad + 1;
        if (bad <= 3) $display("a=%0d b=%0d (signed %0d x %0d = %0d): gold rdy@%0d p=%0d | gate rdy@%0d p=%0d",
          a, b, $signed(a), $signed(b), $signed(a)*$signed(b), tg, $signed(pg), tt, $signed(pt));
      end
    end
    $display("RESULT %0d/200 operand pairs differ (final p at first rdy, or rdy cycle)", bad);
    $finish;
  end
endmodule
