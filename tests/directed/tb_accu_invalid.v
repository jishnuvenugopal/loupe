// Directed check: accu spec says only samples with valid_in=1 count. One invalid sample (100), then 1,2,3,4 valid.
module tb; reg clk=0, rst_n=0, valid_in=0; reg [7:0] data_in=0; wire [9:0] dg, dt; wire vg, vt; integer i;
gold g(.clk(clk),.rst_n(rst_n),.data_in(data_in),.valid_in(valid_in),.valid_out(vg),.data_out(dg));
gate t(.clk(clk),.rst_n(rst_n),.data_in(data_in),.valid_in(valid_in),.valid_out(vt),.data_out(dt));
always #5 clk=~clk;
initial begin @(posedge clk); #1 rst_n=1;
 data_in=100; valid_in=0; @(posedge clk); #1;
 for (i=1;i<=4;i=i+1) begin data_in=i; valid_in=1; @(posedge clk); #1; if (vg) $display("gold valid_out with sum=%0d", dg); end valid_in=0;
 for (i=0;i<3;i=i+1) begin if (vg) $display("gold valid_out with sum=%0d", dg); if (vt) $display("gate valid_out with sum=%0d", dt); @(posedge clk); #1; end
 $display("(valid samples 1+2+3+4 = 10; an ignored sample of 100 was presented first)"); $finish; end endmodule
// Result 17 Oct 2026: reference (gold) sum=106, GPT-4 design (gate, trial t1) sum=10. The reference adds data while valid_in=0.
