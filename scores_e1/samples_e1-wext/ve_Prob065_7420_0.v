
module nand2 (
    input wire a,
    input wire b,
    output wire y
);

    assign y = ~a & ~b;

endmodule

module TopModule (
    input wire p1a,
    input wire p1b,
    input wire p1c,
    input wire p1d,
    input wire p2a,
    input wire p2b,
    input wire p2c,
    input wire p2d,
    output wire p1y,
    output wire p2y
);

    nand2 nand1a (
        .a(p1a),
        .b(p1b),
        .y(p1y)
    );

    nand2 nand1b (
        .a(p1c),
        .b(p1d),
        .y(p1y)
    );

    nand2 nand2a (
        .a(p2a),
        .b(p2b),
        .y(p2y)
    );

    nand2 nand2b (
        .a(p2c),
        .b(p2d),
        .y(p2y)
    );

endmodule
