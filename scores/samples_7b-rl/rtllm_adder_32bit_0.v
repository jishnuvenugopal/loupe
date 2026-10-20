
module cla_16bit (
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output G,
    output P
);
    wire [16:1] G_i;
    wire [16:1] P_i;
    wire [17:1] carry;

    assign carry[1] = C_in;

    
    genvar i;
    generate
        for (i = 1;
 i <= 16;
 i = i + 1) begin : gp
            assign G_i[i] = A[i] & B[i];
            assign P_i[i] = A[i] ^ B[i];
        end
    endgenerate

    
    genvar j;
    generate
        for (j = 1;
 j <= 16;
 j = j + 1) begin : carry_chain
            assign carry[j + 1] = G_i[j] | (P_i[j] & carry[j]);
        end
    endgenerate

    
    assign S = P_i ^ carry[16:1];

    
    wire [16:1] G_terms;
    genvar m;
    generate
        for (m = 1;
 m <= 16;
 m = m + 1) begin : g_terms_gen
            if (m == 16) begin
                assign G_terms[m] = G_i[m];
            end else begin
                assign G_terms[m] = G_i[m] & (& P_i[m+1 : 16]);
            end
        end
    endgenerate

    
    wire G_grp, P_grp;
    assign G_grp = |G_terms;
    assign P_grp = &P_i;

    assign G = G_grp;
    assign P = P_grp;

endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire G_low, P_low, G_high, P_high;
    wire C_in_high;

    
    cla_16bit lower (
        .A(A[16:1]),
        .B(B[16:1]),
        .C_in(1'b0),
        .S(S[16:1]),
        .G(G_low),
        .P(P_low)
    );

    assign C_in_high = G_low;

    
    cla_16bit upper (
        .A(A[32:17]),
        .B(B[32:17]),
        .C_in(C_in_high),
        .S(S[32:17]),
        .G(G_high),
        .P(P_high)
    );

    
    assign C32 = G_high | (P_high & C_in_high);

endmodule
