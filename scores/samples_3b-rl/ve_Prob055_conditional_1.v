
module TopModule (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [7:0] c,
    input  wire [7:0] d,
    output wire [7:0] min
);

    assign min = (a < b) ? a : b;
    assign min = (min < c) ? min : c;
    assign min = (min < d) ? min : d;

endmodule
