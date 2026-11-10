
module TopModule (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire [3:0] c,
    input  wire [3:0] d,
    input  wire [3:0] e,
    output reg [3:0] q
);

assign q = a ^ b ^ c ^ d ^ e;

endmodule
