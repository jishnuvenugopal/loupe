
module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    wire [7:0] a_min_b;
    wire [7:0] a_min_c;
    wire [7:0] a_min_d;
    wire [7:0] b_min_c;
    wire [7:0] b_min_d;
    wire [7:0] c_min_d;

    assign a_min_b = (a < b) ? a : b;
    assign a_min_c = (a < c) ? a : c;
    assign a_min_d = (a < d) ? a : d;
    assign b_min_c = (b < c) ? b : c;
    assign b_min_d = (b < d) ? b : d;
    assign c_min_d = (c < d) ? c : d;

    assign min = (a_min_b < a_min_c) ? a_min_b : a_min_c;
    assign min = (min < a_min_d) ? min : a_min_d;
    assign min = (min < b_min_c) ? min : b_min_c;
    assign min = (min < b_min_d) ? min : b_min_d;
    assign min = (min < c_min_d) ? min : c_min_d;

endmodule
