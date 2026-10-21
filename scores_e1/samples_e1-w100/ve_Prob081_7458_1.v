
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

    
    wire p1y1, p1y2;

    
    wire p2y1, p2y2;

    
    and3 p1y1_1 (p1y1, p1a, p1b);
    and3 p1y1_2 (p1y1, p1b, p1c);
    and3 p1y1_3 (p1y1, p1c, p1d);
    and3 p1y1_4 (p1y1, p1d, p1e);
    and3 p1y1_5 (p1y1, p1e, p1f);

    
    or2 p1y2_1 (p1y2, p1y1_1, p1y1_2);
    or2 p1y2_2 (p1y2, p1y1_3, p1y1_4);
    or2 p1y2_3 (p1y2, p1y1_5, p1y1_6);

    
    and3 p2y1_1 (p2y1, p2a, p2b);
    and3 p2y1_2 (p2y1, p2b, p2c);
    and3 p2y1_3 (p2y1, p2c, p2d);

    
    or2 p2y2_1 (p2y2, p2y1_1, p2y1_2);
    or2 p2y2_2 (p2y2, p2y1_3, p2y1_4);

    
    assign p1y = p1y2;
    assign p2y = p2y2;

endmodule
