
module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output reg [24:0] out
);

    
    for (int i = 0;
 i < 5;
 i++) begin
        for (int j = i + 1;
 j < 5;
 j++) begin
            
            out[i * 5 + j] = ~a ^ a;
            out[i * 5 + j + 1] = ~a ^ b;
            out[i * 5 + j + 2] = ~a ^ c;
            out[i * 5 + j + 3] = ~a ^ d;
            out[i * 5 + j + 4] = ~a ^ e;
            out[i * 5 + j + 5] = ~b ^ a;
            out[i * 5 + j + 6] = ~b ^ b;
            out[i * 5 + j + 7] = ~b ^ c;
            out[i * 5 + j + 8] = ~b ^ d;
            out[i * 5 + j + 9] = ~b ^ e;
            out[i * 5 + j + 10] = ~c ^ a;
            out[i * 5 + j + 11] = ~c ^ b;
            out[i * 5 + j + 12] = ~c ^ c;
            out[i * 5 + j + 13] = ~c ^ d;
            out[i * 5 + j + 14] = ~c ^ e;
            out[i * 5 + j + 15] = ~d ^ a;
            out[i * 5 + j + 16] = ~d ^ b;
            out[i * 5 + j + 17] = ~d ^ c;
            out[i * 5 + j + 18] = ~d ^ d;
            out[i * 5 + j + 19] = ~d ^ e;
            out[i * 5 + j + 20] = ~e ^ a;
            out[i * 5 + j + 21] = ~e ^ b;
            out[i * 5 + j + 22] = ~e ^ c;
            out[i * 5 + j + 23] = ~e ^ d;
            out[i * 5 + j + 24] = ~e ^ e;
        end
    end

endmodule
