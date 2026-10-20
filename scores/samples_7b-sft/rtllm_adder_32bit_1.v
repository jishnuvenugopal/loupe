
module cla_4bit (
    input [4:1] A,
    input [4:1] B,
    input C_in,
    output [4:1] S,
    output C_out,
    output G,
    output P
);
    wire [4:1] G_i = A & B;
    wire [4:1] P_i = A | B;
    
    wire C1, C2, C3;
    
    assign C1 = G_i[1] | (P_i[1] & C_in);
    assign C2 = G_i[2] | (P_i[2] & G_i[1]) | (P_i[2] & P_i[1] & C_in);
    assign C3 = G_i[3] | (P_i[3] & G_i[2]) | (P_i[3] & P_i[2] & G_i[1]) | (P_i[3] & P_i[2] & P_i[1] & C_in);
    assign C_out = G_i[4] | (P_i[4] & G_i[3]) | (P_i[4] & P_i[3] & G_i[2]) | (P_i[4] & P_i[3] & P_i[2] & G_i[1]) | (P_i[4] & P_i[3] & P_i[2] & P_i[1] & C_in);
    
    assign S[1] = P_i[1] ^ C_in;
    assign S[2] = P_i[2] ^ C1;
    assign S[3] = P_i[3] ^ C2;
    assign S[4] = P_i[4] ^ C3;
    
    assign G = G_i[4] | (P_i[4] & G_i[3]) | (P_i[4] & P_i[3] & G_i[2]) | (P_i[4] & P_i[3] & P_i[2] & G_i[1]);
    assign P = P_i[4] & P_i[3] & P_i[2] & P_i[1];
endmodule

module cla_16bit (
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out,
    output G,
    output P
);
    wire [3:0] G_grp, P_grp;
    wire [4:1] C_internal;
    
    cla_4bit cla0 (
        .A(A[4:1]),
        .B(B[4:1]),
        .C_in(C_in),
        .S(S[4:1]),
        .C_out(C_internal[1]),
        .G(G_grp[0]),
        .P(P_grp[0])
    );
    
    cla_4bit cla1 (
        .A(A[8:5]),
        .B(B[8:5]),
        .C_in(C_internal[1]),
        .S(S[8:5]),
        .C_out(C_internal[2]),
        .G(G_grp[1]),
        .P(P_grp[1])
    );
    
    cla_4bit cla2 (
        .A(A[12:9]),
        .B(B[12:9]),
        .C_in(C_internal[2]),
        .S(S[12:9]),
        .C_out(C_internal[3]),
        .G(G_grp[2]),
        .P(P_grp[2])
    );
    
    cla_4bit cla3 (
        .A(A[16:13]),
        .B(B[16:13]),
        .C_in(C_internal[3]),
        .S(S[16:13]),
        .C_out(C_internal[4]),
        .G(G_grp[3]),
        .P(P_grp[3])
    );
    
    assign G = G_grp[3] | (P_grp[3] & G_grp[2]) | (P_grp[3] & P_grp[2] & G_grp[1]) | (P_grp[3] & P_grp[2] & P_grp[1] & G_grp[0]);
    assign P = P_grp[3] & P_grp[2] & P_grp[1] & P_grp[0];
    assign C_out = C_internal[4];
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C16, G0, P0, G1, P1;
    
    cla_16bit lower (
        .A(A[16:1]),
        .B(B[16:1]),
        .C_in(1'b0),
        .S(S[16:1]),
        .C_out(C16),
        .G(G0),
        .P(P0)
    );
    
    wire C16_upper = G0 | (P0 & 1'b0);
    
    cla_16bit upper (
        .A(A[32:17]),
        .B(B[32:17]),
        .C_in(C16_upper),
        .S(S[32:17]),
        .C_out(C32),
        .G(G1),
        .P(P1)
    );
endmodule
