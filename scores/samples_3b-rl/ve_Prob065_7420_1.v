
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

    
    wire nand1, nand2, nand3, nand4;

    
    assign nand1 = ~(p1a & p1b);

    
    assign nand2 = ~(p1c & p1d);

    
    assign nand3 = ~(p2a & p2b);

    
    assign nand4 = ~(p2c & p2d);

    
    assign p1y = nand1;
    assign p2y = nand3;

endmodule
