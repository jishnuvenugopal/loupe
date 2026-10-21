
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output reg [24:0] out
);

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            out <= 0;
        end else begin
            out <= 0;
            for (int i = 0;
 i < 25;
 i = i + 1) begin
                out[i] = ~a[i] ^ a[i];
                out[i + 1] = ~a[i] ^ b[i];
                out[i + 2] = ~a[i] ^ c[i];
                out[i + 3] = ~a[i] ^ d[i];
                out[i + 4] = ~a[i] ^ e[i];
                out[i + 5] = ~b[i] ^ a[i];
                out[i + 6] = ~b[i] ^ b[i];
                out[i + 7] = ~b[i] ^ c[i];
                out[i + 8] = ~b[i] ^ d[i];
                out[i + 9] = ~b[i] ^ e[i];
                out[i + 10] = ~c[i] ^ a[i];
                out[i + 11] = ~c[i] ^ b[i];
                out[i + 12] = ~c[i] ^ c[i];
                out[i + 13] = ~c[i] ^ d[i];
                out[i + 14] = ~c[i] ^ e[i];
                out[i + 15] = ~d[i] ^ a[i];
                out[i + 16] = ~d[i] ^ b[i];
                out[i + 17] = ~d[i] ^ c[i];
                out[i + 18] = ~d[i] ^ d[i];
                out[i + 19] = ~d[i] ^ e[i];
                out[i + 20] = ~e[i] ^ a[i];
                out[i + 21] = ~e[i] ^ b[i];
                out[i + 22] = ~e[i] ^ c[i];
                out[i + 23] = ~e[i] ^ d[i];
                out[i + 24] = ~e[i] ^ e[i];
            end
        end
    end

endmodule
