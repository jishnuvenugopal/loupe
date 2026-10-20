
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

    
    wire n1, n2, n3, n4, n5, n6, n7, n8;
    wire n9, n10, n11, n12, n13, n14, n15, n16;

    
    assign n1 = ~(p1a & p1b);
    assign n2 = ~(p1c & p1d);
    assign n3 = ~(n1 & n2);

    
    assign n4 = ~(p2a & p2b);
    assign n5 = ~(p2c & p2d);
    assign n6 = ~(n4 & n5);

    
    assign p1y = n3;
    assign p2y = n6;

endmodule
