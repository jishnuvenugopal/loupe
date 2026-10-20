
module A (
    input  wire x,
    input  wire y,
    output wire z
);

    assign z = (x ^ y) & x;

endmodule

module B (
    input  wire x,
    input  wire y,
    output wire z
);

    assign z = x & y;

endmodule

module top (
    input  wire x,
    input  wire y,
    output wire z
);

    wire a1, a2, b1, b2, or_out, and_out;
    wire xor_out;

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

    assign or_out = a1 | b1;
    assign and_out = a2 & b2;
    assign xor_out = or_out ^ and_out;
    assign z = xor_out;

endmodule
