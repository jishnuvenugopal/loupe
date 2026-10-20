
module TopModule (
    input [7:0] in,
    output parity
);

    wire [7:0] xor_result;
    assign xor_result = in[0] ^ in[1] ^ in[2] ^ in[3] ^ in[4] ^ in[5] ^ in[6] ^ in[7];
    assign parity = (xor_result == 0) ? 1'b1 : 1'b0;

endmodule
