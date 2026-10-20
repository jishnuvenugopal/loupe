
module TopModule (
    input  clk,
    input  [7:0] d,
    output [7:0] q
);


reg [7:0] dff0, dff1, dff2, dff3, dff4, dff5, dff6, dff7;


dff dff0 (.clk(clk), .d(d[0]), .q(dff0));
dff dff1 (.clk(clk), .d(d[1]), .q(dff1));
dff dff2 (.clk(clk), .d(d[2]), .q(dff2));
dff dff3 (.clk(clk), .d(d[3]), .q(dff3));
dff dff4 (.clk(clk), .d(d[4]), .q(dff4));
dff dff5 (.clk(clk), .d(d[5]), .q(dff5));
dff dff6 (.clk(clk), .d(d[6]), .q(dff6));
dff dff7 (.clk(clk), .d(d[7]), .q(dff7));


assign q = {dff7, dff6, dff5, dff4, dff3, dff2, dff1, dff0};

endmodule


module dff (
    input  clk,
    input  d,
    output q
);

always @(posedge clk) begin
    q <= d;
end

endmodule
