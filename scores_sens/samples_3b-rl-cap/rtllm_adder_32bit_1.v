
module adder_32bit (
    input  [31:1] A,
    input  [31:1] B,
    output [31:1] S,
    output        C32
);

    
    module cla_16bit (
        input  [15:0] A,
        input  [15:0] B,
        input         C_in,
        output [15:0] S,
        output        C_out
    );

        wire [15:0] C1, C2, C3;
        wire [15:0] S1, S2, S3;

        
        wire [14:0] A1, B1;
        wire        C1_in;
        assign A1 = A[15:1];
        assign B1 = B[15:1];
        assign C1_in = C_in;
        assign S1 = A1 + B1 + C1_in;
        assign C1 = A1 & B1;
        assign C1 = C1 | A1 & C1_in;
        assign C1 = C1 | B1 & C1_in;

        
        wire [14:0] A2, B2;
        wire        C2_in;
        assign A2 = S1[15:1];
        assign B2 = S1[15:1];
        assign C2_in = C1;
        assign S2 = A2 + B2 + C2_in;
        assign C2 = A2 & B2;
        assign C2 = C2 | A2 & C2_in;
        assign C2 = C2 | B2 & C2_in;

        
        wire [14:0] A3, B3;
        wire        C3_in;
        assign A3 = S2[15:1];
        assign B3 = S2[15:1];
        assign C3_in = C2;
        assign S3 = A3 + B3 + C3_in;
        assign C3 = A3 & B3;
        assign C3 = C3 | A3 & C3_in;
        assign C3 = C3 | B3 & C3_in;

        
        assign S = {C3, S3};
        assign C_out = C3;

    endmodule

    
    wire [15:0] A1, B1, A2, B2, A3, B3;
    wire        C1, C2, C3;
    wire [15:0] S1, S2, S3;

    assign A1 = A[15:1];
    assign B1 = B[15:1];
    assign A2 = A[31:16];
    assign B2 = B[31:16];
    assign A3 = S1[15:1];
    assign B3 = S1[15:1];

    cla_16bit ucla1 (
        .A   (A1),
        .B   (B1),
        .C_in(1'b0),
        .S   (S1),
        .C_out(C1)
    );

    cla_16bit ucla2 (
        .A   (A2),
        .B   (B2),
        .C_in(C1),
        .S   (S2),
        .C_out(C2)
    );

    cla_16bit ucla3 (
        .A   (A3),
        .B   (B3),
        .C_in(C2),
        .S   (S3),
        .C_out(C3)
    );

    
    assign S[31:16] = S2;
    assign S[15:0]  = S1;

    
    assign C32 = C3;

endmodule
