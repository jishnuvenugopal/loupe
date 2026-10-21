
module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    output reg [3:0] q
);

    
    assign q = a ^ b ^ c ^ d;

endmodule
