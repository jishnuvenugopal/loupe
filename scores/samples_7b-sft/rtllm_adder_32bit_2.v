
module cla_4bit (
    input [4:1] A,
    input [4:1] B,
    input Cin,
    output [4:1] S,
    output P,
    output G,
    output Cout
);
    wire [3:1] p, g;
    wire [4:1] c;
    
    assign p[1] = A[1] | B[1];
    assign p[2] = A[2] | B[2];
    assign p[3] = A[3] | B[3];
    assign p[4] = A[4] | B[4];
    
    assign g[1] = A[1] & B[1];
    assign g[2] = A[2] & B[2];
    assign g[3] = A[3] & B[3];
    assign g[4] = A[4] & B[4];
    
    assign P = p[1] & p[2] & p[3] & p[4];
    assign G = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1]);
    
    assign Cout = G | (P & Cin);
    
    assign c[1] = Cin;
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);
    assign c[5] = g[4] | (p[4] & c[4]);
 
    
    assign S[1] = A[1] ^ B[1] ^ c[1];
    assign S[2] = A[2] ^ B[2] ^ c[2];
    assign S[3] = A[3] ^ B[3] ^ c[3];
    assign S[4] = A[4] ^ B[4] ^ c[4];
    
endmodule

module cla_16bit (
    input [16:1] A,
    input [16:1] B,
    input Cin,
    output [16:1] S,
    output P_group,
    output G_group,
    output Cout
);
    wire [3:0] P, G;
    wire [3:0] C;
    
    assign C[0] = Cin;
    
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
    
    cla_4bit cla4_0 (
        .A(A[4:1]),
        .B(B[4:1]),
        .Cin(C[0]),
        .S(S[4:1]),
        .P(P[0]),
        .G(G[0]),
        .Cout()
    );
    
    cla_4bit cla4_1 (
        .A(A[8:5]),
        .B(B[8:5]),
        .Cin(C[1]),
        .S(S[8:5]),
        .P(P[1]),
        .G(G[1]),
        .Cout()
    );
    
    cla_4bit cla4_2 (
        .A(A[12:9]),
        .B(B[12:9]),
        .Cin(C[2]),
        .S(S[12:9]),
        .P(P[2]),
        .G(G[2]),
        .Cout()
    );
    
    cla_4bit cla4_3 (
        .A(A[16:13]),
        .B(B[16:13]),
        .Cin(C[3]),
        .S(S[16:13]),
        .P(P[3]),
        .G(G[3]),
        .Cout()
    );
    
    assign P_group = P[0] & P[1] & P[2] & P[3];
    assign G_group = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign Cout = G_group | (P_group & Cin);
    
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire P0, G0, Cout0;
    wire P1, G1, Cout1;
    
    cla_16bit cla16_0 (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .P_group(P0),
        .G_group(G0),
        .Cout(Cout0)
    );
    
    cla_16bit cla16_1 (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(Cout0),
        .S(S[32:17]),
        .P_group(P1),
        .G_group(G1),
        .Cout(Cout1)
    );
    
    assign C32 = Cout1;
    
endmodule
