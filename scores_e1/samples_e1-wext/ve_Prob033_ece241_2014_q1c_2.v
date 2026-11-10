
module TopModule (
    input wire [7:0] a,
    input wire [7:0] b,
    output reg [7:0] s,
    output reg overflow
);

    
    assign s = a + b;

    
    assign overflow = (s[7] != a[7] || s[7] != b[7]);

endmodule
