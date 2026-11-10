
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output reg [24:0] out
);

    always @(*) begin
        for (int i = 0;
 i < 25;
 i = i + 1) begin
            out[i] = ~a ^ a;
            out[i + 1] = ~a ^ b;
            out[i + 2] = ~a ^ c;
            out[i + 3] = ~a ^ d;
            out[i + 4] = ~a ^ e;
            out[i + 5] = ~b ^ a;
            out[i + 6] = ~b ^ b;
            out[i + 7] = ~b ^ c;
            out[i + 8] = ~b ^ d;
            out[i + 9] = ~b ^ e;
            out[i + 10] = ~c ^ a;
            out[i + 11] = ~c ^ b;
            out[i + 12] = ~c ^ c;
            out[i + 13] = ~c ^ d;
            out[i + 14] = ~c ^ e;
            out[i + 15] = ~d ^ a;
            out[i + 16] = ~d ^ b;
            out[i + 17] = ~d ^ c;
            out[i + 18] = ~d ^ d;
            out[i + 19] = ~d ^ e;
            out[i + 20] = ~e ^ a;
            out[i + 21] = ~e ^ b;
            out[i + 22] = ~e ^ c;
            out[i + 23] = ~e ^ d;
            out[i + 24] = ~e ^ e;
        end
    end

endmodule
