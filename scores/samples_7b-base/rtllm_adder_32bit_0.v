
module cla_16bit (A, B, Cin, S, Cout);
    input [15:0] A, B;
    input Cin;
    output [15:0] S;
    output Cout;

    wire [15:0] G, P, C_propagate, C_generate;

    
    generate
        for (genvar i = 0;
 i < 16;
 i++) begin : generate_bits
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] | B[i];
        end
    endgenerate

    
    assign C_propagate[0] = Cin;
    generate
        for (genvar i = 1;
 i < 16;
 i++) begin : propagate_bits
            assign C_propagate[i] = C_propagate[i-1] | P[i-1];
        end
    endgenerate

    
    assign C_generate[0] = G[0];
    generate
        for (genvar i = 1;
 i < 16;
 i++) begin : generate_and_propagate
            assign C_generate[i] = G[i] | (P[i] & C_generate[i-1]);
        end
    endgenerate

    
    generate
        for (genvar i = 0;
 i < 16;
 i++) begin : sum_bits
            assign S[i] = A[i] ^ B[i] ^ C_propagate[i];
        end
    endgenerate

    
    assign Cout = C_propagate[15] | C_generate[15];
endmodule

module adder_32bit (A, B, S, C32);
    input [31:0] A, B;
    output reg [31:0] S;
    output reg C32;

    wire [15:0] S_16, S_16_cin;
    wire C16, C16_cin;

    
    cla_16bit clA (.A(A[15:0]), .B(B[15:0]), .Cin(1'b0), .S(S_16), .Cout(C16));
    cla_16bit clB (.A(A[31:16]), .B(B[31:16]), .Cin(C16), .S(S_16_cin), .Cout(C16_cin));

    
    assign S[15:0] = S_16;
    assign S[31:16] = S_16_cin;
    assign C32 = C16_cin;
endmodule
