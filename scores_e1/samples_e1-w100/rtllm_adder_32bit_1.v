
module cla_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    output wire [15:0] s,
    output wire c
);

    wire [15:0] a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15;
    wire [15:0] b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15;
    wire [15:0] s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15;
    wire [15:0] c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15;

    assign a1 = a[15];
    assign a2 = a[14];
    assign a3 = a[13];
    assign a4 = a[12];
    assign a5 = a[11];
    assign a6 = a[10];
    assign a7 = a[9];
    assign a8 = a[8];
    assign a9 = a[7];
    assign a10 = a[6];
    assign a11 = a[5];
    assign a12 = a[4];
    assign a13 = a[3];
    assign a14 = a[2];
    assign a15 = a[1];

    assign b1 = b[15];
    assign b2 = b[14];
    assign b3 = b[13];
    assign b4 = b[12];
    assign b5 = b[11];
    assign b6 = b[10];
    assign b7 = b[9];
    assign b8 = b[8];
    assign b9 = b[7];
    assign b10 = b[6];
    assign b11 = b[5];
    assign b12 = b[4];
    assign b13 = b[3];
    assign b14 = b[2];
    assign b15 = b[1];

    assign s1 = a1 ^ b1 ^ c;
    assign s2 = a2 ^ b2 ^ c;
    assign s3 = a3 ^ b3 ^ c;
    assign s4 = a4 ^ b4 ^ c;
    assign s5 = a5 ^ b5 ^ c;
    assign s6 = a6 ^ b6 ^ c;
    assign s7 = a7 ^ b7 ^ c;
    assign s8 = a8 ^ b8 ^ c;
    assign s9 = a9 ^ b9 ^ c;
    assign s10 = a10 ^ b10 ^ c;
    assign s11 = a11 ^ b11 ^ c;
    assign s12 = a12 ^ b12 ^ c;
    assign s13 = a13 ^ b13 ^ c;
    assign s14 = a14 ^ b14 ^ c;
    assign s15 = a15 ^ b15 ^ c;

    assign c1 = a1 & b1 | a2 & b2 | a3 & b3 | a4 & b4 | a5 & b5 | a6 & b6 | a7 & b7 | a8 & b8 | a9 & b9 | a10 & b10 | a11 & b11 | a12 & b12 | a13 & b13 | a14 & b14 | a15 & b15;
    assign c2 = a1 & b2 | a2 & b3 | a3 & b4 | a4 & b5 | a5 & b6 | a6 & b7 | a7 & b8 | a8 & b9 | a9 & b10 | a10 & b11 | a11 & b12 | a12 & b13 | a13 & b14 | a14 & b15;
    assign c3 = a1 & b3 | a2 & b4 | a3 & b5 | a4 & b6 | a5 & b7 | a6 & b8 | a7 & b9 | a8 & b10 | a9 & b11 | a10 & b12 | a11 & b13 | a12 & b14 | a13 & b15;
    assign c4 = a1 & b4 | a2 & b5 | a3 & b6 | a4 & b7 | a5 & b8 | a6 & b9 | a7 & b10 | a8 & b11 | a9 & b12 | a10 & b13 | a11 & b14 | a12 & b15;
    assign c5 = a1 & b5 | a2 & b6 | a3 & b7 | a4 & b8 | a5 & b9 | a6 & b10 | a7 & b11 | a8 & b12 | a9 & b13 | a10 & b14 | a11 & b15;
    assign c6 = a1 & b6 | a2 & b7 | a3 & b8 | a4 & b9 | a5 & b10 | a6 & b11 | a7 & b12 | a8 & b13 | a9 & b14 | a10 & b15;
    assign c7 = a1 & b7 | a2 & b8 | a3 & b9 | a4 & b10 | a5 & b11 | a6 & b12 | a7 & b13 | a8 & b14 | a9 & b15;
    assign c8 = a1 & b8 | a2 & b9 | a3 & b10 | a4 & b11 | a5 & b12 | a6 & b13 | a7 & b14 | a8 & b15;
    assign c9 = a1 & b9 | a2 & b10 | a3 & b11 | a4 & b12 | a5 & b13 | a6 & b14 | a7 & b15;
    assign c10 = a1 & b10 | a2 & b11 | a3 & b12 | a4 & b13 | a5 & b14 | a6 & b15;
    assign c11 = a1 & b11 | a2 & b12 | a3 & b13 | a4 & b14 | a5 & b15;
    assign c12 = a1 & b12 | a2 & b13 | a3 & b14 | a4 & b15;
    assign c13 = a1 & b13 | a2 & b14 | a3 & b15;
    assign c14 = a1 & b14 | a2 & b15;
    assign c15 = a1 & b15;

endmodule
