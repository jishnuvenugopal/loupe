
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

    
    module nand2 (
        input  a,
        input  b,
        output y
    );
        assign y = !a & !b;
    endmodule

    
    nand2 nand1 (
        .a(p1a),
        .b(p1b),
        .y(p1y)
    );

    
    nand2 nand2 (
        .a(p2a),
        .b(p2b),
        .y(p2y)
    );

endmodule
