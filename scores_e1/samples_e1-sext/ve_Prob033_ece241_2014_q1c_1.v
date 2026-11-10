
module TopModule (
    input wire [7:0] a,
    input wire [7:0] b,
    output reg [7:0] s,
    output reg overflow
);

    
    localparam MAX_SIGNED_8BIT = 2'b1111_1111;

    
    assign s = a + b;

    
    assign overflow = (s[7] == 1'b1) && (a[7] == 1'b1) && (b[7] == 1'b0);

endmodule
