
module TopModule (
    input wire [3:0] in,
    output reg [3:0] out_and,
    output reg [3:0] out_or,
    output reg [3:0] out_xor
);

    
    assign out_and = in[0] & in[1] & in[2] & in[3];
    assign out_or = in[0] | in[1] | in[2] | in[3];
    assign out_xor = in[0] ^ in[1] ^ in[2] ^ in[3];

endmodule
