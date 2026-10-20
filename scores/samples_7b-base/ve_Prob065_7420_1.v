
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

    wire a1, b1, c1, d1, e1, f1, g1, h1;
    wire a2, b2, c2, d2, e2, f2, g2, h2;

    assign a1 = p1a & p1b;
    assign b1 = ~a1;
    assign c1 = b1 & p1c;
    assign d1 = ~c1;
    assign e1 = d1 & p1d;
    assign f1 = ~e1;
    assign g1 = f1 & b1;
    assign h1 = ~g1;

    assign a2 = p2a & p2b;
    assign b2 = ~a2;
    assign c2 = b2 & p2c;
    assign d2 = ~c2;
    assign e2 = d2 & p2d;
    assign f2 = ~e2;
    assign g2 = f2 & b2;
    assign h2 = ~g2;

    assign p1y = h1;
    assign p2y = h2;

endmodule
