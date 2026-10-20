
module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output [7:0] min
);

    wire [7:0] a_min_b;
    wire [7:0] a_min_b_min_c;
    wire [7:0] min;

    assign a_min_b = (a < b) ? a : b;
    assign a_min_b_min_c = (a_min_b < c) ? a_min_b : c;
    assign min = (a_min_b_min_c < d) ? a_min_b_min_c : d;

endmodule
