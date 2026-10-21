
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

    
    wire and1a, and1b, and1c, and1d, and1e, and1f;
    wire and2a, and2b, and2c, and2d;
    wire or1a, or1b, or2a, or2b;

    
    assign and1a = p1a & p1b & p1c;
    assign and1b = p1d & p1e & p1f;
    assign and1c = p1a & p1b & p1d;
    assign and1d = p1c & p1e & p1f;
    assign and1e = p1a & p1b & p1e;
    assign and1f = p1c & p1d & p1e;

    assign and2a = p2a & p2b;
    assign and2b = p2c & p2d;

    assign or1a = and1a | and1b;
    assign or1b = and1c | and1d | and1e | and1f;
    assign or2a = and2a | and2b;

    
    assign p1y = or1a | or1b;
    assign p2y = or2a | or2b;

endmodule
