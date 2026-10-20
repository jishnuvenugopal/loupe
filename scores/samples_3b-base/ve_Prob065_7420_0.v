
module TopModule (
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

    
    logic p1nand1, p1nand2, p2nand1, p2nand2;

    
    nand #(.N(4)) nand1 (
        .A(p1a),
        .B(p1b),
        .C(p1c),
        .D(p1d),
        .Y(p1nand1)
    );

    
    nand #(.N(4)) nand2 (
        .A(p2a),
        .B(p2b),
        .C(p2c),
        .D(p2d),
        .Y(p2nand1)
    );

    
    assign p1y = p1nand1;
    assign p2y = p2nand1;

endmodule
