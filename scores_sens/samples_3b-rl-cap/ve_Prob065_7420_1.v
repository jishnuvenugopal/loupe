
module TopModule (
    p1a,
    p1b,
    p1c,
    p1d,
    p2a,
    p2b,
    p2c,
    p2d,
    p1y,
    p2y
);

    
    input  p1a;
    input  p1b;
    input  p1c;
    input  p1d;
    input  p2a;
    input  p2b;
    input  p2c;
    input  p2d;
    output p1y;
    output p2y;

    
    wire n1;
    wire n2;

    
    
    assign n1 = ~(p1a & p1b);

    
    assign n2 = ~(p2a & p2b);

    
    assign p1y = n1;
    assign p2y = n2;

endmodule
