
module A (
    input x,
    input y,
    output z
);

    assign z = (x ^ y) & x;

endmodule

module B (
    input x,
    input y,
    output z
);

    assign z = (x ^ y) & x;

endmodule

module top (
    input x,
    input y,
    output z
);

    wire a1, a2, b1, b2, or_out, and_out;

    A a1_inst (
        .x(x),
        .y(y),
        .z(a1)
    );

    A a2_inst (
        .x(x),
        .y(y),
        .z(a2)
    );

    B b1_inst (
        .x(x),
        .y(y),
        .z(b1)
    );

    B b2_inst (
        .x(x),
        .y(y),
        .z(b2)
    );

    assign or_out = a1 | a2;
    assign and_out = b1 & b2;
    assign z = or_out ^ and_out;

endmodule
