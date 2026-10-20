
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

    
    wire and1, and2, and3, and4, and5, and6, and7, and8, and9, and10;

    
    and and1_inst (p1a, p1b, p1c, and1);
    and and2_inst (p1d, p1e, p1f, and2);
    and and3_inst (p2a, p2b, and3);
    and and4_inst (p2c, p2d, and4);

    
    or or1_inst (and1, and2, p1y);
    or or2_inst (and3, and4, p2y);

endmodule
