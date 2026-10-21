
module TopModule (
    input p1a, p1b, p1c, p1d,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);

    
    function logic nand2(input logic a, input logic b);
        nand2 = ~a & ~b;
    endfunction

    
    assign p1y = nand2(nand2(p1a, p1b), nand2(p1c, p1d));
    assign p2y = nand2(nand2(p2a, p2b), nand2(p2c, p2d));

endmodule
