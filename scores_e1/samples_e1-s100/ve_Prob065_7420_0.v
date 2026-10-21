
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

    
    always @(p1a, p1b, p1c, p1d, p2a, p2b, p2c, p2d) begin
        
        p1y = ~((p1a & p1b) | (p1a & p1c) | (p1a & p1d) | (p1b & p1c) | (p1b & p1d) | (p1c & p1d));

        
        p2y = ~((p2a & p2b) | (p2a & p2c) | (p2a & p2d) | (p2b & p2c) | (p2b & p2d) | (p2c & p2d));
    end

endmodule
