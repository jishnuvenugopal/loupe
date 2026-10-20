
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

    
    assign n1 = ~(p1a & p1b & p1c & p1d);
    assign n2 = ~(p1a & p1b & p1c & n1);
    assign n3 = ~(p1a & p1b & n1 & n2);
    assign n4 = ~(p1a & n1 & n2 & n3);
    assign n5 = ~(p1b & n1 & n2 & n3);
    assign n6 = ~(p1c & n1 & n2 & n3);
    assign n7 = ~(p1d & n1 & n2 & n3);
    assign p1y = ~(n1 & n2 & n3 & n4 & n5 & n6 & n7);

    
    assign n8 = ~(p2a & p2b & p2c & p2d);
    assign n9 = ~(p2a & p2b & p2c & n8);
    assign n10 = ~(p2a & p2b & n8 & n9);
    assign n11 = ~(p2a & n8 & n9 & n10);
    assign n12 = ~(p2b & n8 & n9 & n10);
    assign n13 = ~(p2c & n8 & n9 & n10);
    assign n14 = ~(p2d & n8 & n9 & n10);
    assign p2y = ~(n8 & n9 & n10 & n11 & n12 & n13 & n14);

endmodule
