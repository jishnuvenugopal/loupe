

module CLA16 (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        C_in,
    output reg  [15:0] S,
    output reg        C_out
);

    
    wire [4:0] C;

    
    assign C[0] = C_in;
    assign C[1] = A[14] & B[14] | A[14] & C_in | A[15] & B[14] | A[15] & C_in;
    assign C[2] = A[13] & B[13] | A[13] & C[1] | A[14] & B[13] | A[14] & C[1] | A[15] & B[13] | A[15] & C[1];
    assign C[3] = A[12] & B[12] | A[12] & C[2] | A[13] & B[12] | A[13] & C[2] | A[14] & B[12] | A[14] & C[2] | A[15] & B[12] | A[15] & C[2];
    assign C[4] = A[11] & B[11] | A[11] & C[3] | A[12] & B[11] | A[12] & C[3] | A[13] & B[11] | A[13] & C[3] | A[14] & B[11] | A[14] & C[3] | A[15] & B[11] | A[15] & C[3];
    assign C_out = A[10] & B[10] | A[10] & C[4] | A[11] & B[10] | A[11] & C[4] | A[12] & B[10] | A[12] & C[4] | A[13] & B[10] | A[13] & C[4] | A[14] & B[10] | A[14] & C[4] | A[15] & B[10] | A[15] & C[4];

    
    assign S[15] = A[15] ^ B[15] ^ C_out;
    assign S[14] = A[14] ^ B[14] ^ C[0];
    assign S[13] = A[13] ^ B[13] ^ C[1];
    assign S[12] = A[12] ^ B[12] ^ C[2];
    assign S[11] = A[11] ^ B[11] ^ C[3];
    assign S[10] = A[10] ^ B[10] ^ C[4];
    assign S[9]  = A[9]  ^ B[9]  ^ C[5];
    assign S[8]  = A[8]  ^ B[8]  ^ C[6];
    assign S[7]  = A[7]  ^ B[7]  ^ C[7];
    assign S[6]  = A[6]  ^ B[6]  ^ C[8];
    assign S[5]  = A[5]  ^ B[5]  ^ C[9];
    assign S[4]  = A[4]  ^ B[4]  ^ C[10];
    assign S[3]  = A[3]  ^ B[3]  ^ C[11];
    assign S[2]  = A[2]  ^ B[2]  ^ C[12];
    assign S[1]  = A[1]  ^ B[1]  ^ C[13];
    assign S[0]  = A[0]  ^ B[0]  ^ C[14];

endmodule


module adder_32bit (
    input  wire [31:1] A,
    input  wire [31:1] B,
    output wire [31:1] S,
    output wire        C32
);

    wire [15:0] A16, B16;
    wire [15:0] S16, S17;
    wire        C16, C17;

    
    assign A16 = A[31:16];
    assign B16 = B[31:16];

    
    CLA16 uCLA16 (
        .A(A16),
        .B(B16),
        .C_in(1'b0),
        .S(S16),
        .C_out(C16)
    );

    
    assign A16 = A[15:0];
    assign B16 = B[15:0];

    
    CLA16 uCLA17 (
        .A(A16),
        .B(B16),
        .C_in(C16),
        .S(S17),
        .C_out(C17)
    );

    
    assign S = {S17, S16};
    assign C32 = C17;

endmodule
