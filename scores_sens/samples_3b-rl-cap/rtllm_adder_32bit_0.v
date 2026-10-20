
module adder_32bit (
    input  wire [31:1] A,
    input  wire [31:1] B,
    output reg  [31:1] S,
    output reg         C32
);

    
    module cla16 (
        input  wire [15:0] A,
        input  wire [15:0] B,
        input  wire        cin,
        output reg  [15:0] S,
        output reg         cout
    );

        
        wire [15:0] c1, c2, c3, c4;
        wire [15:0] p1, p2, p3, p4;

        
        assign p1 = A[15:0] + B[15:0];
        assign p2 = A[15:0] + B[15:0] + c1;
        assign p3 = A[15:0] + B[15:0] + c2;
        assign p4 = A[15:0] + B[15:0] + c3;

        assign c1 = p1[15];
        assign c2 = p2[15];
        assign c3 = p3[15];
        assign c4 = p4[15];

        
        assign S[15] = p1[14:0];
        assign S[14] = p2[14:0];
        assign S[13] = p3[14:0];
        assign S[12] = p4[14:0];
        assign S[11] = p1[13:0];
        assign S[10] = p2[13:0];
        assign S[9]  = p3[13:0];
        assign S[8]  = p4[13:0];
        assign S[7]  = p1[12:0];
        assign S[6]  = p2[12:0];
        assign S[5]  = p3[12:0];
        assign S[4]  = p4[12:0];
        assign S[3]  = p1[11:0];
        assign S[2]  = p2[11:0];
        assign S[1]  = p3[11:0];
        assign S[0]  = p4[11:0];

        
        assign cout = c4;

    endmodule

    
    wire [15:0] A16, B16;
    wire [15:0] S16[3];
    wire [15:0] c16[3];
    wire        c32[3];

    assign A16 = {A[31:16], 16'b0};
    assign B16 = {B[31:16], 16'b0};

    
    cla16 ucla1 (
        .A  (A16[15:0]),
        .B  (B16[15:0]),
        .cin(1'b0),
        .S  (S16[0]),
        .cout(c16[0])
    );

    
    cla16 ucla2 (
        .A  (A16[31:16]),
        .B  (B16[31:16]),
        .cin(c16[0]),
        .S  (S16[1]),
        .cout(c16[1])
    );

    
    cla16 ucla3 (
        .A  (16'b0),
        .B  (16'b0),
        .cin(c16[1]),
        .S  (S16[2]),
        .cout(c16[2])
    );

    
    assign c32[31] = c16[2];

    
    assign S[31:16] = S16[2];
    assign S[15:0]  = S16[1];

    
    assign C32 = c32[31];

endmodule
