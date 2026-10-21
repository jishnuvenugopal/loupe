
module TopModule (
    input p1a, p1b, p1c, p1d,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);

    
    reg [3:0] nand1_a, nand1_b, nand1_c, nand1_d;
    reg [3:0] nand2_a, nand2_b, nand2_c, nand2_d;

    
    assign nand1_a = p1a & p1b & p1c & p1d;
    assign nand1_b = p1a & p1b & p1c & p1d;
    assign nand1_c = p1a & p1b & p1c & p1d;
    assign nand1_d = p1a & p1b & p1c & p1d;
    assign nand2_a = nand1_a & nand1_b & nand1_c & nand1_d;
    assign nand2_b = nand1_a & nand1_b & nand1_c & nand1_d;
    assign nand2_c = nand1_a & nand1_b & nand1_c & nand1_d;
    assign nand2_d = nand1_a & nand1_b & nand1_c & nand1_d;

    
    assign p1y = nand2_a;
    assign p2y = nand2_b;

endmodule
