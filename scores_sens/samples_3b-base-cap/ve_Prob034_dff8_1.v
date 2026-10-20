
module TopModule (
    input  clk,
    input  [7:0] d,
    output [7:0] q
);


module DFlipFlop (
    input  clk,
    input  d,
    output q
);

always @(posedge clk) begin
    q <= d;
end

endmodule


DFlipFlop dff0 (.clk(clk), .d(d[0]), .q(q[0]));
DFlipFlop dff1 (.clk(clk), .d(d[1]), .q(q[1]));
DFlipFlop dff2 (.clk(clk), .d(d[2]), .q(q[2]));
DFlipFlop dff3 (.clk(clk), .d(d[3]), .q(q[3]));
DFlipFlop dff4 (.clk(clk), .d(d[4]), .q(q[4]));
DFlipFlop dff5 (.clk(clk), .d(d[5]), .q(q[5]));
DFlipFlop dff6 (.clk(clk), .d(d[6]), .q(q[6]));
DFlipFlop dff7 (.clk(clk), .d(d[7]), .q(q[7]));

endmodule
