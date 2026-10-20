
module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input C_in,
    output [3:0] S,
    output G,
    output P,
    output C_out
);
    wire [3:0] G_bit, P_bit;
    wire [4:0] C;

    assign G_bit = A & B;
    assign P_bit = A | B;

    assign C[0] = C_in;
    assign C[1] = G_bit[0] | (P_bit[0] & C[0]);
    assign C[2] = G_bit[1] | (P_bit[1] & C[1]);
    assign C[3] = G_bit[2] | (P_bit[2] & C[2]);
    assign C_out = G_bit[3] | (P_bit[3] & C[3]);

    assign G = G_bit[3] | (P_bit[3] & G_bit[2]) | (P_bit[3] & P_bit[2] & G_bit[1]) | (P_bit[3] & P_bit[2] & P_bit[1] & G_bit[0]);
    assign P = P_bit[3] & P_bit[2] & P_bit[1] & P_bit[0];

    assign S = A ^ B ^ C[3:0];
endmodule

module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input C_in,
    output [15:0] S,
    output C_out
);
    wire [3:0] G_group, P_group;
    wire [4:0] C;

    cla_4bit cla0 (
        .A(A[3:0]),
        .B(B[3:0]),
        .C_in(C[0]),
        .S(S[3:0]),
        .G(G_group[0]),
        .P(P_group[0]),
        .C_out()
    );

    cla_4bit cla1 (
        .A(A[7:4]),
        .B(B[7:4]),
        .C_in(C[1]),
        .S(S[7:4]),
        .G(G_group[1]),
        .P(P_group[1]),
        .C_out()
    );

    cla_4bit cla2 (
        .A(A[11:8]),
        .B(B[11:8]),
        .C_in(C[2]),
        .S(S[11:8]),
        .G(G_group[2]),
        .P(P_group[2]),
        .C_out()
    );

    cla_4bit cla3 (
        .A(A[15:12]),
        .B(B[15:12]),
        .C_in(C[3]),
        .S(S[15:12]),
        .G(G_group[3]),
        .P(P_group[3]),
        .C_out()
    );

    assign C[0] = C_in;
    assign C[1] = G_group[0] | (P_group[0] & C[0]);
    assign C[2] = G_group[1] | (P_group[1] & G_group[0]) | (P_group[1] & P_group[0] & C[0]);
    assign C[3] = G_group[2] | (P_group[2] & G_group[1]) | (P_group[2] & P_group[1] & G_group[0]) | (P_group[2] & P_group[1] & P_group[0] & C[0]);
    assign C_out = G_group[3] | (P_group[3] & G_group[2]) | (P_group[3] & P_group[2] & G_group[1]) | (P_group[3] & P_group[2] & P_group[1] & G_group[0]) | (P_group[3] & P_group[2] & P_group[1] & P_group[0] & C_in);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C16;

    cla_16bit lower (
        .A(A[16:1]),
        .B(B[16:1]),
        .C_in(1'b0),
        .S(S[16:1]),
        .C_out(C16)
    );

    cla_16bit upper (
        .A(A[32:17]),
        .B(B[32:17]),
        .C_in(C16),
        .S(S[32:17]),
        .C_out(C32)
    );
endmodule
