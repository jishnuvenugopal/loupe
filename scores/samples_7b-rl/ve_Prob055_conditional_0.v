
module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    wire [7:0] min_ab;
    wire [7:0] min_abc;
    wire [7:0] min_abcd;

    assign min_ab = (a < b) ? a : b;
    assign min_abc = (min_ab < c) ? min_ab : c;
    assign min_abcd = (min_abc < d) ? min_abc : d;

    assign min = min_abcd;

endmodule
