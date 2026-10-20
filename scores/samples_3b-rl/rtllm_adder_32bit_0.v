
module adder_32bit (
    input  wire [31:1] A,
    input  wire [31:1] B,
    output reg  [31:1] S,
    output reg        C32
);

    
    module cla_16bit (
        input  wire [15:0] A,
        input  wire [15:0] B,
        input  wire        cin,
        output reg  [15:0] S,
        output reg         cout
    );

        wire [3:0] c;
        assign c[0] = A[15] ^ B[15];
        assign c[1] = A[15] ^ B[14];
        assign c[2] = A[14] ^ B[15];
        assign c[3] = A[14] ^ B[14];

        assign c[0] = c[0] | c[1];
        assign c[2] = c[2] | c[3];
        assign c[1] = c[1] | c[2];
        assign c[3] = c[3] | c[0];

        assign S[15] = A[15] ^ B[15] ^ cin;
        assign S[14] = A[14] ^ B[14] ^ c[0];
        assign S[13] = A[13] ^ B[13] ^ c[1];
        assign S[12] = A[12] ^ B[12] ^ c[2];
        assign S[11] = A[11] ^ B[11] ^ c[3];
        assign S[10] = A[10] ^ B[10] ^ c[0];
        assign S[ 9] = A[ 9] ^ B[ 9] ^ c[1];
        assign S[ 8] = A[ 8] ^ B[ 8] ^ c[2];
        assign S[ 7] = A[ 7] ^ B[ 7] ^ c[3];
        assign S[ 6] = A[ 6] ^ B[ 6] ^ c[0];
        assign S[ 5] = A[ 5] ^ B[ 5] ^ c[1];
        assign S[ 4] = A[ 4] ^ B[ 4] ^ c[2];
        assign S[ 3] = A[ 3] ^ B[ 3] ^ c[3];
        assign S[ 2] = A[ 2] ^ B[ 2] ^ c[0];
        assign S[ 1] = A[ 1] ^ B[ 1] ^ c[1];
        assign S[ 0] = A[ 0] ^ B[ 0] ^ c[2];

        assign cout = A[15] ^ B[15] ^ A[14] ^ B[14] ^ A[13] ^ B[13] ^ A[12] ^ B[12] ^ A[11] ^ B[11] ^ A[10] ^ B[10] ^ A[9] ^ B[9] ^ A[8] ^ B[8] ^ A[7] ^ B[7] ^ A[6] ^ B[6] ^ A[5] ^ B[5] ^ A[4] ^ B[4] ^ A[3] ^ B[3] ^ A[2] ^ B[2] ^ A[1] ^ B[1] ^ A[0] ^ B[0];

    endmodule

    
    wire [15:0] A16[2], B16[2];
    wire [15:0] S16[2];
    wire [3:0] c16[2];
    wire [3:0] c32[3];
    wire cin, cout;

    
    assign A16[0] = A[15:0];
    assign A16[1] = A[31:16];
    assign B16[0] = B[15:0];
    assign B16[1] = B[31:16];

    
    cla_16bit ucla1 (
        .A   (A16[0]),
        .B   (B16[0]),
        .cin (cin),
        .S   (S16[0]),
        .cout(c16[0])
    );

    
    cla_16bit ucla2 (
        .A   (A16[1]),
        .B   (B16[1]),
        .cin (c16[0]),
        .S   (S16[1]),
        .cout(c16[1])
    );

    
    assign c32[0] = c16[0];
    assign c32[1] = c16[1];
    assign c32[2] = c16[1];
    assign c32[3] = c16[0];

    
    cla_16bit ucla3 (
        .A   (S16[0]),
        .B   (S16[1]),
        .cin (c32[0]),
        .S   (S[15:0]),
        .cout(c32[1])
    );

    
    cla_16bit ucla4 (
        .A   (S[15:0]),
        .B   (S[31:16]),
        .cin (c32[1]),
        .S   (S[31:16]),
        .cout(c32[2])
    );

    
    assign C32 = c32[2];

endmodule
