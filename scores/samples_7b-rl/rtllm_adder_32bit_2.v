
module cla_16bit (
    input [16:1] A,
    input [16:1] B,
    input cin,
    output [16:1] S,
    output cout
);
    wire [16:1] G, P;
    assign G = A & B;
    assign P = A ^ B;
    
    wire [17:1] C;
    assign C[1] = cin;
    
    generate
        genvar i;
        for (i = 1;
 i <= 16;
 i = i + 1) begin: cla_loop
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate
    
    assign S = P ^ C[16:1];
    assign cout = C[16];
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire carry_mid;
    
    cla_16bit lower_adder (
        .A(A[16:1]),
        .B(B[16:1]),
        .cin(1'b0),
        .S(S[16:1]),
        .cout(carry_mid)
    );
    
    cla_16bit upper_adder (
        .A(A[32:17]),
        .B(B[32:17]),
        .cin(carry_mid),
        .S(S[32:17]),
        .cout(C32)
    );
endmodule
