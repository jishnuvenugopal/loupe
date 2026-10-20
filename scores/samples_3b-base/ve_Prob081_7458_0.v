
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

    
    wire and1, and2, and3, and4;

    
    and1 = p1a & p1b & p1c;
    and2 = p1d & p1e & p1f;
    and3 = p2a & p2b;
    and4 = p2c & p2d;

    
    p1y = and1 | and2;
    p2y = and3 | and4;

endmodule
