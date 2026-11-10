
module adder_32bit (
    input wire [15:0] A[3:0],
    input wire [15:0] B[3:0],
    output reg [31:0] S,
    output reg C32
);


module cla (
    input wire [15:0] A,
    input wire [15:0] B,
    output reg [15:0] S,
    output reg C
);

    always @(*) begin
        S = A + B;
        C = S[16];
    end

endmodule


assign S[31:16] = cla1.S;
assign S[15:0] = cla2.S;
assign C32 = cla3.C;


cla cla1 (
    .A(A[3]),
    .B(B[3]),
    .S(S[31:16]),
    .C(C[3])
);

cla cla2 (
    .A(A[2]),
    .B(B[2]),
    .S(S[15:8]),
    .C(C[2])
);

cla cla3 (
    .A(A[1]),
    .B(B[1]),
    .S(S[7:0]),
    .C(C[1])
);

cla cla4 (
    .A(A[0]),
    .B(B[0]),
    .S(S[0]),
    .C(C[0])
);

endmodule
