
module adder_32bit (A[31:0], B[31:0], S[31:0], C32);
    input [31:0] A, B;
    output reg [31:0] S;
    output reg C32;

    wire [15:0] S_16_0, S_16_1;
    wire C16_0, C16_1;

    
    cla_16bit cla_16bit_0(A[15:0], B[15:0], 1'b0, S_16_0, C16_0);

    
    cla_16bit cla_16bit_1(A[31:16], B[31:16], C16_0, S_16_1, C16_1);

    
    assign S[15:0] = S_16_0;
    assign S[31:16] = S_16_1;
    assign C32 = C16_1;
endmodule
