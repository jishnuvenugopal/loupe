
module TopModule (
    input clk,
    input x,
    output z
);

    
    reg [1:0] d1, d2, d3;

    
    reg [1:0] xor1, and1, or1;

    
    reg [1:0] xnor1;

    
    initial begin
        d1 = 2'b00;
        d2 = 2'b00;
        d3 = 2'b00;
    end

    
    always @(posedge clk) begin
        
        d1 <= x;
        d2 <= ~d1;
        d3 <= ~d2;

        
        xor1 <= d1 ^ d2;
        and1 <= ~d1 & d2;
        or1 <= ~d1 | d2;

        
        xnor1 <= ~xor1 ^ ~and1 ^ ~or1;
    end

    
    assign z = xnor1;

endmodule
