
module TopModule (
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p1y,
    output p2y
);

    
    wire nand1a, nand1b, nand1c, nand1d;
    wire nand1y;
    nand20 nand1 (
        .A(p1a),
        .B(p1b),
        .C(p1c),
        .D(p1d),
        .Y(nand1y)
    );

    
    wire nand2a, nand2b, nand2c, nand2d;
    wire nand2y;
    nand20 nand2 (
        .A(p2a),
        .B(p2b),
        .C(p2c),
        .D(p2d),
        .Y(nand2y)
    );

    
    assign p1y = nand1y;
    assign p2y = nand2y;

endmodule


module nand20 (
    input A,
    input B,
    input C,
    input D,
    output Y
);

    
    assign Y = ~(A & B & C & D);

endmodule
