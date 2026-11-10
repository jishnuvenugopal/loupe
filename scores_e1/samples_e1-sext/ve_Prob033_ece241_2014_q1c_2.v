
module TopModule (
    input wire [7:0] a,
    input wire [7:0] b,
    output reg [7:0] s,
    output reg overflow
);

    
    assign s = a + b;

    
    assign overflow = (a[7] == 1'b1 && b[7] == 1'b1) && (s[7] == 1'b0);

endmodule
