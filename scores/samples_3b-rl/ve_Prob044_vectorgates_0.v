
module TopModule (
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

    wire [2:0] or_result;
    wire or_logical;
    wire [2:0] a_not;
    wire [2:0] b_not;

    assign or_result = a | b;
    assign or_logical = or_result[0];
    assign a_not = ~a;
    assign b_not = ~b;

    assign out_or_bitwise = or_result;
    assign out_or_logical = or_result[0];
    assign out_not = {b_not, a_not};

endmodule
