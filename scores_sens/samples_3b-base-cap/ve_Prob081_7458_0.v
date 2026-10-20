
module TopModule (
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p1e,
    input  p1f,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

    
    wire and1;
    wire and2;
    wire and3;
    wire and4;

    
    and and1_inst (
        .A(p1a),
        .B(p1b),
        .C(p1c),
        .Y(and1)
    );

    and and2_inst (
        .A(p1d),
        .B(p1e),
        .C(p1f),
        .Y(and2)
    );

    and and3_inst (
        .A(p2a),
        .B(p2b),
        .Y(and3)
    );

    and and4_inst (
        .A(p2c),
        .B(p2d),
        .Y(and4)
    );

    
    or or1_inst (
        .A(and1),
        .B(and2),
        .Y(p1y)
    );

    or or2_inst (
        .A(and3),
        .B(and4),
        .Y(p2y)
    );

endmodule
