
module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    wire [7:0] ab_min = a < b ? a : b;
    wire [7:0] abc_min = ab_min < c ? ab_min : c;
    wire [7:0] min_out = abc_min < d ? abc_min : d;

    assign min = min_out;

endmodule
