// Directed check: width_8to16 spec says valid_out and data_out appear in the next cycle after two inputs (a pulse).
module tb; reg clk=0, rst_n=0, valid_in=0; reg [7:0] data_in=0; wire [15:0] dg, dt; wire vg, vt; integer i;
gold g(.clk(clk),.rst_n(rst_n),.valid_in(valid_in),.data_in(data_in),.valid_out(vg),.data_out(dg));
gate t(.clk(clk),.rst_n(rst_n),.valid_in(valid_in),.data_in(data_in),.valid_out(vt),.data_out(dt));
always #5 clk=~clk;
initial begin @(posedge clk); #1 rst_n=1; valid_in=1; data_in=8'hAB; @(posedge clk); #1 data_in=8'hCD; @(posedge clk); #1 valid_in=0;
 for (i=0;i<4;i=i+1) begin @(posedge clk); #1 $display("cycle %0d after 2nd byte: valid_out gold=%b gate=%b data gold=%h gate=%h", i+1, vg, vt, dg, dt); end $finish; end endmodule
// Result 17 Oct 2026 (GPT-4 trial t1): gate keeps valid_out=1 for 4+ cycles; gold drops it.
