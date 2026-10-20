
module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire carry_mid;
    
    
    cla_16bit lower (
        .A(A[16:1]),
        .B(B[16:1]),
        .cin(1'b0),
        .S(S[16:1]),
        .cout(carry_mid)
    );
    
    
    cla_16bit upper (
        .A(A[32:17]),
        .B(B[32:17]),
        .cin(carry_mid),
        .S(S[32:17]),
        .cout(C32)
    );
endmodule

module cla_16bit (
    input [16:1] A,
    input [16:1] B,
    input cin,
    output [16:1] S,
    output cout
);
    wire [16:1] p, g;
    wire [17:1] carry;
    
    assign carry[1] = cin;
    
    generate
        genvar i;
        for (i = 1;
 i <= 16;
 i = i + 1) begin : gen_cla
            assign p[i] = A[i] ^ B[i];
            assign g[i] = A[i] & B[i];
            assign carry[i+1] = g[i] | (p[i] & carry[i]);
            assign S[i] = p[i] ^ carry[i];
        end
    endgenerate
    
    assign cout = carry[17];
endmodule
