
module TopModule (
    input [7:0] in,
    output parity
);

    wire parity_xor;

    assign parity_xor = in[0] ^ in[1] ^ in[2] ^ in[3] ^ in[4] ^ in[5] ^ in[6] ^ in[7];
    assign parity = parity_xor;

endmodule
