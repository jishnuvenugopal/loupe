
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
            out <= 25'b0;
        end else begin
            for (int i = 0;
 i < 25;
 i = i + 1) begin
                out[i] = ~a[i] ^ a[i];
                out[i + 1] = ~a[i + 1] ^ b[i];
                out[i + 2] = ~a[i + 2] ^ c[i];
                out[i + 3] = ~a[i + 3] ^ d[i];
                out[i + 4] = ~a[i + 4] ^ e[i];
                out[i + 5] = ~b[i + 5] ^ a[i + 5];
                out[i + 6] = ~b[i + 6] ^ b[i + 6];
                out[i + 7] = ~b[i + 7] ^ c[i + 7];
                out[i + 8] = ~b[i + 8] ^ d[i + 8];
                out[i + 9] = ~b[i + 9] ^ e[i + 9];
                out[i + 10] = ~c[i + 10] ^ a[i + 10];
                out[i + 11] = ~c[i + 11] ^ b[i + 11];
                out[i + 12] = ~c[i + 12] ^ c[i + 12];
                out[i + 13] = ~c[i + 13] ^ d[i + 13];
                out[i + 14] = ~c[i + 14] ^ e[i + 14];
                out[i + 15] = ~d[i + 15] ^ a[i + 15];
                out[i + 16] = ~d[i + 16] ^ b[i + 16];
                out[i + 17] = ~d[i + 17] ^ c[i + 17];
                out[i + 18] = ~d[i + 18] ^ d[i + 18];
                out[i + 19] = ~d[i + 19] ^ e[i + 19];
                out[i + 20] = ~e[i + 20] ^ a[i + 20];
                out[i + 21] = ~e[i + 21] ^ b[i + 21];
                out[i + 22] = ~e[i + 22] ^ c[i + 22];
                out[i + 23] = ~e[i + 23] ^ d[i + 23];
                out[i + 24] = ~e[i + 24] ^ e[i + 24];
            end
        end
    end

endmodule
