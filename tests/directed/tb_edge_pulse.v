// Directed check: edge_detect spec says rise/down are 1 for one clock after the edge, then return to 0.
module tb; reg clk=0, rst_n=0, a=0; wire rg, rt, dg, dt; integer i;
gold g(.clk(clk),.rst_n(rst_n),.a(a),.rise(rg),.down(dg)); gate t(.clk(clk),.rst_n(rst_n),.a(a),.rise(rt),.down(dt));
always #5 clk=~clk;
initial begin @(posedge clk); #1 rst_n=1; @(posedge clk); #1 a=1; @(posedge clk); #1 a=0;
 for (i=0;i<3;i=i+1) begin @(posedge clk); #1 $display("rise gold=%b gate=%b | down gold=%b gate=%b", rg, rt, dg, dt); end $finish; end endmodule
// Result 17 Oct 2026 (GPT-3.5 trial t1): on the falling edge the candidate shows rise=1 and down=1 together.
