
module top_level (
    input wire x,
    input wire y,
    output wire z
);

    
    A subA1 (
        .x(x),
        .y(y),
        .z(z)
    );

    A subA2 (
        .x(x),
        .y(y),
        .z(z)
    );

    
    B subB1 (
        .x(x),
        .y(y),
        .z(z)
    );

    B subB2 (
        .x(x),
        .y(y),
        .z(z)
    );

endmodule

module A (
    input wire x,
    input wire y,
    output wire z
);

    assign z = (x ^ y) & x;

endmodule

module B (
    input wire x,
    input wire y,
    output wire z
);

    assign z = x & y;

endmodule
