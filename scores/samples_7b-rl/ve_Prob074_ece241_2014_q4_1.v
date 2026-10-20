
module TopModule(
    input clk,
    input x,
    output z
);
    reg q1 = 0;
    reg q2 = 0;
    reg q3 = 0;

    
    wire d1 = x ^ q1;
    wire d2 = x & ~q2;
    wire d3 = x | ~q3;

    
    always @(posedge clk) begin
        q1 <= d1;
        q2 <= d2;
        q3 <= d3;
    end

    
    assign z = ~(q1 ^ q2 ^ q3);

endmodule
