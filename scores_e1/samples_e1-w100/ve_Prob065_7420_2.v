
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

    
    reg [3:0] nand1_out;
    reg [3:0] nand2_out;

    
    always @(p1a, p1b, p1c, p1d) begin
        nand1_out = ~p1a & ~p1b & ~p1c & ~p1d;
    end

    
    always @(p2a, p2b, p2c, p2d) begin
        nand2_out = ~p2a & ~p2b & ~p2c & ~p2d;
    end

    
    assign p1y = nand1_out;
    assign p2y = nand2_out;

endmodule
