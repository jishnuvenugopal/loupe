
module TopModule (
    input wire [7:0] a,
    input wire [7:0] b,
    output reg [7:0] s,
    output reg overflow
);

    
    reg [7:0] sum;
    assign sum = a + b;

    
    assign overflow = (sum[7] && !b[7]) || (!sum[7] && b[7]);

endmodule
