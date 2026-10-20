
module adder_32bit (
    input [31:0] A,
    input [31:0] B,
    output reg [31:0] S,
    output reg C32
);

    
    adder_16bit cla1 (
        .A(A[31:16]),
        .B(B[31:16]),
        .S(S[31:16]),
        .Cout(C32)
    );

    adder_16bit cla2 (
        .A(A[15:0]),
        .B(B[15:0]),
        .S(S[15:0]),
        .Cout(C32)
    );

endmodule

module adder_16bit (
    input [15:0] A,
    input [15:0] B,
    output reg [15:0] S,
    output reg Cout
);

    
    wire [15:0] C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15;
    wire [15:0] C16;

    
    generate
        for (genvar i = 0;
 i < 16;
 i++) begin
            assign C1[i] = A[i] & B[i];
            assign C2[i] = A[i] & C1[i];
            assign C3[i] = B[i] & C1[i];
            assign C4[i] = A[i] & C2[i];
            assign C5[i] = B[i] & C2[i];
            assign C6[i] = A[i] & C3[i];
            assign C7[i] = B[i] & C3[i];
            assign C8[i] = A[i] & C4[i];
            assign C9[i] = B[i] & C4[i];
            assign C10[i] = A[i] & C5[i];
            assign C11[i] = B[i] & C5[i];
            assign C12[i] = A[i] & C6[i];
            assign C13[i] = B[i] & C6[i];
            assign C14[i] = A[i] & C7[i];
            assign C15[i] = B[i] & C7[i];
        end
    endgenerate

    
    assign C16 = C15 | C14 | C13 | C12 | C11 | C10 | C9 | C8 | C7 | C6 | C5 | C4 | C3 | C2 | C1;

    
    assign S = A + B + C16;
    assign Cout = C16;

endmodule
