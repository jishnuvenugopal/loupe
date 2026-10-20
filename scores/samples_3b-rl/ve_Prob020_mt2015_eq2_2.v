
module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    wire [1:0] eq;

    assign eq = A == B;
    assign z = eq[1];

endmodule
