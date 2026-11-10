
module TopModule (
    input wire [99:0] in,
    output reg [99:0] out_and,
    output reg [99:0] out_or,
    output reg [99:0] out_xor
);

    assign out_and = in;
    assign out_or = in;
    assign out_xor = in;

endmodule
