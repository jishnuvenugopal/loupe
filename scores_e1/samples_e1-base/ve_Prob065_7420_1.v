
module TopModule (
    input  p1a, p1b, p1c, p1d,
    input  p2a, p2b, p2c, p2d,
    output p1y,
    output p2y
);

    
    reg [3:0] nand1;
    reg [3:0] nand2;

    
    reg [1:0] p1y;
    reg [1:0] p2y;

    
    assign nand1 = p1a & ~p1b & ~p1c & ~p1d;
    assign nand2 = p2a & ~p2b & ~p2c & ~p2d;

    
    assign p1y = nand1;
    assign p2y = nand2;

endmodule
